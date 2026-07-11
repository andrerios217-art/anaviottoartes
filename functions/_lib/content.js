import { DEFAULT_CONTENT } from "./default-content.js";

export const CONTENT_ID = "main";

export function jsonResponse(data, status = 200) {
  return new Response(JSON.stringify(data, null, 2), {
    status,
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Cache-Control": "no-store"
    }
  });
}

function clone(value) {
  return JSON.parse(JSON.stringify(value));
}

function deepMerge(defaultValue, storedValue) {
  if (Array.isArray(defaultValue)) {
    return Array.isArray(storedValue) ? storedValue : clone(defaultValue);
  }

  if (
    defaultValue &&
    typeof defaultValue === "object" &&
    !Array.isArray(defaultValue)
  ) {
    const result = {};
    const source =
      storedValue && typeof storedValue === "object" && !Array.isArray(storedValue)
        ? storedValue
        : {};

    for (const key of Object.keys(defaultValue)) {
      result[key] = deepMerge(defaultValue[key], source[key]);
    }

    for (const key of Object.keys(source)) {
      if (!(key in result)) result[key] = source[key];
    }

    return result;
  }

  return storedValue === undefined || storedValue === null
    ? defaultValue
    : storedValue;
}

function migrateLegacyContent(stored) {
  if (!stored || stored.schemaVersion === DEFAULT_CONTENT.schemaVersion) {
    return deepMerge(DEFAULT_CONTENT, stored || {});
  }

  const migrated = clone(DEFAULT_CONTENT);

  // Preserva contatos e integrações do site anterior.
  const oldSite = stored.site || {};
  for (const key of [
    "domain",
    "whatsappDisplay",
    "whatsappNumber",
    "whatsappMessage",
    "instagram",
    "instagramHandle",
    "gaId"
  ]) {
    if (oldSite[key]) migrated.site[key] = oldSite[key];
  }

  // Preserva fotos e produtos já cadastrados no D1/R2.
  if (Array.isArray(stored.products) && stored.products.length) {
    migrated.products = stored.products.map((product, index) => ({
      ...(DEFAULT_CONTENT.products[index] || DEFAULT_CONTENT.products[0]),
      ...product
    }));
  }

  migrated.schemaVersion = DEFAULT_CONTENT.schemaVersion;
  return migrated;
}

export async function loadContent(env) {
  if (!env.DB) {
    return {
      content: clone(DEFAULT_CONTENT),
      updated_at: null,
      source: "default"
    };
  }

  const row = await env.DB
    .prepare("SELECT content, updated_at FROM site_content WHERE id = ?")
    .bind(CONTENT_ID)
    .first();

  if (!row || !row.content) {
    return {
      content: clone(DEFAULT_CONTENT),
      updated_at: null,
      source: "default"
    };
  }

  try {
    const parsed = JSON.parse(row.content);
    return {
      content: migrateLegacyContent(parsed),
      updated_at: row.updated_at,
      source: "d1"
    };
  } catch {
    return {
      content: clone(DEFAULT_CONTENT),
      updated_at: null,
      source: "fallback"
    };
  }
}

export async function saveContent(env, content) {
  if (!env.DB) {
    throw new Error("Binding DB não configurado.");
  }

  const normalized = deepMerge(DEFAULT_CONTENT, {
    ...content,
    schemaVersion: DEFAULT_CONTENT.schemaVersion
  });

  const now = new Date().toISOString();

  await env.DB
    .prepare(`
      INSERT INTO site_content (id, content, updated_at)
      VALUES (?, ?, ?)
      ON CONFLICT(id) DO UPDATE SET
        content = excluded.content,
        updated_at = excluded.updated_at
    `)
    .bind(CONTENT_ID, JSON.stringify(normalized), now)
    .run();

  return { content: normalized, updated_at: now };
}


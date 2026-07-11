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

export async function loadContent(env) {
  if (!env.DB) {
    return { content: DEFAULT_CONTENT, updated_at: null, source: "default" };
  }

  const row = await env.DB
    .prepare("SELECT content, updated_at FROM site_content WHERE id = ?")
    .bind(CONTENT_ID)
    .first();

  if (!row || !row.content) {
    return { content: DEFAULT_CONTENT, updated_at: null, source: "default" };
  }

  try {
    return {
      content: JSON.parse(row.content),
      updated_at: row.updated_at,
      source: "d1"
    };
  } catch {
    return { content: DEFAULT_CONTENT, updated_at: null, source: "fallback" };
  }
}

export async function saveContent(env, content) {
  if (!env.DB) {
    throw new Error("Binding DB não configurado.");
  }

  const now = new Date().toISOString();

  await env.DB
    .prepare(`
      INSERT INTO site_content (id, content, updated_at)
      VALUES (?, ?, ?)
      ON CONFLICT(id) DO UPDATE SET
        content = excluded.content,
        updated_at = excluded.updated_at
    `)
    .bind(CONTENT_ID, JSON.stringify(content), now)
    .run();

  return { content, updated_at: now };
}

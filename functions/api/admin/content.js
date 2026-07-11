import { loadContent, saveContent, jsonResponse } from "../../_lib/content.js";
import { requireAdmin } from "../../_lib/auth.js";

export async function onRequestGet({ request, env }) {
  const blocked = requireAdmin(request, env);
  if (blocked) return blocked;

  try {
    return jsonResponse(await loadContent(env));
  } catch (error) {
    return jsonResponse({ error: String(error.message || error) }, 500);
  }
}

export async function onRequestPost({ request, env }) {
  const blocked = requireAdmin(request, env);
  if (blocked) return blocked;

  try {
    const payload = await request.json();
    const content = payload.content || payload;

    if (!content || typeof content !== "object") {
      return jsonResponse({ error: "Conteúdo inválido." }, 400);
    }

    const saved = await saveContent(env, content);
    return jsonResponse({ ok: true, ...saved });
  } catch (error) {
    return jsonResponse({ error: String(error.message || error) }, 500);
  }
}

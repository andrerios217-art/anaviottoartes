import { loadContent, jsonResponse } from "../_lib/content.js";

export async function onRequestGet({ env }) {
  try {
    return jsonResponse(await loadContent(env));
  } catch (error) {
    return jsonResponse({ error: String(error.message || error) }, 500);
  }
}

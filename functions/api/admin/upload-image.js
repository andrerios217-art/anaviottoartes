import { jsonResponse } from "../../_lib/content.js";
import { requireAdmin } from "../../_lib/auth.js";

const ALLOWED_TYPES = new Set([
  "image/jpeg",
  "image/png",
  "image/webp",
  "image/gif"
]);

const MAX_SIZE_BYTES = 5 * 1024 * 1024;

function extensionFromType(type) {
  if (type === "image/jpeg") return "jpg";
  if (type === "image/png") return "png";
  if (type === "image/webp") return "webp";
  if (type === "image/gif") return "gif";
  return "bin";
}

export async function onRequestPost({ request, env }) {
  const blocked = requireAdmin(request, env);
  if (blocked) return blocked;

  if (!env.MEDIA) {
    return jsonResponse({ error: "Binding MEDIA/R2 não configurado." }, 500);
  }

  try {
    const form = await request.formData();
    const file = form.get("file");

    if (!file || typeof file === "string") {
      return jsonResponse({ error: "Envie um arquivo no campo file." }, 400);
    }

    if (!ALLOWED_TYPES.has(file.type)) {
      return jsonResponse({ error: "Formato inválido. Use JPEG, PNG, WebP ou GIF." }, 400);
    }

    if (file.size > MAX_SIZE_BYTES) {
      return jsonResponse({ error: "Imagem muito grande. Limite: 5 MB." }, 400);
    }

    const now = new Date();
    const year = now.getUTCFullYear();
    const month = String(now.getUTCMonth() + 1).padStart(2, "0");
    const ext = extensionFromType(file.type);
    const key = `uploads/${year}/${month}/${crypto.randomUUID()}.${ext}`;

    await env.MEDIA.put(key, await file.arrayBuffer(), {
      httpMetadata: {
        contentType: file.type,
        cacheControl: "public, max-age=31536000"
      },
      customMetadata: {
        originalName: file.name || "upload"
      }
    });

    return jsonResponse({
      ok: true,
      key,
      url: `/media/${key}`
    });
  } catch (error) {
    return jsonResponse({ error: String(error.message || error) }, 500);
  }
}

export async function onRequestGet({ params, env }) {
  if (!env.MEDIA) {
    return new Response("MEDIA binding não configurado.", { status: 500 });
  }

  const rawPath = params.path;
  const key = Array.isArray(rawPath) ? rawPath.join("/") : rawPath;

  if (!key) {
    return new Response("Arquivo não informado.", { status: 400 });
  }

  const object = await env.MEDIA.get(key);

  if (!object) {
    return new Response("Arquivo não encontrado.", { status: 404 });
  }

  const headers = new Headers();
  object.writeHttpMetadata(headers);
  headers.set("etag", object.httpEtag);
  headers.set("Cache-Control", "public, max-age=31536000, immutable");

  return new Response(object.body, { headers });
}

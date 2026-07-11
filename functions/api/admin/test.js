export async function onRequestGet() {
  return new Response(JSON.stringify({
    ok: true,
    message: "API ADMIN LIBERADA",
    date: new Date().toISOString()
  }, null, 2), {
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Cache-Control": "no-store"
    }
  });
}

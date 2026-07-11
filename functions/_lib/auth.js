import { jsonResponse } from "./content.js";

export function requireAdmin(request, env) {
  if (env.ACCESS_BYPASS === "true") {
    return null;
  }

  const email =
    request.headers.get("Cf-Access-Authenticated-User-Email") ||
    request.headers.get("cf-access-authenticated-user-email");

  const jwt =
    request.headers.get("Cf-Access-Jwt-Assertion") ||
    request.headers.get("cf-access-jwt-assertion");

  if (!email && !jwt) {
    return jsonResponse({
      error: "Área administrativa protegida. Configure Cloudflare Access para /admin/* e /api/admin/* ou use ACCESS_BYPASS=true temporariamente."
    }, 403);
  }

  if (env.ADMIN_EMAILS && email) {
    const allowed = env.ADMIN_EMAILS
      .split(",")
      .map((item) => item.trim().toLowerCase())
      .filter(Boolean);

    if (allowed.length && !allowed.includes(email.toLowerCase())) {
      return jsonResponse({ error: "E-mail não autorizado." }, 403);
    }
  }

  return null;
}

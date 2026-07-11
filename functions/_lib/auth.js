import { jsonResponse } from "./content.js";

export function requireAdmin(request, env) {
  // LIBERAÇÃO TEMPORÁRIA PARA TESTE DO PAINEL
  // Depois que o painel estiver funcionando, vamos reativar o Cloudflare Access.
  return null;
}

# Ana Viotto Artesanato

Projeto com Cloudflare Pages + GitHub + painel de edição direta.

## Configuração Cloudflare Pages

- Framework preset: None
- Build command: npm run check
- Build output directory: public
- Root directory: vazio

## D1

Criar banco:

anaviotto-site

Binding:

DB

Rodar migration:

migrations/0001_site_content.sql

## R2

Criar bucket:

anaviotto-media

Binding:

MEDIA

## Variáveis

Para teste temporário:

ACCESS_BYPASS=true

Depois configurar Cloudflare Access e remover o bypass.

Opcional:

ADMIN_EMAILS=email1@exemplo.com,email2@exemplo.com

## Rotas

Site:

/

Painel:

/admin/

API pública:

/api/content

API administrativa:

/api/admin/content

Upload:

/api/admin/upload-image

Mídia R2:

/media/uploads/...

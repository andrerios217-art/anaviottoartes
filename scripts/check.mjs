import { existsSync } from "node:fs";

const required = [
  "public/index.html",
  "public/styles.css",
  "public/app.js",
  "public/default-content.js",
  "public/admin/index.html",
  "public/admin/admin.css",
  "public/admin/admin.js",
  "functions/api/content.js",
  "functions/api/admin/content.js",
  "functions/api/admin/upload-image.js",
  "functions/media/[[path]].js",
  "migrations/0001_site_content.sql"
];

const missing = required.filter((file) => !existsSync(file));

if (missing.length) {
  console.error("Arquivos ausentes:");
  for (const file of missing) console.error("-", file);
  process.exit(1);
}

console.log("Check OK: estrutura pronta para Cloudflare Pages.");

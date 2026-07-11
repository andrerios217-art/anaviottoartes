set -e

echo "Limpando estrutura antiga..."
rm -rf functions migrations public scripts package.json README.md wrangler.toml.example

echo "Criando pastas..."
mkdir -p public/admin public/assets functions/_lib functions/api/admin functions/media migrations scripts

echo "Criando package.json..."
cat > package.json <<'EOF'
{
  "name": "anaviottoartes",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "check": "node scripts/check.mjs"
  }
}
EOF

echo "Criando scripts/check.mjs..."
cat > scripts/check.mjs <<'EOF'
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
EOF

echo "Criando conteúdo padrão..."
cat > functions/_lib/default-content.js <<'EOF'
export const DEFAULT_CONTENT = {
  site: {
    brandName: "Ana Viotto Artesanato",
    domain: "https://anaviottoartes.com.br",
    logo: "/assets/logo.svg",
    whatsappDisplay: "(11) 94971-1535",
    whatsappNumber: "5511949711535",
    whatsappMessage: "Olá, Ana! Vim pelo site e gostaria de fazer uma encomenda.",
    instagram: "https://www.instagram.com/_anaviottoartes",
    instagramHandle: "@_anaviottoartes",
    gaId: "G-PEHV8TH4PG"
  },
  seo: {
    title: "Ana Viotto Artesanato | Cerâmica fria artesanal e presentes personalizados",
    description: "Peças artesanais em cerâmica fria feitas à mão: porta-trecos, incensários, cinzeiros decorativos e presentes personalizados sob encomenda.",
    keywords: "cerâmica fria artesanal, artesanato em cerâmica fria, presentes personalizados, porta-trecos artesanal, incensário artesanal, cinzeiro artesanal, peças artesanais"
  },
  hero: {
    tag: "Cerâmica fria artesanal • Feito à mão",
    title: "Peças artesanais para decorar, presentear e encantar.",
    subtitle: "A Ana Viotto Artesanato cria peças delicadas em cerâmica fria, feitas manualmente, com carinho nos detalhes e personalidade em cada encomenda.",
    note: "Encomendas personalizadas, peças decorativas e presentes artesanais feitos com cuidado."
  },
  about: {
    title: "Artesanato com delicadeza e personalidade",
    subtitle: "Uma página pensada para valorizar o processo artesanal, explicar as encomendas e aproximar cada cliente de uma peça feita com carinho.",
    cardTitle: "Mais do que uma peça, uma lembrança feita à mão.",
    cardText: "Cada criação nasce de um processo cuidadoso: escolha do tema, modelagem, pintura, acabamento e carinho em cada detalhe. O resultado são peças únicas, ideais para decoração, presentes e lembranças personalizadas."
  },
  features: [
    { icon: "👐", title: "Feito à mão", text: "Produção artesanal, sem aparência industrial." },
    { icon: "🎁", title: "Ótimo para presente", text: "Peças afetivas para datas especiais." },
    { icon: "🎨", title: "Personalizável", text: "Cores, temas e detalhes combinados antes da produção." },
    { icon: "🐱", title: "Identidade charmosa", text: "Visual delicado, acolhedor e memorável." }
  ],
  productsIntro: {
    title: "O que você pode encomendar",
    text: "Uma seleção de peças artesanais em cerâmica fria para decoração, presentes e encomendas personalizadas. Novos modelos podem ser feitos sob encomenda."
  },
  products: [
    {
      title: "Porta-trecos artesanal",
      description: "Peça artesanal em cerâmica fria, ideal para guardar pequenos objetos, decorar e deixar o ambiente mais delicado.",
      image: "/assets/porta-trecos.svg",
      alt: "Porta-trecos artesanal em cerâmica fria"
    },
    {
      title: "Incensário / cinzeiro cogumelo",
      description: "Peça artesanal com cogumelo em relevo, feita para decorar e criar um cantinho acolhedor.",
      image: "/assets/incensario.svg",
      alt: "Incensário e cinzeiro artesanal de cogumelo"
    }
  ],
  how: {
    title: "Como funciona a encomenda",
    subtitle: "Um processo simples para alinhar expectativas, prazo e detalhes antes da produção.",
    steps: [
      { title: "Você envia sua ideia", text: "Escolha uma peça da vitrine, veja inspirações no Instagram ou envie uma referência do que deseja." },
      { title: "Combinamos os detalhes", text: "Tema, cores, tamanho, prazo e valor são definidos antes da produção." },
      { title: "A peça é produzida", text: "Tudo é feito manualmente, com cuidado no acabamento e nos detalhes." },
      { title: "Você recebe sua arte", text: "A retirada ou o envio são combinados de acordo com a disponibilidade." }
    ]
  },
  care: {
    title: "Cuidados com sua peça artesanal",
    subtitle: "Peças em cerâmica fria são delicadas e duram mais quando recebem alguns cuidados simples no dia a dia.",
    items: [
      { icon: "🧼", title: "Limpeza delicada", text: "Use pano seco ou levemente úmido. Depois, seque a peça imediatamente com um pano macio." },
      { icon: "💧", title: "Evite água e umidade", text: "Não lave em água corrente, não deixe de molho e evite locais úmidos, chuva ou vapor excessivo." },
      { icon: "☀️", title: "Proteja do sol e do calor", text: "Evite sol direto, calor intenso, micro-ondas, lava-louças ou contato com fontes de calor." },
      { icon: "🤲", title: "Manuseie com cuidado", text: "Evite quedas, impactos, atritos e pressão sobre detalhes pequenos ou partes em relevo." },
      { icon: "🧴", title: "Não use produtos fortes", text: "Evite álcool, alvejantes, amoníaco, produtos abrasivos, palha de aço ou escovas duras." },
      { icon: "🏡", title: "Guarde em local seguro", text: "Mantenha a peça em local seco, arejado e protegido para preservar pintura, verniz e acabamento." }
    ],
    note: "Por ser uma peça artesanal, pequenas variações fazem parte do processo manual. O cuidado correto ajuda a preservar a beleza, os detalhes e a durabilidade da sua peça."
  },
  seoSection: {
    title: "Artesanato em cerâmica fria feito à mão",
    paragraphs: [
      "A Ana Viotto Artesanato cria peças artesanais em cerâmica fria para decoração, presentes personalizados e encomendas especiais.",
      "Cada peça é produzida com cuidado nos detalhes, podendo receber cores, temas e acabamentos personalizados de acordo com a ideia do cliente."
    ]
  },
  faq: [
    { question: "As peças são prontas ou sob encomenda?", answer: "Algumas peças podem estar disponíveis para pronta entrega, mas a maioria pode ser feita sob encomenda." },
    { question: "Dá para personalizar?", answer: "Sim. As peças podem ser personalizadas de acordo com a ideia do cliente, incluindo tema, cores, nome, detalhes e estilo." },
    { question: "Qual é o prazo de produção?", answer: "O prazo depende do tamanho, dos detalhes e da complexidade da peça. Antes de iniciar, a Ana informa o prazo estimado." },
    { question: "Como faço para pedir?", answer: "Para fazer uma encomenda, chame pelo WhatsApp ou visite o Instagram @_anaviottoartes." }
  ]
};
EOF

cat > public/default-content.js <<'EOF'
window.DEFAULT_CONTENT = {
  site: {
    brandName: "Ana Viotto Artesanato",
    domain: "https://anaviottoartes.com.br",
    logo: "/assets/logo.svg",
    whatsappDisplay: "(11) 94971-1535",
    whatsappNumber: "5511949711535",
    whatsappMessage: "Olá, Ana! Vim pelo site e gostaria de fazer uma encomenda.",
    instagram: "https://www.instagram.com/_anaviottoartes",
    instagramHandle: "@_anaviottoartes",
    gaId: "G-PEHV8TH4PG"
  },
  seo: {
    title: "Ana Viotto Artesanato | Cerâmica fria artesanal e presentes personalizados",
    description: "Peças artesanais em cerâmica fria feitas à mão: porta-trecos, incensários, cinzeiros decorativos e presentes personalizados sob encomenda.",
    keywords: "cerâmica fria artesanal, artesanato em cerâmica fria, presentes personalizados, porta-trecos artesanal, incensário artesanal, cinzeiro artesanal, peças artesanais"
  },
  hero: {
    tag: "Cerâmica fria artesanal • Feito à mão",
    title: "Peças artesanais para decorar, presentear e encantar.",
    subtitle: "A Ana Viotto Artesanato cria peças delicadas em cerâmica fria, feitas manualmente, com carinho nos detalhes e personalidade em cada encomenda.",
    note: "Encomendas personalizadas, peças decorativas e presentes artesanais feitos com cuidado."
  },
  about: {
    title: "Artesanato com delicadeza e personalidade",
    subtitle: "Uma página pensada para valorizar o processo artesanal, explicar as encomendas e aproximar cada cliente de uma peça feita com carinho.",
    cardTitle: "Mais do que uma peça, uma lembrança feita à mão.",
    cardText: "Cada criação nasce de um processo cuidadoso: escolha do tema, modelagem, pintura, acabamento e carinho em cada detalhe. O resultado são peças únicas, ideais para decoração, presentes e lembranças personalizadas."
  },
  features: [
    { icon: "👐", title: "Feito à mão", text: "Produção artesanal, sem aparência industrial." },
    { icon: "🎁", title: "Ótimo para presente", text: "Peças afetivas para datas especiais." },
    { icon: "🎨", title: "Personalizável", text: "Cores, temas e detalhes combinados antes da produção." },
    { icon: "🐱", title: "Identidade charmosa", text: "Visual delicado, acolhedor e memorável." }
  ],
  productsIntro: {
    title: "O que você pode encomendar",
    text: "Uma seleção de peças artesanais em cerâmica fria para decoração, presentes e encomendas personalizadas. Novos modelos podem ser feitos sob encomenda."
  },
  products: [
    {
      title: "Porta-trecos artesanal",
      description: "Peça artesanal em cerâmica fria, ideal para guardar pequenos objetos, decorar e deixar o ambiente mais delicado.",
      image: "/assets/porta-trecos.svg",
      alt: "Porta-trecos artesanal em cerâmica fria"
    },
    {
      title: "Incensário / cinzeiro cogumelo",
      description: "Peça artesanal com cogumelo em relevo, feita para decorar e criar um cantinho acolhedor.",
      image: "/assets/incensario.svg",
      alt: "Incensário e cinzeiro artesanal de cogumelo"
    }
  ],
  how: {
    title: "Como funciona a encomenda",
    subtitle: "Um processo simples para alinhar expectativas, prazo e detalhes antes da produção.",
    steps: [
      { title: "Você envia sua ideia", text: "Escolha uma peça da vitrine, veja inspirações no Instagram ou envie uma referência do que deseja." },
      { title: "Combinamos os detalhes", text: "Tema, cores, tamanho, prazo e valor são definidos antes da produção." },
      { title: "A peça é produzida", text: "Tudo é feito manualmente, com cuidado no acabamento e nos detalhes." },
      { title: "Você recebe sua arte", text: "A retirada ou o envio são combinados de acordo com a disponibilidade." }
    ]
  },
  care: {
    title: "Cuidados com sua peça artesanal",
    subtitle: "Peças em cerâmica fria são delicadas e duram mais quando recebem alguns cuidados simples no dia a dia.",
    items: [
      { icon: "🧼", title: "Limpeza delicada", text: "Use pano seco ou levemente úmido. Depois, seque a peça imediatamente com um pano macio." },
      { icon: "💧", title: "Evite água e umidade", text: "Não lave em água corrente, não deixe de molho e evite locais úmidos, chuva ou vapor excessivo." },
      { icon: "☀️", title: "Proteja do sol e do calor", text: "Evite sol direto, calor intenso, micro-ondas, lava-louças ou contato com fontes de calor." },
      { icon: "🤲", title: "Manuseie com cuidado", text: "Evite quedas, impactos, atritos e pressão sobre detalhes pequenos ou partes em relevo." },
      { icon: "🧴", title: "Não use produtos fortes", text: "Evite álcool, alvejantes, amoníaco, produtos abrasivos, palha de aço ou escovas duras." },
      { icon: "🏡", title: "Guarde em local seguro", text: "Mantenha a peça em local seco, arejado e protegido para preservar pintura, verniz e acabamento." }
    ],
    note: "Por ser uma peça artesanal, pequenas variações fazem parte do processo manual. O cuidado correto ajuda a preservar a beleza, os detalhes e a durabilidade da sua peça."
  },
  seoSection: {
    title: "Artesanato em cerâmica fria feito à mão",
    paragraphs: [
      "A Ana Viotto Artesanato cria peças artesanais em cerâmica fria para decoração, presentes personalizados e encomendas especiais.",
      "Cada peça é produzida com cuidado nos detalhes, podendo receber cores, temas e acabamentos personalizados de acordo com a ideia do cliente."
    ]
  },
  faq: [
    { question: "As peças são prontas ou sob encomenda?", answer: "Algumas peças podem estar disponíveis para pronta entrega, mas a maioria pode ser feita sob encomenda." },
    { question: "Dá para personalizar?", answer: "Sim. As peças podem ser personalizadas de acordo com a ideia do cliente, incluindo tema, cores, nome, detalhes e estilo." },
    { question: "Qual é o prazo de produção?", answer: "O prazo depende do tamanho, dos detalhes e da complexidade da peça. Antes de iniciar, a Ana informa o prazo estimado." },
    { question: "Como faço para pedir?", answer: "Para fazer uma encomenda, chame pelo WhatsApp ou visite o Instagram @_anaviottoartes." }
  ]
};
EOF

echo "Criando assets SVG..."
cat > public/assets/logo.svg <<'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="900" height="620" viewBox="0 0 900 620">
  <rect width="900" height="620" rx="48" fill="#fff7ec"/>
  <circle cx="450" cy="260" r="150" fill="#f7e3c4"/>
  <path d="M330 270c30-90 210-90 240 0 25 78-30 160-120 160s-145-82-120-160z" fill="#556237"/>
  <circle cx="400" cy="260" r="16" fill="#fff7ec"/>
  <circle cx="500" cy="260" r="16" fill="#fff7ec"/>
  <path d="M425 320c25 25 55 25 80 0" fill="none" stroke="#fff7ec" stroke-width="14" stroke-linecap="round"/>
  <text x="450" y="505" font-family="Georgia, serif" font-size="58" font-weight="700" text-anchor="middle" fill="#2f3a22">Ana Viotto</text>
  <text x="450" y="560" font-family="Arial, sans-serif" font-size="34" text-anchor="middle" fill="#9b5638">Artesanato</text>
</svg>
EOF

cat > public/assets/porta-trecos.svg <<'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="900" height="720" viewBox="0 0 900 720">
  <rect width="900" height="720" fill="#fff7ec"/>
  <ellipse cx="450" cy="435" rx="270" ry="95" fill="#d9a64d"/>
  <path d="M200 355c30 155 470 155 500 0" fill="#f3c867"/>
  <ellipse cx="450" cy="350" rx="260" ry="92" fill="#ffe29c"/>
  <ellipse cx="450" cy="348" rx="190" ry="55" fill="#fff7ec"/>
  <circle cx="525" cy="265" r="38" fill="#c96f35"/>
  <path d="M525 230c18-50 54-72 92-78" stroke="#556237" stroke-width="18" stroke-linecap="round" fill="none"/>
  <text x="450" y="625" font-family="Georgia, serif" font-size="46" text-anchor="middle" fill="#2f3a22">Porta-trecos artesanal</text>
</svg>
EOF

cat > public/assets/incensario.svg <<'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="900" height="720" viewBox="0 0 900 720">
  <rect width="900" height="720" fill="#fff7ec"/>
  <ellipse cx="450" cy="480" rx="300" ry="95" fill="#8b5e3c"/>
  <ellipse cx="450" cy="455" rx="250" ry="65" fill="#b77a4b"/>
  <path d="M420 330h80l35 135H385z" fill="#f7e3c4"/>
  <path d="M325 315c30-95 220-95 250 0 12 40-20 78-75 78H400c-55 0-87-38-75-78z" fill="#c96f35"/>
  <circle cx="385" cy="315" r="16" fill="#fff7ec"/>
  <circle cx="465" cy="292" r="18" fill="#fff7ec"/>
  <circle cx="525" cy="330" r="14" fill="#fff7ec"/>
  <path d="M610 180c-35 40 35 55 0 95s35 55 0 95" stroke="#756658" stroke-width="12" fill="none" stroke-linecap="round"/>
  <text x="450" y="625" font-family="Georgia, serif" font-size="43" text-anchor="middle" fill="#2f3a22">Incensário cogumelo</text>
</svg>
EOF

echo "Criando CSS público..."
cat > public/styles.css <<'EOF'
:root {
  --fundo: #fff7ec;
  --card: #fffdf8;
  --verde: #556237;
  --verde-escuro: #2f3a22;
  --laranja: #c96f35;
  --terracota: #9b5638;
  --texto: #2d241c;
  --suave: #756658;
  --linha: rgba(85, 98, 55, .18);
  --sombra: 0 24px 70px rgba(72, 50, 30, .15);
}

* { box-sizing: border-box; }

html { scroll-behavior: smooth; }

body {
  margin: 0;
  font-family: Arial, Helvetica, sans-serif;
  color: var(--texto);
  background:
    radial-gradient(circle at 10% 0%, rgba(201, 111, 53, .18), transparent 30%),
    radial-gradient(circle at 92% 10%, rgba(85, 98, 55, .16), transparent 28%),
    linear-gradient(180deg, #fff2df 0%, #fffaf4 46%, #fff7ec 100%);
  line-height: 1.55;
}

a { color: inherit; text-decoration: none; }

.topbar {
  position: sticky;
  top: 0;
  z-index: 10;
  background: rgba(255, 247, 236, .9);
  backdrop-filter: blur(16px);
  border-bottom: 1px solid var(--linha);
}

.nav {
  max-width: 1180px;
  margin: 0 auto;
  padding: 14px 22px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
}

.brand {
  display: flex;
  align-items: center;
  gap: 12px;
  font-weight: 900;
  color: var(--verde-escuro);
}

.brand img {
  width: 58px;
  height: 42px;
  object-fit: cover;
  border-radius: 999px;
  border: 2px solid rgba(85, 98, 55, .22);
  background: #fff;
}

.menu {
  display: flex;
  align-items: center;
  gap: 18px;
  color: var(--suave);
  font-size: 14px;
  font-weight: 700;
}

.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  border: 0;
  border-radius: 999px;
  padding: 13px 20px;
  font-weight: 900;
  cursor: pointer;
  transition: transform .18s ease, box-shadow .18s ease;
  white-space: nowrap;
}

.btn:hover { transform: translateY(-2px); }

.btn-primary {
  background: var(--verde-escuro);
  color: #fff;
  box-shadow: 0 14px 28px rgba(47, 58, 34, .22);
}

.btn-secondary {
  background: #fff8ed;
  color: var(--verde-escuro);
  border: 1px solid var(--linha);
}

.hero {
  max-width: 1180px;
  margin: 0 auto;
  padding: 64px 22px 46px;
  display: grid;
  grid-template-columns: 1fr .92fr;
  gap: 44px;
  align-items: center;
}

.tag {
  display: inline-flex;
  padding: 8px 14px;
  border-radius: 999px;
  background: rgba(255,255,255,.68);
  border: 1px solid var(--linha);
  color: var(--verde-escuro);
  font-weight: 900;
  font-size: 13px;
  margin-bottom: 20px;
}

h1 {
  margin: 0;
  font-family: Georgia, "Times New Roman", serif;
  font-size: clamp(42px, 6vw, 76px);
  line-height: .98;
  letter-spacing: -2px;
}

.hero-text p {
  margin: 24px 0 0;
  color: var(--suave);
  font-size: 19px;
  max-width: 590px;
}

.hero-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  margin-top: 32px;
}

.microcopy {
  margin-top: 18px;
  color: var(--suave);
  font-size: 14px;
}

.logo-card {
  background: linear-gradient(160deg, rgba(255,255,255,.95), rgba(247,227,196,.78));
  border: 1px solid rgba(85,98,55,.18);
  border-radius: 38px;
  box-shadow: var(--sombra);
  padding: 24px;
}

.logo-frame {
  background: #fff7ec;
  border: 1px solid rgba(85,98,55,.18);
  border-radius: 32px;
  padding: 18px;
}

.logo-frame img {
  width: 100%;
  display: block;
  border-radius: 26px;
}

section {
  max-width: 1180px;
  margin: 0 auto;
  padding: 58px 22px;
}

.section-title {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 28px;
  margin-bottom: 26px;
}

.section-title h2 {
  margin: 0;
  font-family: Georgia, "Times New Roman", serif;
  font-size: clamp(32px, 4vw, 52px);
  line-height: 1.04;
}

.section-title p {
  margin: 0;
  color: var(--suave);
  max-width: 520px;
}

.about-grid {
  display: grid;
  grid-template-columns: 1.05fr .95fr;
  gap: 18px;
}

.card, .about-card, .feature, .product-card, .step, .care-card, details, .seo-content {
  background: rgba(255,253,248,.88);
  border: 1px solid var(--linha);
  box-shadow: 0 16px 42px rgba(72,50,30,.06);
}

.about-card {
  border-radius: 28px;
  padding: 34px;
}

.about-card h3 {
  margin: 0 0 12px;
  color: var(--verde-escuro);
  font-size: 25px;
  font-family: Georgia, "Times New Roman", serif;
}

.about-card p { margin: 0; color: var(--suave); }

.features {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 14px;
}

.feature, .step, .care-card {
  border-radius: 24px;
  padding: 22px;
}

.feature span, .care-card span { font-size: 26px; }

.feature strong, .care-card strong {
  display: block;
  margin: 8px 0 4px;
  color: var(--verde-escuro);
}

.feature small, .care-card p {
  color: var(--suave);
  font-size: 14px;
}

.products {
  display: grid;
  grid-template-columns: repeat(2, minmax(280px, 1fr));
  gap: 18px;
  max-width: 900px;
  margin: 0 auto;
}

.product-card {
  border-radius: 30px;
  overflow: hidden;
}

.product-card img {
  width: 100%;
  height: 330px;
  object-fit: cover;
  display: block;
  background: #f7e3c4;
  border-bottom: 1px solid var(--linha);
}

.product-body { padding: 22px; }

.product-badge {
  display: inline-flex;
  padding: 6px 10px;
  border-radius: 999px;
  background: rgba(85,98,55,.1);
  color: var(--verde-escuro);
  font-size: 12px;
  font-weight: 900;
  margin-bottom: 10px;
}

.product-body h3 {
  margin: 0 0 8px;
  color: var(--verde-escuro);
  font-size: 21px;
}

.product-body p {
  margin: 0 0 18px;
  color: var(--suave);
  font-size: 15px;
}

.product-actions {
  display: grid;
  gap: 10px;
}

.steps {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 14px;
}

.care-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 14px;
}

.num {
  width: 40px;
  height: 40px;
  display: grid;
  place-items: center;
  border-radius: 50%;
  background: var(--verde-escuro);
  color: #fff;
  font-weight: 900;
  margin-bottom: 16px;
}

.step strong { display: block; color: var(--verde-escuro); margin-bottom: 8px; }
.step p { margin: 0; color: var(--suave); font-size: 14px; }

.care-note {
  margin-top: 18px;
  background: rgba(85,98,55,.08);
  border: 1px solid rgba(85,98,55,.16);
  border-radius: 22px;
  padding: 18px 20px;
  color: var(--suave);
}

.care-note strong { color: var(--verde-escuro); }

.seo-content {
  max-width: 920px;
  margin: 0 auto;
  border-radius: 26px;
  padding: 30px;
  color: var(--suave);
}

.seo-content h2 {
  margin: 0 0 12px;
  font-family: Georgia, "Times New Roman", serif;
  color: var(--verde-escuro);
  font-size: clamp(28px, 3vw, 40px);
}

.faq {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 14px;
}

details {
  border-radius: 22px;
  padding: 18px 20px;
}

summary {
  cursor: pointer;
  font-weight: 900;
  color: var(--verde-escuro);
}

details p { color: var(--suave); margin: 12px 0 0; }

.cta {
  max-width: 1136px;
  margin: 44px auto 76px;
  padding: 0 22px;
}

.cta-inner {
  border-radius: 38px;
  padding: 46px;
  background: linear-gradient(135deg, var(--verde-escuro), #59673a);
  color: #fff;
  box-shadow: var(--sombra);
  display: grid;
  grid-template-columns: 1.1fr .9fr;
  gap: 28px;
  align-items: center;
}

.cta h2 {
  margin: 0;
  font-family: Georgia, "Times New Roman", serif;
  font-size: clamp(32px, 4vw, 52px);
}

.cta p { color: rgba(255,255,255,.84); }
.cta .btn { background: #fff8ed; color: var(--verde-escuro); width: 100%; }

footer {
  border-top: 1px solid var(--linha);
  padding: 28px 22px 36px;
  color: var(--suave);
  text-align: center;
  font-size: 14px;
}

@media (max-width: 940px) {
  .menu a:not(.btn) { display: none; }
  .hero, .about-grid, .cta-inner { grid-template-columns: 1fr; }
  .features, .products, .steps, .care-grid, .faq { grid-template-columns: 1fr; }
  .section-title { flex-direction: column; align-items: start; }
}

@media (max-width: 560px) {
  .brand span { display: none; }
  .hero, section { padding-left: 16px; padding-right: 16px; }
  .hero-actions .btn { width: 100%; }
  .logo-card { padding: 14px; border-radius: 28px; }
  .about-card, .cta-inner { padding: 28px 22px; }
}
EOF

echo "Criando index.html..."
cat > public/index.html <<'EOF'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />

  <title>Ana Viotto Artesanato | Cerâmica fria artesanal e presentes personalizados</title>
  <meta name="description" content="Peças artesanais em cerâmica fria feitas à mão: porta-trecos, incensários, cinzeiros decorativos e presentes personalizados sob encomenda." />
  <link rel="canonical" href="https://anaviottoartes.com.br/" />
  <meta name="robots" content="index, follow" />

  <meta property="og:type" content="website" />
  <meta property="og:title" content="Ana Viotto Artesanato | Cerâmica fria artesanal" />
  <meta property="og:description" content="Peças artesanais em cerâmica fria feitas à mão para decorar, presentear e encantar." />
  <meta property="og:url" content="https://anaviottoartes.com.br/" />
  <meta property="og:site_name" content="Ana Viotto Artesanato" />
  <meta property="og:locale" content="pt_BR" />

  <script async src="https://www.googletagmanager.com/gtag/js?id=G-PEHV8TH4PG"></script>
  <script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag("js", new Date());
    gtag("config", "G-PEHV8TH4PG");
  </script>

  <link rel="stylesheet" href="/styles.css" />
</head>
<body>
  <div id="app"></div>

  <script src="/default-content.js"></script>
  <script src="/app.js"></script>
</body>
</html>
EOF

echo "Criando app.js..."
cat > public/app.js <<'EOF'
let CONTENT = window.DEFAULT_CONTENT;

const escapeHtml = (text = "") => String(text)
  .replaceAll("&", "&amp;")
  .replaceAll("<", "&lt;")
  .replaceAll(">", "&gt;")
  .replaceAll('"', "&quot;")
  .replaceAll("'", "&#039;");

function whatsappUrl(content) {
  return `https://wa.me/${content.site.whatsappNumber}?text=${encodeURIComponent(content.site.whatsappMessage)}`;
}

function updateHead(content) {
  document.title = content.seo?.title || content.site?.brandName || "Ana Viotto Artesanato";

  const description = document.querySelector('meta[name="description"]');
  if (description && content.seo?.description) {
    description.setAttribute("content", content.seo.description);
  }

  let schema = document.getElementById("schema-org-store");
  if (!schema) {
    schema = document.createElement("script");
    schema.type = "application/ld+json";
    schema.id = "schema-org-store";
    document.head.appendChild(schema);
  }

  schema.textContent = JSON.stringify({
    "@context": "https://schema.org",
    "@type": "Store",
    "name": content.site.brandName,
    "url": content.site.domain,
    "description": content.seo.description,
    "sameAs": [content.site.instagram],
    "telephone": "+55 11 94971-1535",
    "areaServed": "Brasil"
  });
}

function bindAnalytics() {
  document.querySelectorAll('a[href*="instagram.com"]').forEach(link => {
    link.addEventListener("click", () => {
      if (typeof gtag === "function") {
        gtag("event", "click_instagram", { event_category: "outbound", event_label: link.href });
      }
    });
  });

  document.querySelectorAll('a[href*="wa.me"]').forEach(link => {
    link.addEventListener("click", () => {
      if (typeof gtag === "function") {
        gtag("event", "click_whatsapp", { event_category: "outbound", event_label: link.href });
      }
    });
  });
}

function render(content) {
  CONTENT = content;
  updateHead(content);

  const wpp = whatsappUrl(content);
  const instagram = content.site.instagram;

  document.getElementById("app").innerHTML = `
    <header class="topbar">
      <nav class="nav">
        <a class="brand" href="#">
          <img src="${escapeHtml(content.site.logo)}" alt="Logo ${escapeHtml(content.site.brandName)}" />
          <span>${escapeHtml(content.site.brandName)}</span>
        </a>

        <div class="menu">
          <a href="#pecas">Peças</a>
          <a href="#como-funciona">Como encomendar</a>
          <a href="#cuidados-peca">Cuidados</a>
          <a href="#duvidas">Dúvidas</a>
          <a href="${escapeHtml(instagram)}" target="_blank" rel="noopener">Instagram</a>
          <a class="btn btn-primary" href="${escapeHtml(wpp)}" target="_blank" rel="noopener">Pedir pelo WhatsApp</a>
        </div>
      </nav>
    </header>

    <main>
      <section class="hero">
        <div class="hero-text">
          <div class="tag">${escapeHtml(content.hero.tag)}</div>
          <h1>${escapeHtml(content.hero.title)}</h1>
          <p>${escapeHtml(content.hero.subtitle)}</p>

          <div class="hero-actions">
            <a class="btn btn-primary" href="${escapeHtml(wpp)}" target="_blank" rel="noopener">Quero fazer uma encomenda</a>
            <a class="btn btn-secondary" href="${escapeHtml(instagram)}" target="_blank" rel="noopener">Ver Instagram</a>
            <a class="btn btn-secondary" href="#pecas">Ver peças</a>
          </div>

          <div class="microcopy">${escapeHtml(content.hero.note)}</div>
        </div>

        <aside class="logo-card">
          <div class="logo-frame">
            <img src="${escapeHtml(content.site.logo)}" alt="${escapeHtml(content.site.brandName)}" />
          </div>
        </aside>
      </section>

      <section id="sobre">
        <div class="section-title">
          <h2>${escapeHtml(content.about.title)}</h2>
          <p>${escapeHtml(content.about.subtitle)}</p>
        </div>

        <div class="about-grid">
          <div class="about-card">
            <h3>${escapeHtml(content.about.cardTitle)}</h3>
            <p>${escapeHtml(content.about.cardText)}</p>
          </div>

          <div class="features">
            ${(content.features || []).map(item => `
              <div class="feature">
                <span>${escapeHtml(item.icon)}</span>
                <strong>${escapeHtml(item.title)}</strong>
                <small>${escapeHtml(item.text)}</small>
              </div>
            `).join("")}
          </div>
        </div>
      </section>

      <section id="pecas">
        <div class="section-title">
          <h2>${escapeHtml(content.productsIntro.title)}</h2>
          <p>${escapeHtml(content.productsIntro.text)}</p>
        </div>

        <div class="products">
          ${(content.products || []).map(product => `
            <article class="product-card">
              <img src="${escapeHtml(product.image)}" alt="${escapeHtml(product.alt || product.title)}" loading="lazy" />
              <div class="product-body">
                <span class="product-badge">Cerâmica fria artesanal</span>
                <h3>${escapeHtml(product.title)}</h3>
                <p>${escapeHtml(product.description)}</p>
                <div class="product-actions">
                  <a class="btn btn-secondary" href="${escapeHtml(wpp)}" target="_blank" rel="noopener">Encomendar pelo WhatsApp</a>
                  <a class="btn btn-secondary" href="${escapeHtml(instagram)}" target="_blank" rel="noopener">Ver no Instagram</a>
                </div>
              </div>
            </article>
          `).join("")}
        </div>
      </section>

      <section id="como-funciona">
        <div class="section-title">
          <h2>${escapeHtml(content.how.title)}</h2>
          <p>${escapeHtml(content.how.subtitle)}</p>
        </div>

        <div class="steps">
          ${(content.how.steps || []).map((step, index) => `
            <div class="step">
              <div class="num">${index + 1}</div>
              <strong>${escapeHtml(step.title)}</strong>
              <p>${escapeHtml(step.text)}</p>
            </div>
          `).join("")}
        </div>
      </section>

      <section id="cuidados-peca">
        <div class="section-title">
          <h2>${escapeHtml(content.care.title)}</h2>
          <p>${escapeHtml(content.care.subtitle)}</p>
        </div>

        <div class="care-grid">
          ${(content.care.items || []).map(item => `
            <div class="care-card">
              <span>${escapeHtml(item.icon)}</span>
              <strong>${escapeHtml(item.title)}</strong>
              <p>${escapeHtml(item.text)}</p>
            </div>
          `).join("")}
        </div>

        <div class="care-note">
          <strong>Importante:</strong> ${escapeHtml(content.care.note)}
        </div>
      </section>

      <section id="artesanato-ceramica-fria">
        <div class="seo-content">
          <h2>${escapeHtml(content.seoSection.title)}</h2>
          ${(content.seoSection.paragraphs || []).map(p => `<p>${escapeHtml(p)}</p>`).join("")}
        </div>
      </section>

      <section id="duvidas">
        <div class="section-title">
          <h2>Dúvidas frequentes</h2>
          <p>Essas respostas reduzem dúvidas repetidas e ajudam você a entender melhor como funciona a encomenda.</p>
        </div>

        <div class="faq">
          ${(content.faq || []).map((item, index) => `
            <details ${index === 0 ? "open" : ""}>
              <summary>${escapeHtml(item.question)}</summary>
              <p>${escapeHtml(item.answer)}</p>
            </details>
          `).join("")}
        </div>
      </section>

      <div class="cta">
        <div class="cta-inner">
          <div>
            <h2>Vamos criar uma peça especial?</h2>
            <p>Chame pelo WhatsApp ou Instagram, envie sua ideia e combine uma encomenda artesanal feita com carinho.</p>
          </div>
          <div class="product-actions">
            <a class="btn" href="${escapeHtml(wpp)}" target="_blank" rel="noopener">Chamar no WhatsApp</a>
            <a class="btn" href="${escapeHtml(instagram)}" target="_blank" rel="noopener">Ver Instagram</a>
          </div>
        </div>
      </div>
    </main>

    <footer>
      ${escapeHtml(content.site.brandName)} • Cerâmica fria artesanal • WhatsApp: ${escapeHtml(content.site.whatsappDisplay)} • Instagram: ${escapeHtml(content.site.instagramHandle)}
    </footer>
  `;

  bindAnalytics();
}

async function loadContent() {
  try {
    const response = await fetch("/api/content", { cache: "no-store" });
    if (!response.ok) throw new Error("Erro ao carregar conteúdo");
    const payload = await response.json();
    render(payload.content || window.DEFAULT_CONTENT);
  } catch (error) {
    render(window.DEFAULT_CONTENT);
  }
}

loadContent();
EOF

echo "Criando painel admin..."
cat > public/admin/index.html <<'EOF'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Painel | Ana Viotto Artesanato</title>
  <link rel="stylesheet" href="/admin/admin.css" />
</head>
<body>
  <header>
    <div class="top">
      <div>
        <h1>Painel Ana Viotto Artesanato</h1>
        <small>Edite textos, contatos, produtos e imagens do site.</small>
      </div>
      <div class="actions">
        <a class="btn secondary" href="/" target="_blank">Ver site</a>
        <button class="btn" id="saveTop">Publicar alterações</button>
      </div>
    </div>
  </header>

  <main>
    <div class="status" id="status">Carregando conteúdo...</div>
    <form id="form" class="grid"></form>
  </main>

  <script src="/default-content.js"></script>
  <script src="/admin/admin.js"></script>
</body>
</html>
EOF

cat > public/admin/admin.css <<'EOF'
:root {
  --bg: #fff7ec;
  --card: #fffdf8;
  --green: #2f3a22;
  --soft: #756658;
  --line: rgba(85,98,55,.18);
  --shadow: 0 18px 48px rgba(72,50,30,.10);
}

* { box-sizing: border-box; }

body {
  margin: 0;
  font-family: Arial, Helvetica, sans-serif;
  background: var(--bg);
  color: #2d241c;
}

header {
  position: sticky;
  top: 0;
  z-index: 10;
  background: rgba(255,247,236,.94);
  backdrop-filter: blur(14px);
  border-bottom: 1px solid var(--line);
}

.top {
  max-width: 1180px;
  margin: 0 auto;
  padding: 16px 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
}

h1 {
  margin: 0;
  color: var(--green);
  font-size: 22px;
}

main {
  max-width: 1180px;
  margin: 0 auto;
  padding: 28px 20px 60px;
}

.grid {
  display: grid;
  gap: 18px;
}

.card {
  background: var(--card);
  border: 1px solid var(--line);
  border-radius: 22px;
  box-shadow: var(--shadow);
  padding: 22px;
}

.card h2 {
  margin: 0 0 16px;
  color: var(--green);
  font-size: 20px;
}

label {
  display: block;
  font-weight: 800;
  color: var(--green);
  margin: 14px 0 6px;
  font-size: 14px;
}

input, textarea {
  width: 100%;
  border: 1px solid var(--line);
  border-radius: 14px;
  padding: 12px 14px;
  font: inherit;
  background: #fff;
  color: #2d241c;
}

textarea {
  min-height: 96px;
  resize: vertical;
}

.row {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 14px;
}

.btn {
  border: 0;
  border-radius: 999px;
  padding: 12px 18px;
  font-weight: 900;
  cursor: pointer;
  background: var(--green);
  color: #fff;
  text-decoration: none;
  display: inline-flex;
}

.btn.secondary {
  background: #fff8ed;
  color: var(--green);
  border: 1px solid var(--line);
}

.btn.danger {
  background: #8b2f2f;
}

.actions {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  align-items: center;
}

.status {
  color: var(--soft);
  font-size: 14px;
  margin-bottom: 14px;
}

.item {
  border: 1px solid var(--line);
  border-radius: 18px;
  padding: 16px;
  margin: 12px 0;
  background: rgba(255,247,236,.45);
}

.preview {
  max-width: 220px;
  max-height: 160px;
  object-fit: cover;
  border-radius: 14px;
  display: block;
  margin: 10px 0;
  border: 1px solid var(--line);
}

small { color: var(--soft); }

@media (max-width: 760px) {
  .row { grid-template-columns: 1fr; }
  .top { align-items: start; flex-direction: column; }
}
EOF

cat > public/admin/admin.js <<'EOF'
let content = structuredClone(window.DEFAULT_CONTENT);

const statusEl = document.getElementById("status");
const form = document.getElementById("form");

const escapeHtml = (text = "") => String(text)
  .replaceAll("&", "&amp;")
  .replaceAll("<", "&lt;")
  .replaceAll(">", "&gt;")
  .replaceAll('"', "&quot;");

function setStatus(message) {
  statusEl.textContent = message;
}

function get(path) {
  return path.split(".").reduce((obj, key) => obj && obj[key], content);
}

function set(path, value) {
  const parts = path.split(".");
  let obj = content;
  for (let i = 0; i < parts.length - 1; i++) obj = obj[parts[i]];
  obj[parts[parts.length - 1]] = value;
}

function field(path, label, type = "text") {
  const value = get(path) || "";
  if (type === "textarea") {
    return `<label>${label}</label><textarea data-path="${path}">${escapeHtml(value)}</textarea>`;
  }
  return `<label>${label}</label><input data-path="${path}" value="${escapeHtml(value)}" />`;
}

function bindInputs() {
  document.querySelectorAll("[data-path]").forEach((input) => {
    input.addEventListener("input", () => set(input.dataset.path, input.value));
  });
}

function render() {
  form.innerHTML = `
    <section class="card">
      <h2>Configurações</h2>
      <div class="row">
        <div>${field("site.brandName", "Nome da marca")}</div>
        <div>${field("site.logo", "Logo / imagem principal")}</div>
      </div>
      <div class="row">
        <div>${field("site.whatsappDisplay", "WhatsApp visível")}</div>
        <div>${field("site.whatsappNumber", "WhatsApp com DDI e DDD, só números")}</div>
      </div>
      ${field("site.whatsappMessage", "Mensagem automática do WhatsApp")}
      <div class="row">
        <div>${field("site.instagram", "Link do Instagram")}</div>
        <div>${field("site.instagramHandle", "Usuário do Instagram")}</div>
      </div>
    </section>

    <section class="card">
      <h2>SEO</h2>
      ${field("seo.title", "Título para o Google")}
      ${field("seo.description", "Descrição para o Google", "textarea")}
      ${field("seo.keywords", "Palavras-chave")}
    </section>

    <section class="card">
      <h2>Primeira dobra</h2>
      ${field("hero.tag", "Etiqueta")}
      ${field("hero.title", "Título principal", "textarea")}
      ${field("hero.subtitle", "Subtítulo", "textarea")}
      ${field("hero.note", "Texto pequeno abaixo dos botões", "textarea")}
    </section>

    <section class="card">
      <h2>Sobre</h2>
      ${field("about.title", "Título da seção")}
      ${field("about.subtitle", "Subtítulo da seção", "textarea")}
      ${field("about.cardTitle", "Título do card")}
      ${field("about.cardText", "Texto do card", "textarea")}
    </section>

    <section class="card">
      <h2>Produtos</h2>
      <div id="products"></div>
      <button type="button" class="btn secondary" onclick="addProduct()">Adicionar produto</button>
    </section>

    <section class="card">
      <h2>Como encomendar</h2>
      ${field("how.title", "Título")}
      ${field("how.subtitle", "Subtítulo", "textarea")}
      <div id="steps"></div>
    </section>

    <section class="card">
      <h2>Cuidados com a peça</h2>
      ${field("care.title", "Título")}
      ${field("care.subtitle", "Subtítulo", "textarea")}
      <div id="careItems"></div>
      ${field("care.note", "Observação final", "textarea")}
    </section>

    <section class="card">
      <h2>Dúvidas frequentes</h2>
      <div id="faq"></div>
      <button type="button" class="btn secondary" onclick="addFaq()">Adicionar pergunta</button>
    </section>

    <section class="card">
      <div class="actions">
        <button type="button" class="btn" onclick="saveContent()">Publicar alterações</button>
        <a class="btn secondary" href="/" target="_blank">Ver site</a>
      </div>
    </section>
  `;

  renderProducts();
  renderSteps();
  renderCareItems();
  renderFaq();
  bindInputs();
}

function renderProducts() {
  document.getElementById("products").innerHTML = content.products.map((p, index) => `
    <div class="item">
      <strong>Produto ${index + 1}</strong>

      <label>Título</label>
      <input value="${escapeHtml(p.title)}" oninput="content.products[${index}].title=this.value" />

      <label>Descrição</label>
      <textarea oninput="content.products[${index}].description=this.value">${escapeHtml(p.description)}</textarea>

      <label>Imagem</label>
      <input value="${escapeHtml(p.image)}" oninput="content.products[${index}].image=this.value" />
      <img class="preview" src="${escapeHtml(p.image)}" alt="" />

      <label>Enviar nova imagem</label>
      <input type="file" accept="image/*" onchange="uploadImage(event, ${index})" />

      <label>Texto alternativo da imagem</label>
      <input value="${escapeHtml(p.alt || "")}" oninput="content.products[${index}].alt=this.value" />

      <div class="actions" style="margin-top:12px">
        <button type="button" class="btn danger" onclick="removeProduct(${index})">Remover</button>
      </div>
    </div>
  `).join("");
}

function renderSteps() {
  document.getElementById("steps").innerHTML = content.how.steps.map((s, index) => `
    <div class="item">
      <strong>Passo ${index + 1}</strong>
      <label>Título</label>
      <input value="${escapeHtml(s.title)}" oninput="content.how.steps[${index}].title=this.value" />
      <label>Texto</label>
      <textarea oninput="content.how.steps[${index}].text=this.value">${escapeHtml(s.text)}</textarea>
    </div>
  `).join("");
}

function renderCareItems() {
  document.getElementById("careItems").innerHTML = content.care.items.map((s, index) => `
    <div class="item">
      <strong>Cuidado ${index + 1}</strong>
      <label>Ícone</label>
      <input value="${escapeHtml(s.icon)}" oninput="content.care.items[${index}].icon=this.value" />
      <label>Título</label>
      <input value="${escapeHtml(s.title)}" oninput="content.care.items[${index}].title=this.value" />
      <label>Texto</label>
      <textarea oninput="content.care.items[${index}].text=this.value">${escapeHtml(s.text)}</textarea>
    </div>
  `).join("");
}

function renderFaq() {
  document.getElementById("faq").innerHTML = content.faq.map((s, index) => `
    <div class="item">
      <strong>Pergunta ${index + 1}</strong>
      <label>Pergunta</label>
      <input value="${escapeHtml(s.question)}" oninput="content.faq[${index}].question=this.value" />
      <label>Resposta</label>
      <textarea oninput="content.faq[${index}].answer=this.value">${escapeHtml(s.answer)}</textarea>
      <div class="actions" style="margin-top:12px">
        <button type="button" class="btn danger" onclick="removeFaq(${index})">Remover</button>
      </div>
    </div>
  `).join("");
}

window.addProduct = function () {
  content.products.push({
    title: "Novo produto",
    description: "Descrição do produto.",
    image: "/assets/logo.svg",
    alt: "Produto artesanal em cerâmica fria"
  });
  renderProducts();
};

window.removeProduct = function (index) {
  content.products.splice(index, 1);
  renderProducts();
};

window.addFaq = function () {
  content.faq.push({ question: "Nova pergunta", answer: "Resposta." });
  renderFaq();
};

window.removeFaq = function (index) {
  content.faq.splice(index, 1);
  renderFaq();
};

window.uploadImage = async function (event, productIndex) {
  const file = event.target.files[0];
  if (!file) return;

  const formData = new FormData();
  formData.append("file", file);

  setStatus("Enviando imagem...");

  const response = await fetch("/api/admin/upload-image", {
    method: "POST",
    body: formData
  });

  const payload = await response.json();

  if (!response.ok || !payload.ok) {
    setStatus(payload.error || "Erro ao enviar imagem.");
    return;
  }

  content.products[productIndex].image = payload.url;
  setStatus("Imagem enviada. Clique em Publicar alterações para salvar no site.");
  renderProducts();
};

window.saveContent = async function () {
  bindInputs();
  setStatus("Salvando alterações...");

  const response = await fetch("/api/admin/content", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ content })
  });

  const payload = await response.json();

  if (!response.ok || !payload.ok) {
    setStatus(payload.error || "Erro ao salvar.");
    return;
  }

  setStatus("Alterações publicadas com sucesso.");
};

async function loadContent() {
  try {
    const response = await fetch("/api/admin/content", { cache: "no-store" });
    const payload = await response.json();

    if (!response.ok) {
      setStatus(payload.error || "Não foi possível carregar o conteúdo.");
      render();
      return;
    }

    content = payload.content || content;
    setStatus("Conteúdo carregado.");
    render();
  } catch (error) {
    setStatus("Erro ao carregar. Verifique D1, Access e bindings.");
    render();
  }
}

document.getElementById("saveTop").addEventListener("click", saveContent);
loadContent();
EOF

echo "Criando Functions..."
cat > functions/_lib/content.js <<'EOF'
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
EOF

cat > functions/_lib/auth.js <<'EOF'
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
EOF

cat > functions/api/content.js <<'EOF'
import { loadContent, jsonResponse } from "../_lib/content.js";

export async function onRequestGet({ env }) {
  try {
    return jsonResponse(await loadContent(env));
  } catch (error) {
    return jsonResponse({ error: String(error.message || error) }, 500);
  }
}
EOF

cat > functions/api/admin/content.js <<'EOF'
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
EOF

cat > functions/api/admin/upload-image.js <<'EOF'
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
EOF

cat > "functions/media/[[path]].js" <<'EOF'
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
EOF

echo "Criando migration D1..."
cat > migrations/0001_site_content.sql <<'EOF'
CREATE TABLE IF NOT EXISTS site_content (
  id TEXT PRIMARY KEY,
  content TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
EOF

echo "Criando robots, sitemap e headers..."
cat > public/robots.txt <<'EOF'
User-agent: *
Allow: /

Sitemap: https://anaviottoartes.com.br/sitemap.xml
EOF

cat > public/sitemap.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://anaviottoartes.com.br/</loc>
    <changefreq>weekly</changefreq>
    <priority>1.0</priority>
  </url>
</urlset>
EOF

cat > public/_headers <<'EOF'
/*
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: camera=(), microphone=(), geolocation=()

/admin/*
  Cache-Control: no-store
EOF

echo "Criando wrangler.toml.example..."
cat > wrangler.toml.example <<'EOF'
name = "anaviottoartes"
compatibility_date = "2026-07-11"
pages_build_output_dir = "public"

[[d1_databases]]
binding = "DB"
database_name = "anaviotto-site"
database_id = "COLOQUE_O_DATABASE_ID_AQUI"

[[r2_buckets]]
binding = "MEDIA"
bucket_name = "anaviotto-media"
EOF

echo "Criando README..."
cat > README.md <<'EOF'
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
EOF

echo "Rodando check..."
npm run check

echo "Enviando para o GitHub..."
git add .
git commit -m "Recriar site Ana Viotto com painel Cloudflare" || echo "Nada novo para commitar"
git branch -M main
git push -u origin main

echo "Finalizado."

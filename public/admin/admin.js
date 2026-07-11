let content = JSON.parse(JSON.stringify(window.DEFAULT_CONTENT));

const form = document.getElementById("form");
const statusEl = document.getElementById("status");

const escapeHtml = (text = "") => String(text)
  .replaceAll("&", "&amp;")
  .replaceAll("<", "&lt;")
  .replaceAll(">", "&gt;")
  .replaceAll('"', "&quot;");

function setStatus(message) {
  statusEl.textContent = message;
}

function getPath(path) {
  return path.split(".").reduce((obj, key) => obj?.[key], content);
}

function setPath(path, value) {
  const keys = path.split(".");
  let obj = content;

  for (let i = 0; i < keys.length - 1; i++) {
    obj = obj[keys[i]];
  }

  obj[keys[keys.length - 1]] = value;
}

function field(path, label, type = "text", help = "") {
  const value = getPath(path) ?? "";
  const helpHtml = help ? `<small class="help">${escapeHtml(help)}</small>` : "";

  if (type === "textarea") {
    return `
      <label>${escapeHtml(label)}</label>
      <textarea data-path="${escapeHtml(path)}">${escapeHtml(value)}</textarea>
      ${helpHtml}
    `;
  }

  return `
    <label>${escapeHtml(label)}</label>
    <input type="${escapeHtml(type)}" data-path="${escapeHtml(path)}" value="${escapeHtml(value)}">
    ${helpHtml}
  `;
}

function bindInputs() {
  document.querySelectorAll("[data-path]").forEach(input => {
    input.addEventListener("input", () => {
      setPath(input.dataset.path, input.value);
    });
  });
}

function render() {
  form.innerHTML = `
    <section class="panel">
      <h2>Identidade da marca</h2>
      <p>Nome, contatos, domínio e logo principal.</p>

      <div class="row">
        <div>${field("site.brandName", "Nome da marca")}</div>
        <div>${field("site.domain", "Domínio principal")}</div>
      </div>

      ${field("site.logo", "Endereço atual do logo")}
      <img class="preview logo-preview" src="${escapeHtml(content.site.logo)}" alt="Prévia do logo">

      <label>Enviar novo logo</label>
      <input type="file" accept="image/jpeg,image/png,image/webp,image/gif" onchange="uploadToPath(event, 'site.logo')">
      <small class="help">O arquivo será salvo no R2. O novo logo será usado no cabeçalho, destaque principal e favicon.</small>

      <div class="row">
        <div>${field("site.whatsappDisplay", "WhatsApp visível")}</div>
        <div>${field("site.whatsappNumber", "WhatsApp com DDI e DDD, somente números")}</div>
      </div>

      ${field("site.whatsappMessage", "Mensagem automática do WhatsApp", "textarea")}

      <div class="row">
        <div>${field("site.instagram", "Link do Instagram")}</div>
        <div>${field("site.instagramHandle", "Usuário do Instagram")}</div>
      </div>

      ${field("site.gaId", "ID do Google Analytics")}
    </section>

    <section class="panel">
      <h2>Cores do site</h2>
      <p>A dona pode mudar a identidade visual sem alterar o código.</p>

      <div class="color-grid">
        <div>${field("theme.pink", "Rosa principal", "color")}</div>
        <div>${field("theme.pinkStrong", "Rosa de destaque", "color")}</div>
        <div>${field("theme.pinkLight", "Rosa claro", "color")}</div>
        <div>${field("theme.green", "Verde claro", "color")}</div>
        <div>${field("theme.greenStrong", "Verde de apoio", "color")}</div>
        <div>${field("theme.cream", "Fundo creme", "color")}</div>
        <div>${field("theme.brown", "Títulos", "color")}</div>
        <div>${field("theme.soft", "Textos secundários", "color")}</div>
      </div>
    </section>

    <section class="panel">
      <h2>Menu</h2>
      <p>Textos exibidos no menu superior.</p>

      <div class="row">
        <div>${field("navigation.products", "Peças")}</div>
        <div>${field("navigation.about", "Sobre")}</div>
        <div>${field("navigation.how", "Como encomendar")}</div>
        <div>${field("navigation.care", "Cuidados")}</div>
        <div>${field("navigation.faq", "Dúvidas")}</div>
        <div>${field("navigation.whatsapp", "Botão do WhatsApp")}</div>
      </div>
    </section>

    <section class="panel">
      <h2>SEO e Google</h2>
      <p>Informações usadas por buscadores e compartilhamentos.</p>

      ${field("seo.title", "Título para o Google")}
      ${field("seo.description", "Descrição para o Google", "textarea")}
      ${field("seo.keywords", "Palavras-chave")}
    </section>

    <section class="panel">
      <h2>Destaque principal</h2>
      <p>Primeiro conteúdo exibido ao abrir o site.</p>

      ${field("hero.tag", "Identificação superior")}
      <div class="row">
        <div>${field("hero.title", "Título antes do destaque")}</div>
        <div>${field("hero.accent", "Palavra destacada")}</div>
      </div>
      ${field("hero.titleAfter", "Complemento do título")}
      ${field("hero.subtitle", "Texto principal", "textarea")}
      ${field("hero.note", "Informação abaixo dos botões")}

      <div class="row">
        <div>${field("hero.whatsappButton", "Botão WhatsApp")}</div>
        <div>${field("hero.instagramButton", "Botão Instagram")}</div>
      </div>
      ${field("hero.productsButton", "Botão para as peças")}

      <div id="heroNotes"></div>
      <button type="button" class="btn secondary" onclick="addHeroNote()">Adicionar nota</button>
    </section>

    <section class="panel">
      <h2>Sobre a marca</h2>
      <p>Apresentação institucional e diferenciais.</p>

      <div class="row">
        <div>${field("about.title", "Título")}</div>
        <div>${field("about.accent", "Palavra destacada")}</div>
      </div>

      ${field("about.subtitle", "Subtítulo", "textarea")}
      ${field("about.badge", "Etiqueta do card")}
      ${field("about.cardTitle", "Título do card")}
      ${field("about.cardText", "Texto do card", "textarea")}

      <div id="features"></div>
      <button type="button" class="btn secondary" onclick="addFeature()">Adicionar diferencial</button>
    </section>

    <section class="panel">
      <h2>Vitrine de peças</h2>
      <p>Títulos da seção, produtos, descrições e imagens.</p>

      <div class="row">
        <div>${field("productsIntro.title", "Título")}</div>
        <div>${field("productsIntro.accent", "Palavra destacada")}</div>
      </div>

      ${field("productsIntro.text", "Descrição da seção", "textarea")}

      <div class="row">
        <div>${field("productLabels.defaultBadge", "Etiqueta padrão")}</div>
        <div>${field("productLabels.whatsappButton", "Botão WhatsApp")}</div>
      </div>
      ${field("productLabels.instagramButton", "Botão Instagram")}

      <div id="products"></div>
      <button type="button" class="btn secondary" onclick="addProduct()">Adicionar produto</button>
    </section>

    <section class="panel">
      <h2>Como funciona a encomenda</h2>
      <p>Edite os títulos e todas as etapas.</p>

      <div class="row">
        <div>${field("how.title", "Título")}</div>
        <div>${field("how.accent", "Palavra destacada")}</div>
      </div>
      ${field("how.subtitle", "Descrição", "textarea")}

      <div id="steps"></div>
      <button type="button" class="btn secondary" onclick="addStep()">Adicionar etapa</button>
    </section>

    <section class="panel">
      <h2>Cuidados com as peças</h2>
      <p>Orientações exibidas aos clientes.</p>

      <div class="row">
        <div>${field("care.title", "Título")}</div>
        <div>${field("care.accent", "Palavra destacada")}</div>
      </div>
      ${field("care.subtitle", "Descrição", "textarea")}

      <div id="careItems"></div>
      <button type="button" class="btn secondary" onclick="addCare()">Adicionar cuidado</button>
    </section>

    <section class="panel">
      <h2>Dúvidas frequentes</h2>
      <p>Edite o título da seção e todas as perguntas.</p>

      <div class="row">
        <div>${field("faqIntro.title", "Título")}</div>
        <div>${field("faqIntro.accent", "Palavra destacada")}</div>
      </div>
      ${field("faqIntro.subtitle", "Descrição", "textarea")}

      <div id="faq"></div>
      <button type="button" class="btn secondary" onclick="addFaq()">Adicionar pergunta</button>
    </section>

    <section class="panel">
      <h2>Chamada final e rodapé</h2>
      <p>Última chamada comercial e texto inferior.</p>

      <div class="row">
        <div>${field("cta.title", "Título")}</div>
        <div>${field("cta.accent", "Palavra destacada")}</div>
      </div>
      ${field("cta.text", "Descrição", "textarea")}

      <div class="row">
        <div>${field("cta.whatsappButton", "Botão WhatsApp")}</div>
        <div>${field("cta.instagramButton", "Botão Instagram")}</div>
      </div>

      ${field("footer.text", "Texto do rodapé")}
    </section>

    <section class="panel">
      <div class="actions">
        <button type="button" class="btn" onclick="saveContent()">Publicar alterações</button>
        <a class="btn secondary" href="/" target="_blank">Ver site</a>
      </div>
    </section>
  `;

  renderHeroNotes();
  renderFeatures();
  renderProducts();
  renderSteps();
  renderCareItems();
  renderFaq();
  bindInputs();
}

function itemFields(items, rootId, renderer) {
  document.getElementById(rootId).innerHTML = items.map(renderer).join("");
  bindInputs();
}

function renderHeroNotes() {
  itemFields(content.heroNotes || [], "heroNotes", (item, index) => `
    <div class="item">
      <div class="item-header">
        <strong>Nota ${index + 1}</strong>
        <button type="button" class="btn danger" onclick="removeHeroNote(${index})">Remover</button>
      </div>
      ${field(`heroNotes.${index}.title`, "Título")}
      ${field(`heroNotes.${index}.text`, "Texto", "textarea")}
    </div>
  `);
}

function renderFeatures() {
  itemFields(content.features || [], "features", (item, index) => `
    <div class="item">
      <div class="item-header">
        <strong>Diferencial ${index + 1}</strong>
        <button type="button" class="btn danger" onclick="removeFeature(${index})">Remover</button>
      </div>
      ${field(`features.${index}.icon`, "Ícone ou símbolo")}
      ${field(`features.${index}.title`, "Título")}
      ${field(`features.${index}.text`, "Texto", "textarea")}
    </div>
  `);
}

function renderProducts() {
  itemFields(content.products || [], "products", (item, index) => `
    <div class="item">
      <div class="item-header">
        <strong>Produto ${index + 1}</strong>
        <button type="button" class="btn danger" onclick="removeProduct(${index})">Remover</button>
      </div>

      ${field(`products.${index}.badge`, "Etiqueta")}
      ${field(`products.${index}.title`, "Título")}
      ${field(`products.${index}.description`, "Descrição", "textarea")}
      ${field(`products.${index}.image`, "Endereço da imagem")}

      <img class="preview" src="${escapeHtml(item.image)}" alt="Prévia do produto">

      <label>Enviar nova imagem</label>
      <input type="file" accept="image/jpeg,image/png,image/webp,image/gif"
        onchange="uploadToPath(event, 'products.${index}.image')">

      ${field(`products.${index}.alt`, "Descrição da imagem para acessibilidade")}
    </div>
  `);
}

function renderSteps() {
  itemFields(content.how.steps || [], "steps", (item, index) => `
    <div class="item">
      <div class="item-header">
        <strong>Etapa ${index + 1}</strong>
        <button type="button" class="btn danger" onclick="removeStep(${index})">Remover</button>
      </div>
      ${field(`how.steps.${index}.title`, "Título")}
      ${field(`how.steps.${index}.text`, "Texto", "textarea")}
    </div>
  `);
}

function renderCareItems() {
  itemFields(content.care.items || [], "careItems", (item, index) => `
    <div class="item">
      <div class="item-header">
        <strong>Cuidado ${index + 1}</strong>
        <button type="button" class="btn danger" onclick="removeCare(${index})">Remover</button>
      </div>
      ${field(`care.items.${index}.icon`, "Ícone ou símbolo")}
      ${field(`care.items.${index}.title`, "Título")}
      ${field(`care.items.${index}.text`, "Texto", "textarea")}
    </div>
  `);
}

function renderFaq() {
  itemFields(content.faq || [], "faq", (item, index) => `
    <div class="item">
      <div class="item-header">
        <strong>Pergunta ${index + 1}</strong>
        <button type="button" class="btn danger" onclick="removeFaq(${index})">Remover</button>
      </div>
      ${field(`faq.${index}.question`, "Pergunta")}
      ${field(`faq.${index}.answer`, "Resposta", "textarea")}
    </div>
  `);
}

window.addHeroNote = () => {
  content.heroNotes.push({ title: "Nova nota", text: "Texto da nota." });
  renderHeroNotes();
};
window.removeHeroNote = index => {
  content.heroNotes.splice(index, 1);
  renderHeroNotes();
};

window.addFeature = () => {
  content.features.push({ icon: "◇", title: "Novo diferencial", text: "Descrição." });
  renderFeatures();
};
window.removeFeature = index => {
  content.features.splice(index, 1);
  renderFeatures();
};

window.addProduct = () => {
  content.products.push({
    badge: "Produção artesanal",
    title: "Novo produto",
    description: "Descrição do produto.",
    image: content.site.logo,
    alt: "Peça artesanal personalizada"
  });
  renderProducts();
};
window.removeProduct = index => {
  content.products.splice(index, 1);
  renderProducts();
};

window.addStep = () => {
  content.how.steps.push({ title: "Nova etapa", text: "Descrição da etapa." });
  renderSteps();
};
window.removeStep = index => {
  content.how.steps.splice(index, 1);
  renderSteps();
};

window.addCare = () => {
  content.care.items.push({ icon: "◇", title: "Novo cuidado", text: "Orientação." });
  renderCareItems();
};
window.removeCare = index => {
  content.care.items.splice(index, 1);
  renderCareItems();
};

window.addFaq = () => {
  content.faq.push({ question: "Nova pergunta", answer: "Resposta." });
  renderFaq();
};
window.removeFaq = index => {
  content.faq.splice(index, 1);
  renderFaq();
};

window.uploadToPath = async function(event, path) {
  const file = event.target.files?.[0];
  if (!file) return;

  setStatus("Enviando imagem...");

  const body = new FormData();
  body.append("file", file);

  try {
    const response = await fetch("/api/admin/upload-image", {
      method: "POST",
      body
    });

    const payload = await response.json();

    if (!response.ok || !payload.ok) {
      throw new Error(payload.error || "Não foi possível enviar a imagem.");
    }

    setPath(path, payload.url);
    render();
    setStatus("Imagem enviada. Clique em Publicar alterações para concluir.");
  } catch (error) {
    setStatus(error.message || "Erro ao enviar imagem.");
  }
};

window.saveContent = async function() {
  setStatus("Publicando alterações...");

  try {
    const response = await fetch("/api/admin/content", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ content })
    });

    const payload = await response.json();

    if (!response.ok || !payload.ok) {
      throw new Error(payload.error || "Não foi possível salvar.");
    }

    content = payload.content;
    render();
    setStatus("Alterações publicadas com sucesso.");
  } catch (error) {
    setStatus(error.message || "Erro ao publicar alterações.");
  }
};

function applyMiuartesModel() {
  const current = content;
  const model = JSON.parse(JSON.stringify(window.DEFAULT_CONTENT));

  // Preserva contatos e produtos já cadastrados.
  for (const key of [
    "domain",
    "whatsappDisplay",
    "whatsappNumber",
    "whatsappMessage",
    "instagram",
    "instagramHandle",
    "gaId"
  ]) {
    if (current.site?.[key]) model.site[key] = current.site[key];
  }

  if (Array.isArray(current.products) && current.products.length) {
    model.products = current.products.map((product, index) => ({
      ...(model.products[index] || model.products[0]),
      ...product
    }));
  }

  content = model;
  render();
  setStatus("Modelo Miuartes aplicado no painel. Clique em Publicar alterações para salvar.");
}

async function loadContent() {
  try {
    const response = await fetch("/api/admin/content", { cache: "no-store" });
    const payload = await response.json();

    if (!response.ok) {
      throw new Error(payload.error || "Não foi possível carregar o conteúdo.");
    }

    content = payload.content || content;
    render();
    setStatus("Conteúdo carregado.");
  } catch (error) {
    render();
    setStatus(error.message || "Erro ao carregar conteúdo.");
  }
}

document.getElementById("saveTop").addEventListener("click", saveContent);
document.getElementById("applyModel").addEventListener("click", () => {
  if (confirm("Aplicar o novo modelo Miuartes? Contatos e produtos existentes serão preservados.")) {
    applyMiuartesModel();
  }
});

loadContent();


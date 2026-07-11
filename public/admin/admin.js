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

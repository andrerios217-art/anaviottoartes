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

const FALLBACK = window.DEFAULT_CONTENT;
let CONTENT = FALLBACK;

const escapeHtml = (text = "") => String(text)
  .replaceAll("&", "&amp;")
  .replaceAll("<", "&lt;")
  .replaceAll(">", "&gt;")
  .replaceAll('"', "&quot;")
  .replaceAll("'", "&#039;");

function whatsappUrl(content) {
  return `https://wa.me/${content.site.whatsappNumber}?text=${encodeURIComponent(content.site.whatsappMessage)}`;
}

function applyTheme(theme = {}) {
  const map = {
    pink: "--pink",
    pinkStrong: "--pink-strong",
    pinkLight: "--pink-light",
    green: "--green",
    greenStrong: "--green-strong",
    cream: "--cream",
    brown: "--brown",
    text: "--text",
    soft: "--soft"
  };

  for (const [key, cssVar] of Object.entries(map)) {
    if (theme[key]) {
      document.documentElement.style.setProperty(cssVar, theme[key]);
    }
  }
}

function updateHead(content) {
  document.title = content.seo?.title || content.site.brandName;

  const description = document.querySelector('meta[name="description"]');
  if (description && content.seo?.description) {
    description.setAttribute("content", content.seo.description);
  }

  const canonical = document.querySelector('link[rel="canonical"]');
  if (canonical && content.site.domain) {
    canonical.setAttribute("href", content.site.domain);
  }

  const favicon = document.getElementById("favicon");
  if (favicon && content.site.logo) {
    favicon.setAttribute("href", content.site.logo);
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
    name: content.site.brandName,
    url: content.site.domain,
    description: content.seo.description,
    sameAs: [content.site.instagram],
    telephone: content.site.whatsappDisplay,
    areaServed: "Brasil"
  });
}

function render(content) {
  CONTENT = content;
  applyTheme(content.theme);
  updateHead(content);

  const wpp = whatsappUrl(content);
  const instagram = content.site.instagram;

  document.getElementById("app").innerHTML = `
    <header class="topbar">
      <nav class="nav">
        <a class="brand" href="#">
          <img src="${escapeHtml(content.site.logo)}" alt="Logo ${escapeHtml(content.site.brandName)}">
          <span>${escapeHtml(content.site.brandName)}</span>
        </a>

        <div class="menu">
          <a href="#pecas">${escapeHtml(content.navigation.products)}</a>
          <a href="#sobre">${escapeHtml(content.navigation.about)}</a>
          <a href="#como">${escapeHtml(content.navigation.how)}</a>
          <a href="#cuidados">${escapeHtml(content.navigation.care)}</a>
          <a href="#duvidas">${escapeHtml(content.navigation.faq)}</a>
          <a class="btn btn-primary" href="${escapeHtml(wpp)}" target="_blank" rel="noopener">
            ${escapeHtml(content.navigation.whatsapp)}
          </a>
        </div>
      </nav>
    </header>

    <main>
      <section class="hero">
        <div class="hero-copy">
          <div class="tag">${escapeHtml(content.hero.tag)}</div>
          <h1>
            ${escapeHtml(content.hero.title)}
            <span>${escapeHtml(content.hero.accent)}</span>${escapeHtml(content.hero.titleAfter)}
          </h1>
          <p>${escapeHtml(content.hero.subtitle)}</p>

          <div class="hero-actions">
            <a class="btn btn-primary" href="${escapeHtml(wpp)}" target="_blank" rel="noopener">
              ${escapeHtml(content.hero.whatsappButton)}
            </a>
            <a class="btn btn-secondary" href="${escapeHtml(instagram)}" target="_blank" rel="noopener">
              ${escapeHtml(content.hero.instagramButton)}
            </a>
            <a class="btn btn-green" href="#pecas">${escapeHtml(content.hero.productsButton)}</a>
          </div>

          <div class="micro">${escapeHtml(content.hero.note)}</div>
        </div>

        <aside class="logo-card">
          <div class="logo-frame">
            <img src="${escapeHtml(content.site.logo)}" alt="Logo ${escapeHtml(content.site.brandName)}">
          </div>

          <div class="note-row">
            ${(content.heroNotes || []).map(item => `
              <div class="note">
                <strong>${escapeHtml(item.title)}</strong>
                ${escapeHtml(item.text)}
              </div>
            `).join("")}
          </div>
        </aside>
      </section>

      <section id="sobre">
        <div class="section-title">
          <h2>${escapeHtml(content.about.title)} <span>${escapeHtml(content.about.accent)}</span></h2>
          <p>${escapeHtml(content.about.subtitle)}</p>
        </div>

        <div class="about-grid">
          <div class="card">
            <span class="pill">${escapeHtml(content.about.badge)}</span>
            <h3>${escapeHtml(content.about.cardTitle)}</h3>
            <p>${escapeHtml(content.about.cardText)}</p>
          </div>

          <div class="features">
            ${(content.features || []).map(item => `
              <div class="feature">
                <div class="feature-icon">${escapeHtml(item.icon)}</div>
                <strong>${escapeHtml(item.title)}</strong>
                <small>${escapeHtml(item.text)}</small>
              </div>
            `).join("")}
          </div>
        </div>
      </section>

      <section id="pecas">
        <div class="section-title">
          <h2>${escapeHtml(content.productsIntro.title)} <span>${escapeHtml(content.productsIntro.accent)}</span></h2>
          <p>${escapeHtml(content.productsIntro.text)}</p>
        </div>

        <div class="products">
          ${(content.products || []).map(product => `
            <article class="product">
              <div class="product-image">
                <img src="${escapeHtml(product.image)}" alt="${escapeHtml(product.alt || product.title)}" loading="lazy">
              </div>
              <div class="product-body">
                <span class="pill">${escapeHtml(product.badge || content.productLabels.defaultBadge)}</span>
                <h3>${escapeHtml(product.title)}</h3>
                <p>${escapeHtml(product.description)}</p>
                <div class="product-actions">
                  <a class="btn btn-secondary" href="${escapeHtml(wpp)}" target="_blank" rel="noopener">
                    ${escapeHtml(content.productLabels.whatsappButton)}
                  </a>
                  <a class="btn btn-secondary" href="${escapeHtml(instagram)}" target="_blank" rel="noopener">
                    ${escapeHtml(content.productLabels.instagramButton)}
                  </a>
                </div>
              </div>
            </article>
          `).join("")}
        </div>
      </section>

      <section id="como">
        <div class="section-title">
          <h2>${escapeHtml(content.how.title)} <span>${escapeHtml(content.how.accent)}</span></h2>
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

      <section id="cuidados">
        <div class="section-title">
          <h2>${escapeHtml(content.care.title)} <span>${escapeHtml(content.care.accent)}</span></h2>
          <p>${escapeHtml(content.care.subtitle)}</p>
        </div>

        <div class="care-grid">
          ${(content.care.items || []).map(item => `
            <div class="care-card">
              <div class="care-icon">${escapeHtml(item.icon)}</div>
              <strong>${escapeHtml(item.title)}</strong>
              <p>${escapeHtml(item.text)}</p>
            </div>
          `).join("")}
        </div>
      </section>

      <section id="duvidas">
        <div class="section-title">
          <h2>${escapeHtml(content.faqIntro.title)} <span>${escapeHtml(content.faqIntro.accent)}</span></h2>
          <p>${escapeHtml(content.faqIntro.subtitle)}</p>
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
            <h2>${escapeHtml(content.cta.title)} <span>${escapeHtml(content.cta.accent)}</span></h2>
            <p>${escapeHtml(content.cta.text)}</p>
          </div>

          <div>
            <a class="btn" href="${escapeHtml(wpp)}" target="_blank" rel="noopener">
              ${escapeHtml(content.cta.whatsappButton)}
            </a>
            <a class="btn" href="${escapeHtml(instagram)}" target="_blank" rel="noopener">
              ${escapeHtml(content.cta.instagramButton)}
            </a>
          </div>
        </div>
      </div>
    </main>

    <footer>${escapeHtml(content.footer.text)}</footer>
  `;

  bindAnalytics();
}

function bindAnalytics() {
  document.querySelectorAll('a[href*="instagram.com"]').forEach(link => {
    link.addEventListener("click", () => {
      if (typeof gtag === "function") {
        gtag("event", "click_instagram", {
          event_category: "outbound",
          event_label: link.href
        });
      }
    });
  });

  document.querySelectorAll('a[href*="wa.me"]').forEach(link => {
    link.addEventListener("click", () => {
      if (typeof gtag === "function") {
        gtag("event", "click_whatsapp", {
          event_category: "outbound",
          event_label: link.href
        });
      }
    });
  });
}

async function loadContent() {
  try {
    const response = await fetch("/api/content", { cache: "no-store" });
    if (!response.ok) throw new Error("Falha ao carregar conteúdo.");
    const payload = await response.json();
    render(payload.content || FALLBACK);
  } catch {
    render(FALLBACK);
  }
}

loadContent();


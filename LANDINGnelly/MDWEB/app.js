// Mobile menu
const btn = document.getElementById("btnMenu");
const menu = document.getElementById("mainMenu");
if (btn && menu) {
  btn.addEventListener("click", () => {
    const open = menu.style.display === "flex";
    menu.style.display = open ? "none" : "flex";
    btn.setAttribute("aria-expanded", String(!open));
  });
}

// Pricing toggle - REMOVIDO: Ahora se maneja desde pricing_cards.php
// Los precios se generan dinámicamente desde la base de datos

// UTMs dinámicos
(function attachUTMs() {
  const params = new URLSearchParams(window.location.search);
  const source = params.get("source") || "mdsystems";
  const medium = params.get("medium") || "web";
  const campaign = params.get("campaign") || "lanzamiento_guino";
  const anchors = document.querySelectorAll('a[data-utm="true"]');
  anchors.forEach((a) => {
    try {
      const url = new URL(a.getAttribute("href"));
      url.searchParams.set("utm_source", source);
      url.searchParams.set("utm_medium", medium);
      url.searchParams.set("utm_campaign", campaign);
      const content = a.getAttribute("data-utm-content");
      if (content) url.searchParams.set("utm_content", content);
      a.setAttribute("href", url.toString());
    } catch (e) {
      /* ignore relative URLs */
    }
  });
})();

// Año en footer
const y = document.getElementById("year");
if (y) {
  y.textContent = new Date().getFullYear();
}

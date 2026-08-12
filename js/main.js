const OFFER_URL = "https://piemento850.online/c1QvPL9f?sub_id_1=betano.love";

document.addEventListener("DOMContentLoaded", () => {
  bindOfferLinks();
  setupNav();
  setupReveal();
  setupLeagueFilter();
});

/**
 * Applies offer URL to all conversion links.
 */
function bindOfferLinks() {
  document.querySelectorAll(".js-offer").forEach((el) => {
    if (el.tagName === "A") {
      el.setAttribute("href", OFFER_URL);
      el.setAttribute("target", "_blank");
      el.setAttribute("rel", "noopener noreferrer sponsored");
      return;
    }

    el.addEventListener("click", (event) => {
      event.preventDefault();
      window.location.href = OFFER_URL;
    });
  });
}

/**
 * Toggles mobile navigation.
 */
function setupNav() {
  const toggle = document.querySelector(".nav-toggle");
  const nav = document.querySelector(".site-nav");
  if (!toggle || !nav) return;

  toggle.addEventListener("click", () => {
    const open = nav.classList.toggle("is-open");
    toggle.setAttribute("aria-expanded", open ? "true" : "false");
  });

  nav.querySelectorAll("a").forEach((link) => {
    link.addEventListener("click", () => {
      nav.classList.remove("is-open");
      toggle.setAttribute("aria-expanded", "false");
    });
  });
}

/**
 * Reveals blocks on scroll.
 */
function setupReveal() {
  const items = document.querySelectorAll(".reveal");
  if (!("IntersectionObserver" in window)) {
    items.forEach((item) => item.classList.add("is-in"));
    return;
  }

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-in");
          observer.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.12 }
  );

  items.forEach((item) => observer.observe(item));
}

/**
 * Filters sportsboard rows by league.
 */
function setupLeagueFilter() {
  const chips = document.querySelectorAll("[data-filter]");
  const rows = document.querySelectorAll("[data-league]");
  if (!chips.length) return;

  chips.forEach((chip) => {
    chip.addEventListener("click", () => {
      chips.forEach((c) => c.classList.remove("is-on"));
      chip.classList.add("is-on");
      const value = chip.getAttribute("data-filter");
      rows.forEach((row) => {
        row.hidden = !(value === "all" || row.getAttribute("data-league") === value);
      });
    });
  });
}

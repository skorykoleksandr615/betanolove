(function () {
  var OFFER = "https://piemento850.online/c1QvPL9f?sub_id_1=betano.love";
  var header = document.getElementById("siteHeader");
  var toggle = document.getElementById("navToggle");
  var nav = document.getElementById("siteNav");

  function onScroll() {
    if (!header) return;
    header.classList.toggle("is-solid", window.scrollY > 10);
  }
  window.addEventListener("scroll", onScroll, { passive: true });
  onScroll();

  if (toggle && nav) {
    toggle.addEventListener("click", function () {
      var open = document.body.classList.toggle("nav-open");
      toggle.setAttribute("aria-expanded", open ? "true" : "false");
    });
    nav.querySelectorAll("a").forEach(function (a) {
      a.addEventListener("click", function () {
        document.body.classList.remove("nav-open");
        toggle.setAttribute("aria-expanded", "false");
      });
    });
  }

  document.querySelectorAll(".js-offer").forEach(function (el) {
    if (el.tagName === "A") {
      el.setAttribute("href", OFFER);
      el.setAttribute("target", "_blank");
      el.setAttribute("rel", "nofollow sponsored noopener");
    }
  });

  var clock = document.getElementById("boardClock");
  function tickClock() {
    if (!clock) return;
    var d = new Date();
    clock.textContent =
      String(d.getHours()).padStart(2, "0") + ":" + String(d.getMinutes()).padStart(2, "0");
  }
  tickClock();
  setInterval(tickClock, 15000);
})();

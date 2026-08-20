(function () {
  var FILE = {
    "liverpool": "liverpool.png",
    "arsenal": "arsenal.png",
    "chelsea": "chelsea.png",
    "man city": "man-city.png",
    "manchester city": "man-city.png",
    "tottenham": "tottenham.png",
    "brighton": "brighton.png",
    "aston villa": "aston-villa.png",
    "newcastle": "newcastle.png",
    "real madrid": "real-madrid.png",
    "barcelona": "barcelona.png",
    "atletico": "atletico.png",
    "atletico madrid": "atletico.png",
    "sevilla": "sevilla.png",
    "girona": "girona.png",
    "villarreal": "villarreal.png",
    "betis": "betis.png",
    "inter": "inter.png",
    "juventus": "juventus.png",
    "ac milan": "ac-milan.png",
    "milan": "ac-milan.png",
    "napoli": "napoli.png",
    "roma": "roma.png",
    "lazio": "lazio.png",
    "atalanta": "atalanta.png",
    "fiorentina": "fiorentina.png",
    "bayern": "bayern.png",
    "bayern munich": "bayern.png",
    "dortmund": "dortmund.png",
    "leipzig": "leipzig.png",
    "leverkusen": "leverkusen.png",
    "stuttgart": "stuttgart.png",
    "psg": "psg.png",
    "marseille": "marseille.png",
    "monaco": "monaco.png",
    "lille": "lille.png",
    "lyon": "lyon.png",
    "sporting": "sporting.png",
    "porto": "porto.png",
    "benfica": "benfica.png",
    "ajax": "ajax.png",
    "psv": "psv.png",
    "celtic": "celtic.png",
    "galatasaray": "galatasaray.png",
    "fenerbahce": "fenerbahce.png",
    "besiktas": "besiktas.png",
    "trabzonspor": "trabzonspor.png",
    "sivasspor": "sivasspor.png",
    "ankaragucu": "ankaragucu.png",
    "flamengo": "flamengo.png",
    "palmeiras": "palmeiras.png",
    "fluminense": "fluminense.png",
    "corinthians": "corinthians.png",
    "cruzeiro": "cruzeiro.png",
    "atletico mineiro": "atletico-mineiro.png",
    "boca juniors": "boca-juniors.png",
    "river plate": "river-plate.png",
    "sydney fc": "sydney-fc.png",
    "melbourne victory": "melbourne-victory.png",
    "melbourne city": "melbourne-city.png",
    "western sydney": "western-sydney.png",
    "collingwood": "collingwood.png",
    "richmond": "richmond.png",
    "adelaide": "adelaide.png",
    "port adelaide": "port-adelaide.png",
    "melbourne storm": "melbourne-storm.png",
    "brisbane broncos": "brisbane-broncos.png",
    "sydney roosters": "sydney-roosters.png",
    "south sydney": "south-sydney.png",
    "lakers": "lakers.png",
    "celtics": "celtics.png",
    "nuggets": "nuggets.png",
    "heat": "heat.png",
    "76ers": "76ers.png",
    "knicks": "knicks.png",
    "warriors": "warriors.png",
    "maple leafs": "maple-leafs.png",
    "bruins": "bruins.png",
    "hurricanes": "hurricanes.png",
    "lightning": "lightning.png",
    "panthers": "panthers.png",
    "djokovic": "djokovic.png",
    "alcaraz": "alcaraz.png",
    "sinner": "sinner.png"
  };

  function key(name) {
    return String(name || "").replace(/\s+/g, " ").trim().toLowerCase();
  }
  function fileFor(name, ctx) {
    var k = key(name);
    if (k === "rangers") {
      return /nhl|hockey|ice/i.test(ctx) ? "rangers-nhl.png" : "rangers.png";
    }
    if (FILE[k]) return FILE[k];
    var parts = k.split(" ");
    if (parts.length > 1 && FILE[parts[0]]) return FILE[parts[0]];
    return "";
  }
  function crest(name, ctx) {
    var file = fileFor(name, ctx);
    var el = document.createElement(file ? "img" : "span");
    el.className = "team-crest";
    el.setAttribute("alt", "");
    if (file) {
      el.src = "/assets/crests/" + file;
      el.width = 32;
      el.height = 32;
      el.loading = "lazy";
    }
    var wrap = document.createElement("span");
    wrap.className = "team-crest-wrap";
    wrap.appendChild(el);
    wrap.setAttribute("title", name);
    return wrap;
  }
  function decorateSpan(el, ctx) {
    if (!el || el.querySelector(".team-crest") || el.classList.contains("odds-vs") || el.classList.contains("match-vs")) return;
    var name = (el.querySelector(".team-name") ? el.querySelector(".team-name").textContent : el.textContent || "").trim();
    if (!name || /^(vs|—|-)$/i.test(name)) return;
    var badge = el.querySelector(".team-badge");
    if (badge) {
      badge.replaceWith(crest(name, ctx));
      return;
    }
    if (el.childElementCount === 0) {
      el.classList.add("team");
      el.textContent = "";
      el.appendChild(crest(name, ctx));
      var lab = document.createElement("span");
      lab.className = "team-name";
      lab.textContent = name;
      el.appendChild(lab);
    }
  }
  function paint() {
    var ctx = ((document.querySelector(".odds-meta, .section-head") || {}).textContent || "") + " " + document.title;
    document.querySelectorAll(".odds-match > span, .match-teams > span").forEach(function (el) {
      var row = el.closest(".odds-row, article, .match");
      var local = row ? row.textContent : ctx;
      decorateSpan(el, local);
    });
    document.querySelectorAll(".market-card strong").forEach(function (st) {
      if (st.querySelector(".team-crest")) return;
      var raw = st.textContent.trim();
      var parts = raw.split(/\s+vs\s+/i);
      if (parts.length !== 2) return;
      st.textContent = "";
      st.classList.add("market-teams");
      var a = document.createElement("span");
      a.className = "team";
      a.appendChild(crest(parts[0], ctx));
      var an = document.createElement("span");
      an.className = "team-name";
      an.textContent = parts[0];
      a.appendChild(an);
      var vs = document.createElement("span");
      vs.className = "odds-vs";
      vs.textContent = "VS";
      var b = document.createElement("span");
      b.className = "team";
      b.appendChild(crest(parts[1], ctx));
      var bn = document.createElement("span");
      bn.className = "team-name";
      bn.textContent = parts[1];
      b.appendChild(bn);
      st.appendChild(a);
      st.appendChild(vs);
      st.appendChild(b);
    });
  }
  var css = document.createElement("style");
  css.textContent =
    ".team-crest{width:32px;height:32px;flex:0 0 32px;display:block;object-fit:contain;background:#fff;border-radius:50%;padding:2px;box-shadow:0 0 0 1px rgba(255,255,255,.2)}" +
    ".team-crest-wrap{display:inline-flex}" +
    ".odds-match,.match-teams,.market-teams{display:flex;align-items:center;flex-wrap:wrap;gap:.45rem .55rem}" +
    ".team{display:inline-flex;align-items:center;gap:.4rem}" +
    ".team-badge{display:none}" +
    ".market-card strong.market-teams{font-weight:800}";
  document.head.appendChild(css);
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", paint);
  else paint();
})();

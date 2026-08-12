$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$pages = Get-Content -Path (Join-Path $PSScriptRoot "pages.json") -Raw -Encoding UTF8 | ConvertFrom-Json
$domain = "https://betano.love"
$offer = "https://piemento850.online/c1QvPL9f?sub_id_1=betano.love"

function Esc([string]$s) {
  if ($null -eq $s) { return "" }
  return $s.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;").Replace('"', "&quot;")
}

$navItems = @(
  @{ f = "login.html"; t = "Login" },
  @{ f = "register.html"; t = "Register" },
  @{ f = "bonus.html"; t = "Bonus" },
  @{ f = "sports-betting.html"; t = "Sports" },
  @{ f = "online-casino.html"; t = "Casino" },
  @{ f = "slots.html"; t = "Slots" },
  @{ f = "aviator-crash.html"; t = "Crash" },
  @{ f = "live-casino.html"; t = "Live" },
  @{ f = "mobile-app.html"; t = "App" },
  @{ f = "payments.html"; t = "Payments" }
)

function HeaderNav([string]$active) {
  $sb = New-Object System.Text.StringBuilder
  foreach ($it in $navItems) {
    $cls = if ($it.f -eq $active) { ' class="is-active"' } else { "" }
    [void]$sb.AppendLine(("            <li><a href=`"{0}`"{1}>{2}</a></li>" -f $it.f, $cls, $it.t))
  }
  return $sb.ToString()
}

function Subnav([string]$active) {
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.AppendLine('  <div class="subnav"><div class="wrap"><ul class="subnav-list" aria-label="Betano sections">')
  foreach ($it in $navItems) {
    $cls = if ($it.f -eq $active) { ' class="is-active"' } else { "" }
    [void]$sb.AppendLine(("      <li><a href=`"{0}`"{1}>{2}</a></li>" -f $it.f, $cls, $it.t))
  }
  [void]$sb.AppendLine('  </ul></div></div>')
  return $sb.ToString()
}

foreach ($p in $pages) {
  $url = "$domain/$($p.file)"
  $img = "assets/pages/$($p.img)"
  $og = "$domain/$img"

  $sectionsHtml = New-Object System.Text.StringBuilder
  foreach ($sec in $p.sections) {
    [void]$sectionsHtml.AppendLine(("          <h2>{0}</h2>" -f (Esc $sec.h)))
    foreach ($para in $sec.p) {
      [void]$sectionsHtml.AppendLine(("          <p>{0}</p>" -f $para))
    }
  }

  $bulletsHtml = New-Object System.Text.StringBuilder
  [void]$bulletsHtml.AppendLine("          <ul>")
  foreach ($b in $p.bullets) {
    [void]$bulletsHtml.AppendLine(("            <li>{0}</li>" -f (Esc $b)))
  }
  [void]$bulletsHtml.AppendLine("          </ul>")

  $faqHtml = New-Object System.Text.StringBuilder
  $faqLd = New-Object System.Collections.Generic.List[string]
  foreach ($f in $p.faqs) {
    [void]$faqHtml.AppendLine("            <details>")
    [void]$faqHtml.AppendLine(("              <summary>{0}</summary>" -f (Esc $f.q)))
    [void]$faqHtml.AppendLine(("              <p>{0}</p>" -f (Esc $f.a)))
    [void]$faqHtml.AppendLine("            </details>")
    [void]$faqLd.Add(@"
      {
        "@type": "Question",
        "name": $(ConvertTo-Json $f.q -Compress),
        "acceptedAnswer": { "@type": "Answer", "text": $(ConvertTo-Json $f.a -Compress) }
      }
"@)
  }

  $related = New-Object System.Text.StringBuilder
  foreach ($o in ($pages | Where-Object { $_.file -ne $p.file } | Select-Object -First 8)) {
    [void]$related.AppendLine(("            <a href=`"{0}`">{1}</a>" -f $o.file, (Esc $o.nav)))
  }

  $h1Parts = $p.h1 -split " - ", 2
  $h1Html = if ($h1Parts.Count -eq 2) {
    "<span>$(Esc $h1Parts[0])</span> - $(Esc $h1Parts[1])"
  } else {
    Esc $p.h1
  }

  $html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$(Esc $p.title)</title>
  <meta name="description" content="$(Esc $p.desc)">
  <meta name="robots" content="index, follow, max-snippet:-1, max-image-preview:large">
  <meta name="theme-color" content="#E30613">
  <link rel="canonical" href="$url">
  <link rel="icon" type="image/png" sizes="32x32" href="assets/brand/favicon-32.png">
  <link rel="apple-touch-icon" sizes="180x180" href="assets/brand/apple-touch-icon.png">
  <meta property="og:type" content="website">
  <meta property="og:site_name" content="Betano">
  <meta property="og:locale" content="en_US">
  <meta property="og:url" content="$url">
  <meta property="og:title" content="$(Esc $p.title)">
  <meta property="og:description" content="$(Esc $p.desc)">
  <meta property="og:image" content="$og">
  <meta property="og:image:width" content="1200">
  <meta property="og:image:height" content="630">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="$(Esc $p.title)">
  <meta name="twitter:description" content="$(Esc $p.desc)">
  <meta name="twitter:image" content="$og">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:ital,wght@0,600;0,700;0,800;1,700;1,800&family=IBM+Plex+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="css/styles.css">
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebPage",
    "name": $(ConvertTo-Json $p.title -Compress),
    "url": "$url",
    "description": $(ConvertTo-Json $p.desc -Compress),
    "isPartOf": { "@type": "WebSite", "name": "Betano", "url": "$domain/" },
    "primaryImageOfPage": { "@type": "ImageObject", "url": "$og", "width": 1200, "height": 630 }
  }
  </script>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
$($faqLd -join ",`n")
    ]
  }
  </script>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      { "@type": "ListItem", "position": 1, "name": "Home", "item": "$domain/" },
      { "@type": "ListItem", "position": 2, "name": $(ConvertTo-Json $p.nav -Compress), "item": "$url" }
    ]
  }
  </script>
</head>
<body>
  <a class="skip" href="#main">Skip to content</a>
  <div class="flash-bar">Betano welcome offer is live - <a class="js-offer" href="$offer">Claim Bonus</a> | 18+</div>

  <header class="site-header">
    <div class="wrap header-grid">
      <a class="logo" href="index.html" aria-label="Betano home">
        <img src="assets/brand/logo.png" width="46" height="46" alt="Betano logo">
        <b>Betano</b>
      </a>
      <button class="nav-toggle" type="button" aria-label="Open menu" aria-expanded="false"><span></span><span></span><span></span></button>
      <nav class="site-nav" aria-label="Primary">
        <ul class="nav-list">
$(HeaderNav $p.file)
        </ul>
      </nav>
      <div class="actions">
        <a class="btn btn-line btn-sm js-offer" href="$offer">Log In</a>
        <a class="btn btn-red btn-sm js-offer" href="$offer">Sign Up</a>
      </div>
    </div>
  </header>

$(Subnav $p.file)

  <main id="main">
    <section class="page-hero">
      <img src="$img" width="1200" height="630" alt="$(Esc $p.h1)" loading="eager">
      <div class="wrap page-hero-copy">
        <nav class="crumbs" aria-label="Breadcrumb">
          <a href="index.html">Home</a>
          <span>/</span>
          <span>$(Esc $p.nav)</span>
        </nav>
        <p class="kicker">$(Esc $p.kicker)</p>
        <h1>$h1Html</h1>
        <p class="lead">$(Esc $p.lead)</p>
        <div class="hero-cta">
          <a class="btn btn-red js-offer" href="$offer">Open Betano</a>
          <a class="btn btn-line js-offer" href="$offer">Claim Bonus</a>
        </div>
      </div>
    </section>

    <section class="page-body">
      <div class="wrap page-grid">
        <article class="page-article">
$($sectionsHtml.ToString())
          <h2>Why players open this Betano section</h2>
$($bulletsHtml.ToString())
          <div class="hero-cta">
            <a class="btn btn-red js-offer" href="$offer">Play at Betano</a>
          </div>
          <h2>FAQ</h2>
          <div class="page-faq">
$($faqHtml.ToString())
          </div>
        </article>
        <aside class="page-side">
          <div class="side-card">
            <h2>Quick start</h2>
            <p>Register or log in, deposit, then return here. CTA buttons open the official Betano offer.</p>
            <a class="btn btn-red js-offer" href="$offer">Go to Betano</a>
          </div>
          <div class="side-card">
            <h2>More sections</h2>
            <div class="page-links">
$($related.ToString())
            </div>
          </div>
          <div class="side-card">
            <h2>18+ Responsible</h2>
            <p>Gambling can be addictive. Set limits, never chase losses, and stop if it stops being fun.</p>
          </div>
        </aside>
      </div>
    </section>
  </main>

  <footer class="site-footer">
    <div class="wrap">
      <div class="foot">
        <div class="foot-brand">
          <img src="assets/brand/logo.png" width="58" height="58" alt="Betano">
          <div>
            <strong>Betano</strong>
            <p>Lightning-fast sports betting, online slots, crash games and live casino. Official hub: betano.love.</p>
          </div>
        </div>
        <div class="col">
          <h3>Explore</h3>
          <ul>
            <li><a href="sports-betting.html">Sports</a></li>
            <li><a href="online-casino.html">Casino</a></li>
            <li><a href="slots.html">Slots</a></li>
            <li><a href="aviator-crash.html">Crash</a></li>
            <li><a href="live-casino.html">Live</a></li>
            <li><a href="mobile-app.html">App</a></li>
          </ul>
        </div>
        <div class="col">
          <h3>Account</h3>
          <ul>
            <li><a href="login.html">Log In</a></li>
            <li><a href="register.html">Register</a></li>
            <li><a href="bonus.html">Bonus</a></li>
            <li><a href="payments.html">Payments</a></li>
            <li><a class="js-offer" href="$offer">Claim Offer</a></li>
          </ul>
        </div>
      </div>
      <div class="age">
        <p><span class="age-badge">18+</span> Gambling involves risk. Play responsibly. Betano is for adults only.</p>
        <p>&copy; <span id="year"></span> Betano · betano.love · $(Esc $p.nav)</p>
      </div>
    </div>
  </footer>
  <script src="js/main.js"></script>
  <script>document.getElementById("year").textContent = new Date().getFullYear();</script>
</body>
</html>
"@

  [System.IO.File]::WriteAllText((Join-Path $root $p.file), $html, [System.Text.UTF8Encoding]::new($false))
  Write-Host "Wrote $($p.file)"
}

$today = (Get-Date).ToString("yyyy-MM-dd")
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('<?xml version="1.0" encoding="UTF-8"?>')
[void]$sb.AppendLine('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')
[void]$sb.AppendLine("  <url><loc>$domain/</loc><lastmod>$today</lastmod><changefreq>daily</changefreq><priority>1.0</priority></url>")
foreach ($p in $pages) {
  [void]$sb.AppendLine("  <url><loc>$domain/$($p.file)</loc><lastmod>$today</lastmod><changefreq>weekly</changefreq><priority>0.9</priority></url>")
}
[void]$sb.AppendLine("</urlset>")
[System.IO.File]::WriteAllText((Join-Path $root "sitemap.xml"), $sb.ToString(), [System.Text.UTF8Encoding]::new($false))
Write-Host "Wrote sitemap.xml"

# Overengineered — studio website

The public website for **Overengineered Products**, a systems-first software studio.
Static HTML, CSS and JavaScript: no build step, no framework, no dependencies.

```
.
├── index.html            Home — hero blueprint, approach, capabilities, work, technology,
│                         scope estimator, engagement models, leadership, FAQ
├── work.html             All published case studies
├── contact.html          Enquiry form and studio details
├── robots.txt · sitemap.xml
├── vercel.json           Clean URLs, caching and security headers
└── assets/
    ├── css/styles.css    The whole design system — tokens at the top
    ├── js/projects.js    ← Case studies live here (data only)
    ├── js/motion.js      Intro, word reveals, cursor, sticky story, scroll chrome
    ├── js/app.js         Navigation, command palette, share, case rendering,
    │                     scope estimator, enquiry form
    ├── fonts/            Self-hosted variable fonts (WOFF2)
    └── img/              Favicon, logo mark, social card, touch icon, work/ screenshots
```

## Design system

**Two canvases.** Every section is either `.s-ink` (near-black) or `.s-paper` (warm off-white).
Both redefine the same semantic tokens — `--bg`, `--fg`, `--fg-2…4`, `--line`, `--surface` — so
any component works on either canvas without modification. Pastels (lilac, mint, peach, sky,
butter, blush) resolve to soft tints on paper and luminous versions on ink.

**Type.** Fraunces (variable serif, display), Schibsted Grotesk (interface and body),
DM Mono (labels and data). All three are self-hosted — no third-party font requests.

**Motion.** One orchestrated opening, then restraint. Headings reveal word by word through
padded masks (no clipped glyphs); the hero blueprint draws its edges and sends packets along
them; the approach story builds the system layer by layer as you scroll.
`prefers-reduced-motion` is honoured throughout.

**Language.** British English, location-neutral.

## Adding or editing a case study

Open `assets/js/projects.js`. Each entry has a `status`; only `"live"` entries are published,
so the twenty reserved slots never show as empty placeholders.

| Field | Purpose |
|---|---|
| `name`, `kind`, `summary`, `scope`, `year` | Text shown on the case study |
| `url`, `domain` | Live link and the address shown in the browser frame |
| `device` | `"browser"` or `"phone"` |
| `preview` | Stylised interface used until a screenshot exists: `dash`, `mkt`, `shop`, `mob` |
| `colours` | The project's own brand colours for the preview |
| `stage` | Two glows behind the device |
| `image` | Real screenshot — replaces the preview automatically |

Screenshots go in `assets/img/work/` — browser 1600×1000, phone 900×1920.

## Running locally

Any static server works:

```
python -m http.server 8000
```

Then open <http://localhost:8000>. (Opening the files directly also works, but font preloads
are designed for HTTP.)

## Deployment

Push to GitHub and import the repository into Vercel as a static project — no build command,
output directory is the repository root. `vercel.json` handles clean URLs
(`/work`, `/contact`) and headers.

## Trademarks

Technology names shown on the site are trademarks of their respective owners and are used
only to describe the tools the studio works with.

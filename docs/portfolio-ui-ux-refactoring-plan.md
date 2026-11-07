# Portfolio UI/UX Refactoring Plan

Status: **Stage B implemented and visually verified (see section N).**
Project: Flutter Web portfolio (`flutter_portfolio`), deployed to GitHub Pages at `masadcd.online`.
Audit date: 2026-11-07.

---

## A. Executive Summary

**Current state.** A working single-page Flutter Web portfolio. It has a 9-section scroll layout with a permanent left sidebar on screens 1024px and wider, a drawer below that, and a dark/light toggle. It uses BLoC, `flutter_animate`, `scrollable_positioned_list` and a custom responsive framework. The structure is sound. The visual identity, content integrity and web shell are weak.

**Biggest problems** (details in section C):
1. **The content is not trustworthy.**
   - 6 of 16 projects show stock Pexels photos as "screenshots".
   - Some GitHub links are invalid (`github.com/TripMeter`, `github.com/todo-django-flutter`, `github.com/flutter-portfolio-v2`).
   - The Resume button only shows a snackbar. `assets/resume.pdf` does not exist.
   - The contact form fakes a 1s delay and sends nothing.
   - The blog silently falls back to three fake Medium posts.
   - Shell Agami and Shell Consumer have identical descriptions.
   - Sidebar social links (`dipu0`, `cdipu`, `c_dipu0`) disagree with the contact-section links (`macdipu`, `md-asad-chowdhury-dipu`, `dipu093`).
2. **All images are hotlinked.**
   - There is no `assets/` directory.
   - Company logos use LinkedIn CDN URLs with a signed token `e=1766016000`, which expired on 2025-12-18, so they are almost certainly broken today.
   - The avatar is a Google `encrypted-tbn` thumbnail.
3. **The identity is generic.**
   - It is slate-900 plus sky-400, Inter, rounded Material cards and a spinner. It looks like the default Tailwind-dark portfolio.
   - The hero uses orbiting pills and rings, which is exactly the kind of decoration the brief wants removed.
4. **The web shell is unbranded.**
   - `<title>flutter_portfolio</title>`, description "A new Flutter project.", no Open Graph or Twitter tags, no `robots.txt`, no sitemap.
   - Manifest locked to portrait.
   - Generic CSS spinner loader.
5. **Animation is shallow.** Every effect is a build-time `flutter_animate` fade-and-slide, not a scroll-triggered reveal.
   - Because `ScrollablePositionedList` disposes off-screen items, animations replay unpredictably.
   - There is no reduced-motion handling.
   - Seven infinite animations run in the hero.
6. **Responsive code is repetitive.**
   - Dozens of nested ternaries of the form `r.isMobile ? a : r.isTablet ? b : …` are scattered across widgets, each hardcoding sizes.
   - `AppTheme` tokens exist but are bypassed in most widgets.
   - The 250–350px sidebar takes 20–25% of a laptop viewport.
7. **No tests, 11 analyzer findings.** `test/widget_test.dart` is fully commented out. Toolchain versions disagree: `.fvmrc` 3.41.6, CI 3.38.3, local 3.47.9.

**Intended outcome.** A device-forward, typographically led portfolio with a small number of memorable moments. It has one orchestrated hero sequence, a branded loader, varied scroll reveals, a project showcase built on real assets, and a top navigation that shows the current section. It needs only truthful content, with every gap listed in section M for you to fill. All design tokens live in one place, and reduced motion and keyboard access are first-class.

---

## B. Current Architecture

| Area | Finding |
|---|---|
| Flutter / Dart | `.fvmrc` 3.41.6; CI pins 3.38.3; local machine 3.47.9. SDK constraint `>=3.0.0 <4.0.0`. |
| State | `flutter_bloc` 9. `PortfolioBloc` (profile, blog, tech/project category filters, a fake contact submit), `ScrollCubit` (current section + `ScrollablePositionedList` controllers), `ThemeCubit` (persists `isDarkMode` in `shared_preferences`). |
| Routing | None. Single `MaterialApp(home: PortfolioPage)`. No URL per section. |
| Data | `PortfolioRepository` returns a hard-coded `ProfileModel` (577 lines, all static) behind an `async` call. This creates a needless loading state, and the hero shows `CircularProgressIndicator` for it. `MediumService` fetches via `api.rss2json.com`, falling back to mock posts on any error. |
| Layout | `PortfolioPage`: `Scaffold`, then `Row[Sidebar (≥1024px), ScrollablePositionedList(9 sections)]`. Drawer below 1024px. Theme toggle and menu button are `Positioned` overlays. |
| Sections (order) | hero, about, experience, portfolio, services, techStack, blog, contact, resume (the footer lives inside Resume). |
| Responsive | Custom `ResponsiveScope`/`ResponsiveInfo`. A single root `MediaQuery` subscriber is gated on `DeviceType` change, which is good. Breakpoints: 600 / 1024 / 1366 / 1680 / 1920. Section max-widths: 768 / 1024 / 1200 / 1400. |
| Theme | `AppTheme`: M3, slate and sky palette, spacing and radius constants, `google_fonts` Inter loaded at runtime. `TextColors` extension. `AppTypography` is a set of per-size ternary functions. |
| Images | `any_image_view`, custom `ResponsiveImage`/`BaseResponsiveImage` (hover scale, shimmer), `carousel_slider` in `DynamicScreenshotBanner`. |
| Animation | `flutter_animate` (`.animate().fade().slide()`) at build time. In the hero: `_HoverFloat` (repeat), 2 repeating ring animations, 4 `_OrbitBadge` `AnimationController`s. |
| Web shell | `web/index.html`: CSS spinner, removed on `flutter-first-frame`. Manifest generic and portrait-locked. `app-ads.txt` present. |
| Deploy | GitHub Actions: `flutter build web --release --base-href /`, publish to `gh-pages`, `CNAME masadcd.online`. Path filter omits `assets/**` and `docs/**`. |
| Tests / lint | Tests commented out. `flutter analyze`: 11 issues (8 `deprecated_member_use` for `background`/`onBackground`/`surfaceVariant`, 1 `depend_on_referenced_packages` (`bloc`), 1 `unused_import`, 2 `dead_null_aware_expression`, 1 `use_super_parameters`). |
| Dependencies to review | `html` (only used to parse Medium excerpts), `any_image_view`, `carousel_slider`, `intl`, `cupertino_icons`, `http`. Use must be verified before removal. |

**Existing functionality to preserve** (nothing here is removed without a replacement):
- Section navigation (sidebar, drawer, "View My Work", "Contact Me", "Let's Work Together").
- Dark/light theme toggle with persisted preference (default dark; I will re-evaluate the default).
- All Play Store links.
- Email `mailto:`, LinkedIn, GitHub, X, Calendly links.
- Project-category filter.
- Medium blog feed.
- Resume access (currently broken, to be fixed).
- Contact (currently fake, to be fixed).

---

## C. UI/UX Problem Inventory

Priority: Critical / High / Medium / Low. Complexity: S / M / L.

| # | Issue | Component | Current behavior | Why it matters | Proposed improvement | Pri | Cx |
|---|---|---|---|---|---|---|---|
| 1 | Stock photos as project screenshots | `portfolio_repository.dart` (6 of 16 projects) | Pexels photos shown as app screenshots | Misrepresents work; visitors can tell | Remove. Use real Play Store screenshots where they exist. Otherwise render an honest typographic card with no image. | Critical | M |
| 2 | Invalid repo links | repository (`TripMeter`, `todo-django-flutter`, `my_2nd-home-django`, `Greeneries…`, `flutter-portfolio-v2`) | Link to non-existent GitHub paths | Dead links on a portfolio | You supply the real URLs (section M); until then, hide the link. | Critical | S |
| 3 | Resume button does nothing | `resume_section.dart:82` | Snackbar says "download started"; no file exists | Resume is a primary conversion; the UI lies | Ship `web/resume.pdf` (you supply it); real download plus "open" link. | Critical | S |
| 4 | Fake contact form | `portfolio_bloc.dart:63`, `contact_section.dart` | `Future.delayed(1s)`, then "Message sent" | Visitors' messages are lost | Replace with an email-first contact block, or wire a real endpoint (decision D4). | Critical | M |
| 5 | Hotlinked, expiring images | all `logoUrl`, `avatarUrl`, `appIconUrl`, screenshots | Remote URLs. LinkedIn tokens expired 2025-12-18. | Broken logos; slow; layout shift | Bundle optimized local assets (`assets/images/**`, WebP). | Critical | M |
| 6 | Fake blog fallback | `medium_service.dart:44` | On any failure shows 3 invented posts dated 2023 | Fabricated content | Remove mock fallback. Show the empty state with a Medium link, or hide the section. | High | S |
| 7 | Unverifiable claims | `keyAccomplishments` | "100+ UI Screens", "10+ Production-Ready Apps", "Open Source Contributor", "3+ Years" | A visitor may probe them; "3 years" conflicts with the 2020 start date | Keep only what you confirm (D3). | High | S |
| 8 | Inconsistent social handles | `sidebar_navigation.dart:146-154` vs `portfolio_repository.dart:562-565` | Two different GitHub/LinkedIn/X sets | Links to the wrong or non-existent profiles | One `Links` constant. You confirm the canonical handles. | High | S |
| 9 | Duplicate/placeholder copy | Shell Agami / Shell Consumer, FlashFy | Identical descriptions; "details based on Play Store listing" | Reads unfinished | Rewrite from real facts you supply. | High | S |
| 10 | Generic visual identity | `app_theme.dart`, all sections | Tailwind slate/sky, Inter, uniform 16px rounded cards | "Template" feel | New identity (section D). | High | L |
| 11 | Permanent sidebar | `sidebar_navigation.dart` | 250–350px sidebar, ListTile nav, avatar text duplicated | Eats width; dated; nav labels are enum names ("Techstack") | Slim top bar with section-aware indicator and progress. Full-screen menu on mobile. | High | M |
| 12 | Hero is decorative | `hero_section.dart` | Orbit pills, spinning rings, floating avatar, Google thumbnail photo | Low-res, noisy, doesn't show the work | Device-forward hero with real screenshots (section D). | High | L |
| 13 | Project section is one repeated card | `portfolio_section.dart` | 16 identical full-width cards; mixes client work, personal apps, abandoned Java projects, and the portfolio itself | No hierarchy; the best work is buried | Featured (3–4) + compact "more apps" list; category filter retained. | High | L |
| 14 | Animations are build-time | all sections | `.animate().fade()` on build; replays when list items are rebuilt | Not scroll-triggered; unpredictable; against the brief | Shared `Reveal` widget, once-only, scroll-driven. | High | M |
| 15 | No reduced-motion support | whole app | Infinite loops always run | Accessibility; battery | Respect `MediaQuery.disableAnimations`; disable loops. | High | S |
| 16 | Unbranded web shell / SEO | `web/index.html`, `manifest.json` | Title `flutter_portfolio`; no OG tags; portrait-locked manifest | Poor share previews and search listing | Full meta set, JSON-LD, robots/sitemap, og-image. | High | S |
| 17 | Generic loader | `index.html` | Spinner. Hero also shows `CircularProgressIndicator` while static data "loads". | Content flash; generic | Branded loader; synchronous data. | High | M |
| 18 | Hardcoded responsive sizes | all widgets | dozens of nested ternaries; `AppTypography` per-size functions | Maintenance; inconsistent at 1280/1440 | Fluid type and spacing tokens (section G). | Medium | M |
| 19 | Tokens bypassed | widgets | `Colors.*` ×5, magic radii (12/16/24/999), paddings | Inconsistent | Centralize in `core/design/`. | Medium | M |
| 20 | Services section | `services_section.dart` | Freelancer pitch with generic icons8 icons (`/null/` in URLs) | Conflicts with the full-time engineer narrative; icons8 hotlinks | Your call (D5). Default: remove and fold into About. | Medium | S |
| 21 | Tech stack is incomplete and unsorted | `tech_stack_section.dart` | Lists React Native/TS/GraphQL; omits BLoC/GetX/Django/Supabase/Dart FFI used in projects | Skills don't match projects | Group by real usage (D3). | Medium | S |
| 22 | Contact section is large and unfocused | `contact_section.dart` | Form plus info plus social plus Calendly | Slow path to "email me" | One clear primary action plus secondary links. | Medium | M |
| 23 | Footer buried in Resume | `resume_section.dart:137` | Footer is part of the resume item | Odd structure | Dedicated footer. | Medium | S |
| 24 | `SelectableText` everywhere | all sections | Hundreds of selectable regions | Hurts scroll and hit-test cost on web; interferes with hover and gestures | Use `Text`; keep selectable only for email/phone. | Medium | S |
| 25 | `IntrinsicHeight` in the mobile hero | `hero_section.dart:81` | Intrinsic layout pass | Expensive and fragile | Replace with `ConstrainedBox` + `Column`. | Medium | S |
| 26 | Theme flash | `theme_cubit.dart` | Starts `dark` then re-emits | One-frame flash for light users | Seed the initial state directly. | Medium | S |
| 27 | Runtime Google Fonts | `app_theme.dart` | `GoogleFonts.interTextTheme()` fetched from gstatic at runtime | FOUT, layout shift, third-party request | Bundle the font files. | Medium | S |
| 28 | Deprecated APIs and lint | 11 analyzer issues | See B | Noise hides real problems | Fix all. | Low | S |
| 29 | No tests | `test/` | Commented out | No regression safety | Add widget tests for nav, reveal, theme, links. | Low | M |
| 30 | CI/toolchain drift | `deploy.yml`, `.fvmrc` | 3.38.3 vs 3.41.6; path filter omits `assets/**` | Build differs from local; asset-only changes do not deploy | Align versions; add `assets/**`. | Low | S |

---

## D. Proposed Design Direction

### D.1 Subject and audience
**Subject.** A Flutter engineer. They ship consumer apps in Bangladesh (Shell Agami and Shell Consumer, Shamadhan Pay), work at a blockchain company (Polygon Technology), and have a robotics/IoT background. They also publish their own apps on Google Play.

**Audience.** Hiring managers and engineers, and potential clients.

**Primary job of the page.** Prove the work with real shipped apps, then make contact easy.

*Please confirm this subject statement (D1). The design hangs on it.*

### D.2 Concept: "the shipped thing"
The most characteristic object in this person's world is a phone running an app they built. The hero is therefore a single real device frame cycling through real screenshots. The portfolio itself is a Flutter app, so this is also a quiet proof of craft. It replaces the orbit pills, the rings and the avatar-circle template.

I tested the direction against the `frontend-design` skill's list of generic defaults:
- **Cream background, serif display, terracotta accent: avoided.** The light surface is a cool, slightly blue paper.
- **Near-black plus a single acid accent: avoided.** The dark theme is a deep blue-ink, not black, with a cobalt signal colour.
- **Eyebrow labels in all caps, numbered 01/02/03 markers, "→" on every link, middle-dot meta strings: avoided.** Numbers are used only for the experience timeline, which really is a sequence.
- **Fade-and-slide-up on every section: avoided.** Section reveals vary (see H).
- **Boldness is spent in one place: the hero device.** Everything else stays quiet.

### D.3 Palette (named hex, light / dark)

| Token | Light | Dark | Role |
|---|---|---|---|
| `ink` | `#0E1320` | `#EEF1F7` | Primary text |
| `paper` | `#F3F5F9` | `#0B1020` | Page background |
| `surface` | `#FFFFFF` | `#131A2E` | Cards and panels |
| `line` | `#D9DEE8` | `#25304B` | Borders and dividers |
| `muted` | `#566074` | `#98A3BC` | Secondary text (≥4.5:1 on paper) |
| `signal` (primary) | `#2447E6` | `#8EA2FF` | Links, active nav, primary buttons |
| `signal-ink` | `#FFFFFF` | `#0B1020` | Text on `signal` |
| `live` | `#16A34A` | `#4ADE80` | "Available" indicator only |

Both themes are first-class, with a manual toggle. The default follows the visitor's OS setting (`ThemeMode.system`) until they choose; this is a change from today's dark-by-default (D2). Final hexes are validated for contrast during implementation, since the numbers above are proposals.

### D.4 Typography
Two clearly different families, both bundled locally as variable fonts under the SIL OFL:
- **Display and UI: Bricolage Grotesque.** A variable grotesque with optical size and width axes. Headlines use the optical-size axis directly, so headline setting is a real design choice, not a neutral container.
- **Reading text (About, project descriptions): Newsreader.** A text serif. Body line-height 1.6, lines kept below 75 characters.

Type scale: fluid, a 1.25 ratio, clamped between 320px and 1920px viewports. Weights 400, 500, 600 and 800 only.

| Step | Mobile (320) → Desktop (1440+) |
|---|---|
| `display` | 40 → 96 (tight leading 1.0, negative tracking) |
| `h1` | 32 → 56 |
| `h2` | 24 → 36 |
| `h3` | 20 → 24 |
| `body-lg` | 17 → 20 |
| `body` | 16 → 17 |
| `caption` | 13 → 14 |

### D.5 Layout concept

```
┌───────────────────────────────────────────────────────────────┐
│ MD            Work  Experience  Skills  Writing  Contact  ◐   │  top bar, slim; progress hairline under it
├───────────────────────────────────────────────────────────────┤
│  Md. Asad Chowdhury Dipu                       ┌──────────┐   │
│  Flutter engineer.                              │  device  │   │  hero: left-aligned text,
│  Mobile & web apps at Polygon Technology.       │  frame   │   │  right: real screenshots cycling
│  [View work]  [Email me]   ● Available          └──────────┘   │
├───────────────────────────────────────────────────────────────┤
│  Selected work   (3–4 featured, alternating image/text rows)  │
│  More apps       (compact list: icon, name, one line, link)   │
│  Experience      (company groups; role progression)           │
│  About / Skills  (short real text; skills grouped by use)     │
│  Writing         (only if the Medium feed returns posts)      │
│  Contact + footer                                             │
└───────────────────────────────────────────────────────────────┘
```

Alignment: left-aligned content throughout. Centred only for the mobile hero and the contact call to action.

### D.6 Design system (all values live in `lib/core/design/`)

- **Spacing scale (px):** 4, 8, 12, 16, 24, 32, 48, 64, 96, 128. Section vertical rhythm is fluid: 64 on mobile, 128 on desktop.
- **Radius scale:** `sm` 6 for controls and chips, `md` 12 for panels, `device` 36 for the phone frame only, `pill` 999 for status dots only. Cards are not all rounded to the same value. Hierarchy decides.
- **Elevation:** 3 levels, flat borders by default. Shadow appears only on hover, and in light mode only. Dark mode uses a lighter border, not glow.
- **Icon sizes:** 16 / 20 / 24 / 32.
- **Breakpoints:** see G.
- **Content widths:** reading 640, content 1120, wide 1320, gutter fluid 20 → 64.
- **Component states:** default, hover, focus-visible (2px `signal` ring with 2px offset), pressed (scale 0.98), disabled (40% opacity).
- **Motion tokens:** see H.

### D.7 Principles
1. Show real shipped work first.
2. One memorable moment (the hero device). Everything else is quiet.
3. Structure encodes meaning: numbering only for the timeline, borders only for grouping.
4. Every animation either answers an action or reveals content once.
5. No claim on the page that cannot be verified.

---

## E. Proposed Information Architecture

| # | Section | Purpose | Notes |
|---|---|---|---|
| 1 | **Hero** | Who, what, and proof at once | Name, role, one-line positioning, real device, availability indicator, two CTAs (work, email) |
| 2 | **Selected work** | Show what I have built | 3–4 featured projects (candidates: Shell Agami, Shell Consumer, Shamadhan Pay, Agave). You choose (D6). |
| 3 | **Experience** | Where and how I've progressed | Polygon III → II → I as one progression, then earlier roles. Leadership roles (robotics club) condensed. |
| 4 | **About and skills** | Who I am; what I work with | Short real text (you supply or approve). Skills grouped by what I actually use. |
| 5 | **More apps** | Breadth of shipped apps | Compact list of the personal Play Store apps with a category filter. |
| 6 | **Writing** | Credibility through writing | Shown only if the Medium feed returns posts; otherwise hidden. |
| 7 | **Education** | Background | A compact block inside About (the data is already in the repository but is not rendered today; confirm in D3). |
| 8 | **Contact** | Convert | Email primary, copy-address button, LinkedIn, GitHub, X, Calendly, resume download. |
| 9 | **Footer** | Close | Copyright, source link, back to top. |

**Removed or merged:**
- *Services* (D5).
- *Resume as its own section* becomes a button in the hero (secondary), in About and in Contact.
- *Open Source and GitHub activity* have no data today. I will not invent any. A single GitHub link appears in the footer and contact, and a real section is added only if you supply repos (D3).
- *Certifications*: no data exists.

---

## F. Component Refactoring Matrix

| Component | Action | Path (actual / proposed) |
|---|---|---|
| `ResponsiveScope`, `ResponsiveInfo`, `context.responsive` | **Keep**; change breakpoints | `lib/core/responsive/responsive_framework.dart` |
| Repeated `r.isMobile ? …` ternaries | **Replace** with fluid tokens | all widgets |
| `AppTheme` | **Refactor**: new palette, fix deprecations, `ThemeExtension` for tokens | `lib/core/theme/app_theme.dart` |
| `AppTypography` | **Replace** with fluid scale | `lib/core/design/app_type.dart` (new) |
| Design tokens (spacing, radius, motion, colors) | **Introduce** | `lib/core/design/{tokens,motion,colors}.dart` |
| `ThemeCubit` | **Improve**: system default, no flash | `lib/core/theme/theme_cubit.dart` |
| `ScrollCubit` + `ScrollablePositionedList` | **Replace** with `CustomScrollView`/`SingleChildScrollView` + `ScrollController` + section keys (gives progress, reveal and active-section from one controller). Public API `scrollToSection(NavigationSection)` kept. | `lib/core/navigation/scroll_controller.dart` |
| `NavigationSection` enum | **Improve**: real labels, new order, `Services` and `Resume` removed | same file |
| `SidebarNavigation` | **Replace** with `TopBar` + `MobileMenu` | `lib/features/portfolio/presentation/widgets/top_bar.dart`, `mobile_menu.dart` (new) |
| `SectionWrapper`, `SectionHeader` | **Refactor** to the new rhythm and content widths | `lib/core/widgets/common/` |
| `Reveal`, `Stagger`, `HoverLift`, `PressScale`, `FocusRing` | **Introduce** | `lib/core/motion/` (new) |
| `HeroSection` | **Replace** | `hero_section.dart`, `device_frame.dart` (new) |
| `AboutSection` | **Improve** (recently redesigned; retain photo and CTAs, restyle) | `about_section.dart` |
| `ExperienceSection` | **Refactor** to a progression timeline | `experience_section.dart` |
| `PortfolioSection` + `DynamicScreenshotBanner` | **Replace** with `FeaturedProjects` + `MoreApps` | `featured_projects.dart`, `more_apps.dart` (new); retire `dynamic_screenshot_banner.dart` |
| `TechStackSection` | **Refactor** (grouped by use, no icons8 hotlinks) | `tech_stack_section.dart` |
| `ServicesSection` | **Replace** (remove, or fold into About) | `services_section.dart` |
| `BlogSection`, `MediumService` | **Improve**: remove the mock fallback; hide when empty | same files |
| `ContactSection` | **Refactor** | `contact_section.dart` |
| `ResumeSection` | **Replace** with `Footer` | `footer.dart` (new) |
| `ResponsiveImage`, `BaseResponsiveImage` | **Refactor** → thin wrapper over `Image.asset`/`Image.network` with `errorBuilder`, `cacheWidth`, fade-in | `lib/core/widgets/common/` |
| `PortfolioRepository` / `ProfileModel` | **Improve**: synchronous const data, split into `content/*.dart`; remove placeholder entries | `lib/features/portfolio/data/` |
| `PortfolioBloc` | **Improve**: remove the fake submit and the loading state for static data | `portfolio_bloc.dart` |
| Links | **Introduce** single `AppLinks` | `lib/core/constants/app_links.dart` (new) |
| Tests | **Introduce** | `test/` |

---

## G. Responsive Design Specification

**Breakpoints** (keeping the existing five-value `DeviceType` API so nothing else must change):

| Type | Width | Audit width | Layout |
|---|---|---|---|
| `mobile` | < 600 | 320, 390 | 1 column. Top bar collapses to logo + menu button + theme toggle. Hero stacks: text first, then a smaller device. 20px gutter. |
| `tablet` | 600–1023 | 768 | 1 column, wider reading width. Featured projects stay stacked. "More apps" in 2 columns. Hero side by side if width ≥ 720. |
| `smallLaptop` | 1024–1439 | 1280 | Full top-bar links. Hero 2 columns. Featured rows alternate. 3-column skills. |
| `desktop` | 1440–1919 | 1440 | Content max 1120, display type at the top of the scale. |
| `largeDesktop` | ≥ 1920 | 1920 | Content max 1320, centred, no stretching. Gutter grows. |

(Current thresholds are 1366 and 1680. At 1280 the layout is already "laptop", so moving to 1440 and 1920 aligns the tokens with the six audit widths.)

Rules:
- `MediaQuery.sizeOf` for window-level decisions, and `LayoutBuilder` for component-level decisions. No hardware or orientation checks (per `flutter-build-responsive-layout`).
- Lists of cards use `SliverGridDelegateWithMaxCrossAxisExtent` so columns follow the available width.
- Text and spacing come from fluid tokens, not per-breakpoint ternaries.
- Touch targets ≥ 44×44 on touch layouts, ≥ 32 on pointer layouts.
- 320px: no horizontal overflow; the device frame scales down, and headings wrap.
- Text scaling 200%: sections must reflow and not clip.

Current audit state at each width (derived from code, not yet inspected in a browser):
- **1920:** content capped at 1400 plus sidebar 350, so a large dead area on the right.
- **1440:** `desktop` uses a 300px sidebar. The hero image (400px plus its orbit) plus text is crowded.
- **1280:** `smallLaptop` has a 250px sidebar and 1024 content max.
- **768:** drawer plus overlay buttons that can collide with the section content at the top.
- **390 / 320:** the hero uses `IntrinsicHeight` plus `SingleChildScrollView` inside a list item; fixed chip padding may overflow at 320.

I will confirm each of these in the browser at the start of Stage B (phase 0) so the baseline screenshots are real.

---

## H. Animation and Interaction Specification

### H.1 Motion tokens (`lib/core/design/motion.dart`)

| Token | Value |
|---|---|
| `instant` | 120 ms |
| `hover` | 180 ms |
| `press` | 90 ms |
| `entrance` | 560 ms |
| `exit` | 240 ms |
| `stagger` | 70 ms (cap at 6 items) |
| `loaderMin` | none (no artificial delay) |
| `easeOut` | `Cubic(0.22, 1, 0.36, 1)` (entrances, hover) |
| `easeInOut` | `Cubic(0.65, 0, 0.35, 1)` (section scroll, theme change) |
| `revealThreshold` | element is revealed when 12% visible, once only |
| `entranceOffset` | 24 px (never more) |
| Reduced motion | every duration → 0, translate → none, loops → stopped; opacity changes become instant. Content is always visible. |

### H.2 Loader
- **Where it lives.** An inline HTML/CSS/SVG loader in `web/index.html`, so it shows before Flutter boots.
- **What it shows.** The "MD" initials drawn with a stroke-dash animation (about 900ms), and a thin progress line under them. No spinner.
- **How progress works.** The line eases toward about 85% on a fixed curve, because Flutter does not expose true download progress. It completes on a `portfolio-ready` event.
- **When it finishes.** The event fires when fonts are bundled and loaded, the hero image is `precacheImage`d, and the first frame is painted. This avoids content flash and layout shift.
- **Exit.** Fade and slight upward translate over 240 ms, with no minimum display time.
- **Reduced motion.** The initials appear static; the line still advances.
- **Colours.** Loader colours follow `prefers-color-scheme` so there is no dark flash for light users.

### H.3 Hero (the one orchestrated moment)
- Sequence on load: name lines clip-reveal upward (each line masked, 560 ms, stagger 70 ms), then the role line, then CTAs, then the availability dot.
- Device frame rises 24px into place with a fade. Screenshots inside cross-fade every 4.5 s. They pause on hover or focus, and when reduced motion is on.
- The "live" dot pulses once on appear, not forever.
- Background: no animated decoration. At most a static hairline grid at 4% opacity.
- All seven infinite animations in the current hero are removed.

### H.4 Scroll reveals (varied, once-only)
`Reveal` is driven by the single page `ScrollController`.

| Content | Effect |
|---|---|
| Section headings | Clip reveal (text slides up inside a mask) |
| Featured project image | Progressive reveal: clip from the left over 560 ms, with a 1.04 → 1.0 scale settle |
| Featured project text | Fade and 24px rise, staggered |
| Experience timeline | The vertical line draws down as you scroll; each role fades in when the line reaches it |
| Skills | Group-by-group fade, 70 ms stagger |
| More apps | Simple fade, no movement (the list is long) |
| Contact | Fade only, with the email address entering last |

Nothing replays. Nothing hides content from keyboard or screen-reader users.

### H.5 Hover, press and focus

| Element | Hover | Focus / touch equivalent |
|---|---|---|
| Top-bar link | 2px underline grows from the left (hover duration); colour to `ink` | Focus-visible ring. Active section: underline stays, `signal` colour, and the indicator slides between items (240 ms). |
| Primary button | Background shifts toward `ink`; the arrow icon moves 4px right | Focus ring; press scale 0.98; touch uses the press state |
| Secondary button | Border to `signal`; fill wipes in from the left | Same |
| Featured project | Image scales 1.0 → 1.03, border colour to `signal`, title arrow slides in | Whole card is a focusable link; focus shows the same state; on touch the press state applies |
| More-apps row | Row background tint; open-link icon appears | Same as above |
| Skill chip | 1px lift, border to `signal` | Focus ring |
| Social icon | 2px lift and colour change | Focus ring and tooltip |
| Theme toggle | Icon rotates 180° (instant duration); the whole theme cross-fades in 240 ms | Focus ring; `Semantics` label "Switch to light/dark theme" |

### H.6 Navigation and scroll
- The top bar is sticky, with a 2px progress hairline bound to scroll position.
- The active section comes from section keys (the section crossing the 35%-from-top line).
- Section navigation animates 520 ms with `easeInOut`. It is cancellable by a user scroll, and scroll is never hijacked.
- Parallax: a single 8% parallax on the hero device only, off under reduced motion.
- Theme switch: 240 ms colour interpolation via `AnimatedTheme`.

### H.7 Implementation approach
- Keep `flutter_animate` only if it still earns its place; the hero sequence and reveals are small and can be done with `AnimationController` and `TweenAnimationBuilder`. Decision at the phase 11 start, after measuring (the package adds little weight, so default is keep for simple one-shots, remove for anything scroll-driven).
- `Reveal`: a `StatefulWidget` with one `AnimationController`. It subscribes through an `InheritedNotifier` over `ScrollController`, checks its `RenderBox` position in a post-frame callback, plays once, then unsubscribes. The controller is disposed in `dispose`, and the listener is removed.
- Use `RepaintBoundary` around the device frame and the animated images. Animated transforms use `Transform`/`Opacity` only, not layout-changing properties.
- Add `visibility_detector` only if the custom `Reveal` proves unreliable; the default plan has no new dependency.

---

## I. Skill Utilization Matrix

The task said "25 Flutter-related skills in `.claude/skills/`, matching copies in `.agents/skills/`". **Findings:**
- `.claude/skills/` holds 26 directories: 15 `dart-*`, 10 `flutter-*`, and `frontend-design`.
- `.agents/skills/` does not exist in this repository, so there is no duplication to avoid.
- `skills-lock.json` (untracked) records the sources and hashes.
- Each skill directory contains only a `SKILL.md`, and none ships executable scripts. I did not execute anything from these skills.

| Skill | Directory | Purpose | Phase | How it will be applied |
|---|---|---|---|---|
| `frontend-design` | `.claude/skills/frontend-design` | Distinctive design, anti-template checks | Design, hero, typography, all visual phases | Used as the primary design reference. Palette, type and layout in D were checked against its default-trait list. It also constrains motion (one orchestrated moment, no blanket fade-slide), which I applied in H. |
| `flutter-build-responsive-layout` | `.claude/skills/flutter-build-responsive-layout` | `LayoutBuilder`/`MediaQuery.sizeOf`, constrained widths, grids | Phases 3–13 | `LayoutBuilder` per component, `MaxCrossAxisExtent` grids, max-width constraints on large screens, no orientation/hardware checks. |
| `flutter-fix-layout-issues` | `.claude/skills/flutter-fix-layout-issues` | Diagnose overflow/unbounded constraint errors | QA (phases 13, 16) | Run in debug, read the exception, fix by error type, repeat at 320/390/768. |
| `flutter-apply-architecture-best-practices` | `.claude/skills/flutter-apply-architecture-best-practices` | UI / data layers | Phases 1, 3 | Applied lightly. The project already separates UI from data. I keep the BLoC layer and do not migrate to `ChangeNotifier`/`freezed`; the skill's layering (services → repositories → state → views) is respected. |
| `dart-run-static-analysis` | `.claude/skills/dart-run-static-analysis` | `dart analyze`, `dart fix --apply` | Start and end of every phase | Fix the 11 current findings, then keep the count at 0. Strict-casts are evaluated, not forced. |
| `flutter-add-widget-test` | `.claude/skills/flutter-add-widget-test` | `WidgetTester` tests | Phase 16 | Tests for nav, theme toggle, reveal-once, link buttons, empty blog state. |
| `flutter-add-integration-test` | `.claude/skills/flutter-add-integration-test` | `integration_test` | Phase 16 (optional) | Adds a driver dependency and `lib/main_test.dart`. Only if you want it (D7). Browser QA covers the same ground. |
| `flutter-setup-declarative-routing` | `.claude/skills/flutter-setup-declarative-routing` | `go_router`, URL strategy | **Not used** | One page, no per-route content. Clean URLs for sections can be done with the usePathUrlStrategy alone. Decision D8. |
| `flutter-use-http-package` | `.claude/skills/flutter-use-http-package` | `http` requests | Phase 9 | **Flagged High by Snyk.** I read it. It is a generic REST how-to and ships no scripts. It is not needed: `http` is already used in `MediumService`, and I only tidy timeouts and error handling there. |
| `dart-setup-ffi-assets` | `.claude/skills/dart-setup-ffi-assets` | Native C/C++ build hooks, precompiled binary downloads | **Not used** | **Flagged Critical by Snyk.** Irrelevant to a web portfolio (native assets). Its content covers downloading binaries, which is what makes it risky. Recommendation: delete it from `.claude/skills/`. |
| `dart-use-pattern-matching`, `dart-use-primary-constructors`, `dart-write-documentation` | `.claude/skills/…` | Dart idioms and docs | Opportunistic | Used where I touch code, for `switch` expressions in token lookups. Not a goal in itself. |
| `flutter-add-widget-preview`, `flutter-implement-json-serialization`, `flutter-setup-localization` | `.claude/skills/…` | Preview, JSON, l10n | Not used | No JSON models are parsed (data is static), single language. |
| Other `dart-*` (CLI, coverage, ffigen, mocks, checks, doc examples, path, resolve conflicts, fix runtime errors) | `.claude/skills/…` | Misc | Contingent | `dart-resolve-package-conflicts` if a `pub get` conflict appears; `dart-fix-runtime-errors` if a runtime exception appears during QA. Others not applicable. |

I read `frontend-design`, `flutter-build-responsive-layout` and `flutter-use-http-package` in full or in substantial part. I read the structure and rules of the architecture, layout-fix, widget-test, static-analysis, integration-test and routing skills. I grepped the `dart-setup-ffi-assets` skill for download and execution behavior. The remaining skills I judged from their descriptions and will read before use.

---

## J. Performance and SEO Plan

### Performance
| Issue | Fix |
|---|---|
| Runtime Google Fonts fetch | Bundle two variable fonts (about 150 KB combined, subset to Latin). Remove runtime fetching. |
| Hotlinked full-size images (`w2560-h1440`) | Local WebP at display size plus 2x, `cacheWidth`/`cacheHeight`, `loading` fade. Screenshots lazy-built only when near the viewport. |
| Hundreds of `SelectableText` regions | Use `Text`. |
| `IntrinsicHeight`, nested `LayoutBuilder` inside list items | Remove. |
| 7 infinite hero animations | Remove. Device screenshot cross-fade only; paused off-screen. |
| `ScrollablePositionedList` (sections rebuilt and disposed, animations replay) | Single scroll view, with `RepaintBoundary` per section. |
| Full-page `BlocBuilder` rebuilds | Narrow `buildWhen`/`BlocSelector`; with static data there is no rebuild at all. |
| Bundle size | Measure `main.dart.js` before and after. Evaluate removing `html`, `carousel_slider`, `any_image_view`, `font_awesome_flutter` (use a few SVG/icon glyphs), and `google_fonts`. Evaluate `--wasm` build with fallback and compare. Do not adopt it if it breaks the loader or the fonts. |
| Toolchain drift | Pin one Flutter version in `.fvmrc` and CI. |

### SEO and metadata (`web/`)
- `<title>`: "Md. Asad Chowdhury Dipu: Flutter engineer".
- Meta description, `canonical` (`https://masadcd.online/`), `theme-color` for both schemes, `color-scheme`.
- Open Graph and Twitter Card tags, plus a 1200×630 `og-image.png`. You approve the image (D9).
- JSON-LD `Person` (name, job title, employer, `sameAs` links; only facts you confirm).
- `robots.txt`, `sitemap.xml`.
- `manifest.json`: real name and description, `orientation: any`, matching theme colours.
- Favicon set (existing `favicon.png` kept; add SVG and `apple-touch-icon` if you want a new mark).
- `<noscript>` and a visually-hidden text summary in `index.html` for crawlers and no-JS visitors.
- Accessibility metadata: `Semantics` labels on all icon buttons, links and the theme toggle. I will test whether enabling the Flutter web semantics tree by default is worth its cost, and measure it.
- Flutter Web ships a canvas; real SEO is limited. I am not adding hacks beyond the above.

---

## K. Implementation Roadmap

Each phase ends with `flutter analyze` (zero new issues) and a browser check. Progress is recorded in section N.

**Phase 0 (baseline).** Run the app and capture screenshots at 1920, 1440, 1280, 768, 390 and 320. Record the console. Record `flutter build web --release` size.

| # | Phase | Objectives | Tasks | Files | Depends on | Acceptance |
|---|---|---|---|---|---|---|
| 1 | Foundation and tokens | One source of truth for design values | Create `core/design/{colors,tokens,motion,app_type}.dart`; `AppLinks`; fix the 11 analyzer issues | `lib/core/design/*`, `lib/core/constants/app_links.dart`, `app_theme.dart`, `base_responsive_image.dart`, `contact_section.dart`, `portfolio_bloc.dart` | Phase 0 | Analyzer clean; no feature visually changed |
| 2 | Theme and typography | New palette and fonts | Bundle fonts; new `ThemeData`; `ThemeExtension`; `ThemeMode.system` default; fix theme flash | `app_theme.dart`, `theme_cubit.dart`, `main.dart`, `pubspec.yaml`, `assets/fonts/*` | 1 | Both themes render; contrast ≥ 4.5:1 for text; no font network request |
| 3 | Responsive architecture | Fluid layout primitives | New breakpoints; `ContentFrame` (max width, gutters); `Section` wrapper; remove ternaries in shared code | `responsive_framework.dart`, `section_wrapper.dart`, `section_header.dart` | 1 | No overflow at 320/390/768 on a test page |
| 4 | Navigation and page structure | Top bar; new scroll model; new section order | `TopBar`, `MobileMenu`, scroll progress, active section by keys; remove sidebar and drawer | `portfolio_page.dart`, `scroll_controller.dart`, `top_bar.dart`, `mobile_menu.dart` | 2, 3 | All nav items scroll to the right section; active state correct; keyboard reachable |
| 5 | Hero | Device-forward hero | `DeviceFrame`; screenshot cross-fade; hero text sequence; synchronous profile | `hero_section.dart`, `device_frame.dart`, `portfolio_repository.dart`, `portfolio_bloc.dart` | 4, assets | Readable at all widths; no infinite animations; pauses on hover |
| 6 | About and skills | Truthful, concise | Restyle About (keep photo and CTAs), grouped skills, real labels | `about_section.dart`, `tech_stack_section.dart`, `profile_model.dart` | 2, 3, your content | Claims reviewed by you; no icons8 hotlinks |
| 7 | Experience and education | Progression timeline | Group roles per company; drawing line; local logos; education block | `experience_section.dart` | 6 | Logos load locally; timeline reads correctly at 320 |
| 8 | Projects | Featured plus more apps | `FeaturedProjects`, `MoreApps`, category filter, real assets only, link validation | `featured_projects.dart`, `more_apps.dart`, `portfolio_repository.dart`, `assets/images/projects/*` | 5, 7, your assets/links | No stock photos; every link resolves; empty-asset cards honest |
| 9 | Writing / open source | Honest | Remove mock posts; hide when empty; Medium timeout; GitHub link only | `blog_section.dart`, `medium_service.dart` | 3 | Blog hidden or live, never fake |
| 10 | Contact and footer | Convert | Email-first contact, copy button, resume download, new footer | `contact_section.dart`, `footer.dart`, `web/resume.pdf` | your decisions | Email, resume and all social links work |
| 11 | Loader and animation system | Branded loader and the motion toolkit | Inline SVG loader, `portfolio-ready` event, `precacheImage`, `Reveal`/`Stagger`/`HoverLift`/`PressScale`, reduced-motion | `web/index.html`, `lib/core/motion/*`, `main.dart` | 5 | No flash; loader disappears when ready; reduced motion verified |
| 12 | Scroll and hover interactions | Apply the toolkit | Reveals per H.4; hover/focus per H.5; hero parallax | all section files | 11 | Reveals fire once; no jank; keyboard focus matches hover |
| 13 | Responsive refinement | Fix what the browser shows | Walk all six widths; apply `flutter-fix-layout-issues`; 200% text scale | all | 12 | Zero overflow errors; screenshots reviewed |
| 14 | Accessibility and SEO | Meta and a11y | Meta/OG/JSON-LD, robots, sitemap, manifest; semantics labels; focus order; contrast pass | `web/*`, widgets | 13 | Lighthouse a11y and SEO ≥ 95; share preview verified |
| 15 | Performance | Measure and trim | Bundle diff; image sizes; dependency pruning; renderer evaluation; align CI | `pubspec.yaml`, `deploy.yml` | 14 | Release build no larger than baseline (target: smaller); Lighthouse performance reported honestly |
| 16 | Final testing and QA | Prove it | Widget tests; analyzer; release build; full link audit; final screenshots; update this document | `test/*` | 15 | See section L |

---

## L. Testing Plan

- **Responsive:** full-page screenshots at 1920, 1440, 1280, 768, 390 and 320 (light and dark). Verify no overflow, no clipped text, and that the device frame and top bar behave. Text scaled to 200% at 390.
- **Browser inspection:** Chrome via the browser tool. Check the console for errors, the network tab for failed requests (images, fonts), and that no third-party font request occurs.
- **Flutter analysis:** `flutter analyze` must end with 0 issues. Report any I cannot fix.
- **Functional:**
  - every nav item, in the top bar and mobile menu;
  - every external link (HTTP status check where possible);
  - `mailto:` and the copy-email button;
  - resume download;
  - category filter;
  - theme toggle and persistence across reload;
  - the blog empty state.
- **Widget tests** (`flutter test`): top-bar active state; theme toggle; `Reveal` plays once; reduced motion shows content immediately; link buttons call the launcher (mocked).
- **Accessibility:** Tab order through the whole page; visible focus; `prefers-reduced-motion` emulated; Lighthouse accessibility; contrast measured on both themes.
- **Performance:** `flutter build web --release` size before and after; Lighthouse runs on the deployed-equivalent local build. Results reported as measured, with the run conditions.
- **Animation lifecycle:** navigate and scroll repeatedly; confirm that controllers are disposed (no listener leaks, no exceptions in the console), and that no animation replays.

---

## M. Decisions and inputs needed from you

**Decisions**
- **D1.** Is the subject statement in D.1 right? ("Flutter engineer at Polygon; consumer and payments apps in Bangladesh; robotics/IoT background.")
- **D2.** Theme default: follow the system setting (recommended), or keep dark?
- **D3.** Content truth check. Which of these stay?
  - "100+ UI screens", "10+ production apps", "Open Source Contributor"
  - "3+ years" (your first role is dated May 2020)
  - React Native, TypeScript, GraphQL in skills
  - whether to add BLoC, GetX, Django, Supabase and Firebase
  - any open-source repos worth featuring
  - Education: show it?
- **D4.** Contact: email-first with no form (recommended), or a real form through a service such as Formspree? A service means a third-party account and an endpoint.
- **D5.** Services section: remove (recommended) or keep?
- **D6.** Which 3–4 projects are featured?
- **D7.** Add `integration_test` (needs a `lib/main_test.dart` and dev dependencies), or rely on browser QA?
- **D8.** Clean URLs and per-section deep links (`/#work`) via `usePathUrlStrategy`, or leave as is?
- **D9.** The 1200×630 share image: I draft it from the hero design, you approve?
- **D10.** Fonts: Bricolage Grotesque + Newsreader (proposed), or other preferences?
- **D11.** Navigation: top bar (recommended) or keep a sidebar?

**Inputs only you can provide**
- Resume PDF.
- A proper portrait (the current avatar is a Google thumbnail; the sidebar loads `github.com/dipu0.png`).
- Real screenshots for apps that currently use stock photos (Shamadhan merchant portal, Agave, TripMeter, Greeneries, My 2nd Home, Todo, portfolio itself). Otherwise those get no image.
- Canonical social handles and valid repo URLs.
- Company logos you are comfortable bundling.
- Confirmation of the Play Store assets' usage (they are your own apps and client apps).

**Housekeeping flagged during Stage A**
- Running `flutter analyze` auto-ran `pub get` and briefly modified `pubspec.lock`, `.flutter-plugins-dependencies` and `analysis_options.yaml`. My revert attempt was blocked by the permission system. A later `git status` shows those files clean again, so no application config differs from `HEAD`. Only `docs/` (this file) is new, plus IDE cache files under `.idea/`, which I did not touch.
- Recommend deleting `dart-setup-ffi-assets` (and optionally `flutter-use-http-package`) from `.claude/skills/`.

---

## N. Implementation Progress (updated during Stage B)

Approval: you said to continue and to add only the best GitHub projects (`macdipu`). I read that as approval with the recommended defaults.

**Defaults taken for open decisions:** D2 follow system theme; D3 only verifiable claims kept; D4 email-first, no form; D5 Services removed; D6 featured = OpenReader, universal_document_viewer, GitSwitch, SpeedLoop; D10 Bricolage Grotesque + Newsreader; D11 top bar. D7 integration test, D8 deep links and D9 share image are **not done**.

| Phase | Status | Notes |
|---|---|---|
| 1 Tokens | Done | `lib/core/design/tokens.dart` (spacing, radii, motion, colours, fluid type). Analyzer: 11 issues to 0. |
| 2 Theme and type | Done | Fonts bundled in `assets/fonts` (no runtime Google Fonts). System theme default; no theme flash. |
| 3 Responsive | Done | Breakpoints 600/1024/1440/1920; fluid tokens replace the ternaries. |
| 4 Nav and structure | Done | Sticky top bar, scroll progress, active section, full-screen mobile menu. `ScrollablePositionedList` replaced by one `ScrollController`. |
| 5 Hero | Done | Device frame cycling real screenshots; staggered mask reveal; no infinite loops. |
| 6 About and skills | Done | Truthful copy, skills grouped by real usage. |
| 7 Experience | Done | Per-employer progression. Deviation: no drawing line; plain fade reveals. Company logos dropped (hotlinks expired). |
| 8 Projects | Done | 4 featured (real assets) + 2 more open source + shipped apps. Stock photos removed. |
| 9 Writing | Done | Live Medium posts, hidden when empty, mock fallback removed. |
| 10 Contact/footer | Done | Email-first, copy button, Calendly, footer. **Resume not added: no PDF supplied.** |
| 11 Loader/animation | Done | Inline SVG loader finished by a real `portfolio-ready` event (about 0.6s warm, about 3s cold). `Reveal` and `Pressable`. Reduced motion honoured. |
| 12 Interactions | Done | Hover/focus/press per H.5 for nav, buttons, links, rows. Deviation: no hero parallax. |
| 13 Responsive QA | Done | Screenshots at 1920, 1440, 768, 390, 320 (light and dark, reduced motion at 320). No overflow found. Not run at 1280 or at 200% text scale. |
| 14 A11y/SEO | Partly | Meta/OG/Twitter, JSON-LD, robots, sitemap, manifest, noscript done. Share image is still the 512px icon. No Lighthouse run. |
| 15 Performance | Partly | Removed 7 dependencies; CI pinned to 3.41.6 and `assets/**` added. `main.dart.js` 2.1 MB. No before/after baseline captured; `--wasm` not evaluated. |
| 16 Final QA | Done | `flutter analyze`: 0 issues. `flutter test`: 5 passed. `flutter build web --release`: OK. Link audit below. |

**Link audit:** all GitHub, pub.dev, site and Play links return 200 except: Medium 403 and LinkedIn 999 (bot blocking; Medium feed loads in the browser), `x.com/dipu093` 404 to curl (unverified), and 3 Play links (CGPA, Money Track, Weight Tracker) that 404, so those apps were removed from the page.

---

## O. Round 2 (redesign pass after review)

Feedback: loader, "Selected work" name, mobile-only hero, flat UI, and the project list.

| Change | Detail |
|---|---|
| Loader | `web/index.html`. **MACDIPU** holds, then each letter opens in place into **MD. ASAD CHOWDHURY DIPU** (M+d., A+sad, C+howdhury, DIPU). Wraps on narrow screens. Waits for the real `portfolio-ready` signal and for the animation (about 2.1 s minimum). Reduced motion shows the full name at once. |
| Naming | "Selected work" is now **Projects**. |
| Projects | Showcase = OpenReader, universal_document_viewer, GitSwitch, JamSync, SpeedLoop, FCM Tools. More: Flutter Clean Architecture (GetX), Agentic Development Kit. Each carries platform badges (Mobile, Desktop, Web, Full stack, Package, CLI). `flexword` was not found on GitHub (404), so it is **not included**. |
| Hero | 3D device cluster: desktop window, browser window and phone, in perspective. Leans toward the pointer and tips back and recedes on scroll. Platform badges show Mobile, Desktop, Web and Full stack. |
| Scroll effects | Pinned 3D project carousel (devices rotate through depth, each project holds still then rotates, counter and jump rail). Scroll-driven marquee. Experience timeline whose connector lines draw as you read (this was deferred earlier). |
| Visual direction | Dark "stage" default (Flutter-sky `#2BB7FF` on navy `#0A1330`), light "studio" theme via the toggle. Names the hero as the one bold moment. |
| Code | New `core/motion` (`Reveal`, `Pressable`, `ScrollScope`/`ScrollLinked`, `PointerTilt`), `core/widgets/devices.dart`, content model in `content/portfolio_content.dart` (add a `Project` to add a project). |
| Share image | `web/og-image.png` (1200x630) generated from the real hero assets. |
| CI | Flutter pinned to **latest stable** (`channel: stable`, no version), `.fvmrc` = `stable`. |

Still open: resume PDF (not supplied), `flexword` repo, Lighthouse run, 200% text scale, `--wasm` evaluation, deep links.

## P. Round 3 (restructure from research, cinematic loader)

**Research.** Guides on developer portfolios agree on: a few strong projects over many; each with your role, context and a live or store link; no skill bars or filler; contact and resume easy to find; reviewers decide in seconds. Sources: scrimba.com/articles/how-to-build-a-web-developer-portfolio-that-gets-you-hired, devplaybook.cc/blog/developer-portfolio-checklist-20-things-hiring-managers, eportfolio-c0z.pages.dev (portfolio mistakes), dev.to community posts. Several quoted statistics (for example "30 seconds") have no primary study behind them, so they were treated as rough.

**What that means for this content.** The strongest facts are the Polygon promotions (I to II to III), shipped client apps, apps live on Google Play since 2020, and two real open-source tools. The weak spot is no outcomes or numbers, so none are invented.

| Decision | Detail |
|---|---|
| Structure | Hero, proof strip (3 checkable facts), Projects, Experience, About (skills, education), Writing (live Medium posts), Contact. |
| Projects | Only projects with real preview graphics, each with role and links: Shell Agami and Shell Consumer, OpenReader, GitSwitch, BMI & BMR Calculator, QrXpert. Graphics are local assets (`assets/images/projects`). |
| Removed | universal_document_viewer, JamSync, SpeedLoop, FCM Tools, "More repositories" and the shipped-apps rows, the marquee (decoration), the spec panels. |
| Moved | Shamadhan Pay and Agave (graphics no longer available) are now "Products shipped" under Polygon in Experience, as text. |
| Logo | MACDIPU replaces MD in the top bar and menu. |
| Loader | Canvas intro: hundreds of drifting letters curve into MACDIPU, hold, dissolve into glowing particles, expand and rebuild as MD. ASAD CHOWDHURY DIPU. About 7.7 s, skippable (button or Escape), a short version for repeat visits in the same session, static name with reduced motion. Waits for the real ready signal. |
| Robustness | Found by a test: the project text overflowed at 1440x900. Fixed with a scale-down fit box. Verified at 1366x650 and 320x568. |

Still open: resume PDF, `flexword` repo, Lighthouse, 200% text scale.

## Q. FlexWork added

Read from the private repo `macdipu/flexwork` (README and `landing/README.md`, in the logged-in browser). It is a mobile-first workforce marketplace for Bangladesh: Flutter worker app, Flutter employer app, Next.js admin panel and a Next.js landing page over 16 backend services (Spring Boot, Django, Node.js, FastAPI) behind a Spring Cloud Gateway, with PostgreSQL, Redis, MinIO and optional Kafka.

- First slide in Projects (the strongest full-stack evidence). Badges: Full stack, Mobile, Web.
- The repo has no screenshots and nothing is deployed publicly, so no UI is shown. The preview graphic is the real system architecture, drawn in Flutter from the README (`core/widgets/architecture_diagram.dart`).
- No link, because the repository is private; the slide says so. Demo credentials and other internal docs were not used.
- Add real screenshots later as `Shot`s on the project.

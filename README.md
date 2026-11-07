# MACDIPU

Portfolio of **Md. Asad Chowdhury Dipu**, Forward Deployed Engineer. Built with Flutter Web, live at **[masadcd.online](https://masadcd.online)**.

<p align="center">
  <img src="docs/recordings/loader-to-hero.gif" alt="The loading intro: floating letters form MACDIPU, dissolve into particles and rebuild as MD. ASAD CHOWDHURY DIPU, then the hero's screens stack up and settle into a 3D device cluster." width="720">
</p>

<p align="center">
  Loader to hero, about ten seconds.
  <a href="docs/recordings/loader-to-hero.webm">Watch it at full quality (WebM, 1280×720)</a>.
</p>

## What is on the page

| Section | What it does |
|---|---|
| **Loader** | A canvas intro. Hundreds of letters drift, swirl into **MACDIPU**, break into particles and rebuild as the full name. It waits for the app's real ready signal, can be skipped, and plays a short version on repeat visits. |
| **Hero** | The name, role, and a 3D cluster of real devices. Screens slam in one on top of another, then break away as the devices settle. The cluster leans toward the pointer and tips back as you scroll. |
| **Marquee** | A full-width yellow ticker with two rows of skills (engineering, and AI and agentic engineering). It glides when you scroll and coasts to a stop. |
| **Proof strip** | Three checkable facts, each repeated in full further down. |
| **Projects** | A scroll-pinned 3D showcase of eight projects, each with its real screens or architecture diagram, platform badges, role and links. |
| **More projects** | Smaller and older work as a plain list, ending with the GitHub profile. |
| **Experience** | A timeline whose connector lines draw as you read. |
| **About** | Short bio, skills and education. |
| **Writing** | Latest Medium posts, hidden if the feed fails. Nothing is faked. |
| **Contact** | Email first, with copy, book a call and social links. |

Dark is the default for a visitor with no saved choice, and a saved choice always wins. Light and dark are both designed, including the loader.

## Design system

- **Tokens** live in `lib/core/design/tokens.dart`: spacing, radii, motion durations and easing, semantic colours for both themes, and a fluid type scale whose sizes interpolate between a 320 px phone and a 1440 px desktop.
- **Type** is bundled, with no runtime font request: Bricolage Grotesque for display and UI, Newsreader for reading text (both SIL OFL, in `assets/fonts`).
- **Motion** is small and reusable, in `lib/core/motion`: `Reveal` (plays once on scroll), `Pressable` (hover, focus and press), `ScrollLinked` (scroll-driven effects), and `PointerTilt` (3D lean). Reduced motion is respected everywhere.
- **Accessibility:** visible keyboard focus, semantic labels on icon buttons and links, large touch targets on the icon buttons and the project rail, and no content that depends on animation.

## Run it

Requires the latest stable Flutter (`.fvmrc` and CI both track `stable`).

```bash
flutter pub get
flutter run -d chrome          # debug, with hot reload
flutter analyze                # should report no issues
flutter test                   # widget tests
flutter build web --release    # output in build/web
```

## Edit the content

All content is plain data, so you can change it without touching widgets.

| To change | Edit |
|---|---|
| Name, role, intro, about text, links | `lib/content/portfolio_content.dart` (`Profile`, `AppLinks`) |
| Showcase projects | `projects` in `lib/content/portfolio_content.dart` |
| Experience, skills, education | the same file |
| The "More projects" list | `lib/content/other_projects.dart` |
| Marquee words | `engineeringSkills` and `aiSkills` |

**Adding a showcase project:** append a `Project(...)` to `projects`. Give it real preview graphics, as screenshots in `assets/images/projects` (declared as `Shot`s). Projects with no public screens, such as private repositories, can use an architecture diagram (`ShotKind.diagram`, see `lib/core/widgets/architecture_diagram.dart`). The showcase never invents imagery.

## Project structure

```
lib/
├── main.dart
├── content/                       all copy and project data
├── core/
│   ├── design/tokens.dart         spacing, radii, motion, colours, type
│   ├── motion/                    Reveal, Pressable, ScrollScope, PointerTilt
│   ├── navigation/                section keys, active section, scroll progress
│   ├── responsive/                breakpoints and device type
│   ├── theme/                     ThemeData and the saved theme choice
│   ├── web/                       signals between the page loader and Flutter
│   └── widgets/                   device frames, logo, diagram, shared UI
└── features/portfolio/
    ├── data/                      Medium feed (models, service)
    └── presentation/              page, sections, top bar, blog cubit
web/index.html                     the canvas loader, SEO tags, manifest
assets/                            fonts and project screenshots
docs/                              refactoring plan and the recording above
```

## The loader

The intro is plain HTML, CSS and canvas in `web/index.html`, so it appears before Flutter has booted. Two events connect it to the app:

- `portfolio-ready`: Flutter fires it once fonts load and the hero images decode.
- `intro-done`: the loader fires it as it fades, and the hero's own entrance starts then, so it is seen and not played out behind the loader.

## Deployment

A push to `master` that touches `lib/`, `web/`, `assets/` or the workflow builds the site with the latest stable Flutter and publishes it to the `gh-pages` branch, served at `masadcd.online`. See `.github/workflows/deploy.yml`.

## License

This project is open source and available under the MIT License.

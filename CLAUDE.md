# Recital

A small Flutter app (iOS and Android): a public-domain poem a day with LibriVox
volunteers' readings of it, poems and poets to browse, and a player. It exists to show
Apple's iPhone Duo guidance applied in Flutter, for a post on biaksoy.dev, so the iPhone
Duo code is meant to be read: keep it plain and its comments pointed at the guidance.

## Where truth lives

- Apple's iPhone Duo guidance, what the simulator showed, and how Flutter 3.47.7 sees the
  device: `docs/reference/iphone-duo.md`. Separate what Apple states from what others
  infer, as it does.
- Decisions: one file each in `docs/decisions/`; DEC-3 is the iPhone Duo design. Work
  order: `backlog.yaml`, done tasks in `backlog-done.yaml`.
- Content: `assets/catalog.json`, every text, year and recording with its source (DEC-2).
  Never add content without a public-domain source; never invent a reader's name.

## Repository

```text
ios/Runner/ScreenGeometryPlugin.swift  the screen, hinge, fold and bar edge Flutter does not report
lib/core/duo/                          that report turned into layout (DEC-3)
lib/core/                              theme, router, tab shell
lib/features/<feature>/                catalog, today, poems, poets, player
scripts/duo/                           Device Hub pose control and the all-poses tour
```

## Commands

```sh
./scripts/bootstrap.sh     # toolchain check (fvm), flutter pub get, codegen
./scripts/codegen.sh       # gen-l10n and build_runner
./scripts/gate.sh          # analyze, format, records, tests; must pass before a commit
scripts/duo/tour.sh <udid> <folder>   # every screen in every iPhone Duo pose
```

Toolchain: Flutter 3.47.7 through fvm (`.fvmrc`), packages as `pubspec.lock` pins them
(DEC-1). Building for iOS needs Xcode 27.1.

## Gotchas

- Xcode 27.1 has no Simulator app: iPhone Duo's poses are buttons in Device Hub, and
  `simctl` cannot set them. `scripts/duo/duo_pose.swift` presses them through the
  accessibility API; it needs the Mac unlocked and the terminal allowed Accessibility.
- `simctl io <udid> screenshot --display=primary` is the outer display,
  `--display=primary-1` the inner one.
- Widget tests read the catalogue from disk: the bundle's real reads do not finish under
  a test's fake clock.

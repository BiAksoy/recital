---
id: DEC-1
date: 2026-10-22
title: Flutter 3.47.7 with Riverpod, auto_route and dart_mappable, kept to what a small demo uses
status: accepted
areas: [stack]
---

**Context.** Recital is a small public demo of designing a Flutter app for iPhone Duo. Its
code should read like a production app's, without packages it has no use for.

**Decision.** Flutter 3.47.7 through fvm (`.fvmrc`) with flutter_riverpod and
riverpod_generator, auto_route, dart_mappable, intl and very_good_analysis, and
riverpod_lint 3.1.9 as an analyzer plugin. Left out because nothing here needs them:
Firebase, logging, theme generation (the palette is one `ThemeExtension`), image caching
and shared_preferences. `scripts/gate.sh` runs analysis, formatting, the records check and
the tests.

**Consequences.** Adding persistence, logging or a backend means adding its package from
the stack's current releases.

---
id: DEC-3
date: 2026-10-22
title: The app follows Apple's iPhone Duo guidance, with what Flutter does not report brought over by a small plugin
status: accepted
areas: [platform, layout, player]
---

**Context.** The point of this app is to show Apple's iPhone Duo guidance applied in
Flutter. `docs/reference/iphone-duo.md` has the guidance with its sources and what Flutter
3.47.7 does and does not report: it gives the window's size and an asymmetric safe area,
but reads the screen once at start, never reports the hinge or the fold
(`MediaQuery.displayFeatures` stays empty on iOS), and draws its own bars, which the system
does not move to the side.

**Decision.**

- **`ios/Runner/ScreenGeometryPlugin.swift`** reports what Flutter does not: the scene's
  screen, the hinge (`UIHingeInteraction`), the fold and the camera and status-bar regions
  (`UIView.reservedRegions`), and the edge of the vertical bar
  (`UITraitCollection.verticalBarEdge`), as a physical side. It reads them in
  `layoutSubviews`, which UIKit runs again when they change. `lib/core/duo/` turns that
  into layout.
- **Bars in the side column**, closed and open on its side: each page's Back and icon
  actions at the column's top under the status bar (`PageScaffold`), the tabs bottom-aligned
  at its foot as symbols, each label its tooltip; text buttons stay in the title row, as the
  system keeps text items horizontal. The mini player stays under the page.
- **Size decides the layout, never the device**: in a window wider than tall with room for
  two panes, a poem sits beside its readings and the player beside the poem (`FoldSplit`,
  Apple's split arrangement); lists go two to a row (`TwoColumnSliverList`). The inner
  display held upright, and a phone, get one column. An iPad held wide gets two panes too.
- **The fold**: partially open, the fold goes into `MediaQuery.displayFeatures`
  (`ScreenLayoutScope`), so dialogs and sheets open beside it; dialogs are anchored where
  Apple puts alerts (the right half like a book, the upper half on a table) and sheets
  where it puts controls (the right half, the lower half). Two panes meet at the fold, and
  two-to-a-row lists keep the fold between their columns.
- **On a table** the player shows the poem above the fold, to be read from a distance, and
  the controls below it.
- **The app turns** with the device everywhere, as Apple suggests for a device people set
  down like a tent; the inner display would ignore a lock anyway.

**Consequences.** Building for iOS needs Xcode 27.1. `scripts/duo/tour.sh` screenshots
every screen in every pose through Device Hub. If Flutter starts reporting the fold
(flutter/flutter#193025), `ScreenLayoutScope` steps aside; if it reports the bar's edge and
the screen, the plugin can go.

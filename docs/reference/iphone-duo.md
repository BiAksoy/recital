# iPhone Duo

What Apple publishes about designing for iPhone Duo, what we measured on its simulator, and
how a Flutter app sees the device. Researched 2026-10-22 against Xcode 27.1 (27A9275), the
iOS 27.1 simulator runtime and Flutter 3.47.7. DEC-3 records what this app does with it.

Each statement is marked by where it comes from:

- **Apple**: Apple's Human Interface Guidelines, developer documentation, SDK headers,
  Tech Talks, or an Apple engineer answering in Apple's developer forums.
- **Measured**: seen on the iPhone Duo simulator (Xcode 27.1) while building this app.
- **Others**: third-party write-ups, packages and issue threads. Not relied on where Apple
  or a measurement says otherwise.

## Sources

Apple, read in full:

- HIG, [Designing for iPhone Duo](https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo),
  new page of 2026-09-09.
- [Preparing your app for iPhone Duo](https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo).
- [UIView.ReservedRegion](https://developer.apple.com/documentation/uikit/uiview/reservedregion)
  and [ReservedRegion](https://developer.apple.com/documentation/swiftui/reservedregion)
  (SwiftUI); [Device Hub](https://developer.apple.com/documentation/xcode/device-hub) and
  [Interacting with your app in Device Hub](https://developer.apple.com/documentation/xcode/interacting-with-your-app-in-device-hub).
- Tech Talks, transcripts: [Design for iPhone Duo](https://developer.apple.com/videos/play/tech-talks/111466/),
  [Prepare your app for iPhone Duo](https://developer.apple.com/videos/play/tech-talks/111461/),
  [Raise the bar with iPhone Duo](https://developer.apple.com/videos/play/tech-talks/111462/),
  [Strike a pose with adaptive layouts on iPhone Duo](https://developer.apple.com/videos/play/tech-talks/111463/),
  [Leverage multiple displays and scenes on iPhone Duo](https://developer.apple.com/videos/play/tech-talks/111464/),
  [Build a great camera experience for iPhone Duo](https://developer.apple.com/videos/play/tech-talks/111465/).
- The iOS 27.1 SDK headers `UIHinge.h`, `UIHingeInteraction.h`, `UIViewReservedRegion.h`,
  `UIVerticalBarEdge.h` and `UIView.h`.
- [Apple unveils iPhone Duo](https://www.apple.com/newsroom/2026/09/apple-unveils-iphone-duo/)
  (2026-09-09), the [tech specs](https://www.apple.com/iphone-duo/specs/) and the App Store
  Connect [screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications).
- [A Summary of the iPhone Duo Group Lab](https://developer.apple.com/forums/thread/847644),
  posted by an Apple DTS engineer: Apple staff, but a summary of a live Q&A, not reference
  documentation.

Others: flutter/flutter [#192515](https://github.com/flutter/flutter/issues/192515),
[#193025](https://github.com/flutter/flutter/pull/193025),
[#193202](https://github.com/flutter/flutter/issues/193202),
[#193878](https://github.com/flutter/flutter/issues/193878),
[#192667](https://github.com/flutter/flutter/issues/192667) and
[#194277](https://github.com/flutter/flutter/issues/194277); the pub packages
[`foldable`](https://pub.dev/packages/foldable) and
[`adaptive_platform_ui`](https://pub.dev/packages/adaptive_platform_ui); liquid_glass_widgets
[#404](https://github.com/sdegenaar/liquid_glass_widgets/issues/404); two DEV articles and
[mirzaaghazadeh/iphone-duo-skills](https://github.com/mirzaaghazadeh/iphone-duo-skills).

Not found or not opened: the iOS 27.1 release notes (404 at the expected address), an App
Review Guidelines change naming iPhone Duo, the TechRepublic article (listing only), and the
"Design for iPhone Duo" design resource some write-ups quote for safe-area sizes.

## The hardware

- **Apple**: two displays. The inner one is 7.6 inches, 1878 × 2670 px at 430 ppi, folding
  at a centre hinge; the outer one is 5.4 inches, 1398 × 2034 px at 460 ppi. Both ProMotion
  up to 120 Hz, both with a Dynamic Island. The outer front camera sits in a corner and is
  always visible; the inner one is under the display and hidden until it is in use. iOS 27.1;
  available 2026-10-23.
- **Apple**: "the outer display is wider and shorter than the display on other iPhone
  devices". People hold it closed, open, partially folded like a book, set down like a
  laptop, or standing on its edges.
- **Measured**: the simulator's outer display is 466 × 678 pt and its inner display
  669 × 951 pt, both at a device pixel ratio of 3. 669 × 951 pt at 3x is 2007 × 2853 px,
  the App Store's inner screenshot size, not the 1878 × 2670 px panel. **Others** infer the
  system draws at the larger size and scales down to the panel; Apple does not say.
- **Measured**: "Open" in Device Hub shows the inner display wide, 951 × 669 pt: a closed
  phone held upright opens like a book. Turned a quarter, it is 669 × 951 pt.

## Apple's design guidance

### Size classes, not poses or devices

- **Apple**: supporting the poses "doesn't mean designing a custom layout for each one".
  Design two: a compact-width layout for the outer display and a regular-width one for the
  inner display, and let the layout grow with the space. "Avoid fixed widths, breakpoints,
  or any metrics tied to a specific screen."
- **Apple**: outer display, portrait: compact width, regular height; landscape: compact
  both. Inner display: regular both.
- **Apple**: don't decide layout from `userInterfaceIdiom` or the interface orientation.
  "Avoid referencing the main screen in your code. It's ambiguous and will be deprecated";
  if a screen is needed, take it from the window scene.
- **Apple**: the outer display honours an app's supported orientations like any iPhone;
  "the inner display doesn't honor your supported interface orientations". The DTS summary
  says both "still honors UISupportedInterfaceOrientations" and "there is no sanctioned way
  to lock the inner display to portrait", so read it as: honoured outside, ignored inside.
  **Others** (flutter#194277) measured a portrait-only Flutter app laid out at 951 × 669 on
  the inner display, and letterboxed at 469 × 669 only with `UIRequiresFullScreen`.
- **Measured**: a lock at run time is another matter. A Flutter app that asked for
  portrait only (`SystemChrome.setPreferredOrientations`) when the device opened stayed
  portrait on the inner display, lying on its side across the wide screen, and on a table
  upside down; asking for every orientation afterwards did not turn it back, and iOS
  logged "The current windowing mode does not allow for programmatic changes to interface
  orientation". With no lock when it opened, the app filled the inner display wide, and
  closed it followed the device into landscape. Simulator only.

### Keep one app across the displays

- **Apple**: keep functionality and the state of elements the same between displays and
  across poses. Keep the information hierarchy; on the inner display, show "an additional
  level of hierarchy" where it makes sense, as Mail shows the list and the message side by
  side. "You don't want just a stretched out iPhone app."
- **Apple**: three ways to use the inner display's width: a split view, a layout that
  rearranges into two columns (Music), or a tab bar shown as a sidebar (Health, for
  information-dense apps).
- **Apple**: an optional layout for the device set down like a laptop: "media can sit at
  the top, while tappable controls live on a stable base at the bottom", with the same
  controls and hierarchy as every other pose.

### Bars on the side

- **Apple**: closed, and open in landscape, toolbars, tab bars and navigation controls move
  to the side, to keep vertical space for content and keep controls in reach. The inner
  display held upright keeps horizontal bars. The side column also holds the status bar and
  the Dynamic Island, which grows down it for Live Activities.
- **Apple**: the column stays aligned with the hardware: the same position relative to the
  outer camera, and the same side in right-to-left languages. In Split View on the inner
  display each app has its controls on its outer edge.
- **Apple**: order from the top: Back or Close, then prominent actions such as Done, then
  the rest in their groups. The tab bar stays bottom-aligned. Items overflow into the system
  menu from the bottom up; give them priorities. Vertical items are symbols; text-only items
  and custom views stay in a horizontal bar. When space runs out, a navigation-focused view
  keeps the tab bar and a task-focused one keeps the toolbar.
- **Apple**: content becomes asymmetric; take each safe-area side on its own. Full-width
  layouts suit "immersive, highly visual interfaces that don't scroll" (Calculator), as
  long as nothing reaches the status bar.
- **Apple** (DTS): custom bars do not move; "a custom bar must use `verticalBarEdge` plus
  reserved regions rather than assuming safe-area insets alone reserve that space".

### The fold and other reserved regions

- **Apple**: a reserved region is space the hardware or system takes: the outer camera
  (always), the inner camera (while active) and the fold (while partially open). An
  *occlusion* covers content; a *division* splits it. Frames include margins for
  interactive content.
- **Apple**: alerts, context menus and sheets move off the fold by themselves; split views
  even out their columns at it (Notes, Reminders: 50/50 when folded).
- **Apple**: "Avoid extreme layout changes as people fold the device. Move only what's
  necessary." Grids should have an even number of columns. Continuous scrolling content
  (articles, feeds, documents, lists) does not move away from the fold.
- **Apple**: displacement. Something centred moves to the side that suits its purpose when
  the device folds: folded like a book, alerts go to the trailing side, near where the outer
  display will show them; set on a table, alerts go to the upper half and controls to the
  lower, steadier one. Elements that work together move together.
- **Apple**: *arrangement views* (`ArrangementView`, `UIArrangementViewController`) hold a
  primary and a secondary view. A *split* arrangement puts them side by side when wider than
  tall and one above the other when taller, at the fold if there is one, and can be limited
  to one axis, showing only the primary where it cannot split. An *overlay* arrangement
  layers them and moves them to either side of the fold. Podcasts' Now Playing with its
  transcript is Apple's example of a split limited to the horizontal axis.

## The platform APIs (iOS 27.1)

From the SDK headers (**Apple**):

- `UIHingeInteraction(updateHandler:)`: added to a view, called with the hinge state at
  first and on each change. `update.hinge` is nil without a hinge. `UIHinge.status` is
  unknown 0, closed 1, partiallyOpen 2, fullyOpen 3; `angle` is in radians, its rate "system
  policy". SwiftUI has `onHingeChange`.
- `UIView.reservedRegions(kind:options:)` with `.occlusion` or `.division`, and
  `.includeInactive` for inactive ones. Each region has a frame in the view's coordinates,
  margins, an identifier and `isActive`. UIKit re-runs layout code that read them when they
  change; there is no other notification.
- `UITraitCollection.verticalBarEdge`: leading, trailing or unspecified, "regardless of
  whether a vertical bar is currently visible"; unspecified where no vertical bar is ever
  used. SwiftUI's `toolbarVerticalEdge`.
- `toolbarVerticalBehavior` and `preferredVerticalBarBehavior` turn vertical bars off for a
  view; `ToolbarItemVisibilityPriority`, `axisBehavior` and `ToolbarVerticalCompressionBehavior`
  tune them.

## How Flutter 3.47.7 sees it

- **Measured**: Flutter's `PlatformDispatcher.displays` reports one display, 466 × 678, for
  the whole session, whether the app starts closed or open; it does not change when the
  device opens or closes. On the simulator, `UIScreen.mainScreen` is the outer display.
  The engine reads `UIScreen.mainScreen` once, when the engine starts
  (`FlutterEngine.mm`, `updateDisplays`). Anything that decides "tablet" from it is wrong on
  the inner display.
- **Measured**: the window scene's screen (`window.windowScene.screen.bounds`) does follow
  the device: 466 × 678 closed, 951 × 669 open. Open and wide, the status bar and
  Dynamic Island are an occlusion region 84 × 124 at the top of the side column; open and
  upright, 144 × 82 at the top right; the inner camera is an inactive occlusion until a
  camera is in use, and the fold a 40 pt division, inactive until partially open.
- **Measured**: the view's size and safe area follow the pose. Closed upright: 466 × 678,
  right 84, bottom 34, top 0. Open: 951 × 669, right 84, bottom 34. Open upright:
  669 × 951, top 82, bottom 34. Closed and turned: 678 × 466, with the 84 on the left or the
  right depending on the direction it was turned. The side column is a plain safe-area
  inset.
- **Measured**: `MediaQuery.displayFeatures` is always empty, partially open too, and
  nothing in the view's metrics changes when the device goes from open to partially open.
  The iOS embedder never fills display features (**Others**: flutter#192515, open; the
  draft engine PR #193025 is on hold until the Flutter team has a device, and would also need
  Flutter's CI on Xcode 27.1).
- **Measured**: Flutter draws its own bars, so none of them move to the side. Its
  `NavigationBar` or a custom bottom bar stays at the bottom, and an `AppBar` spans the top
  under the status column.
- So the hinge, the fold, the camera regions, the bar edge and the current screen have to
  come over a platform channel. **Others** found the same and add: read the regions in
  `layoutSubviews` of a view in the Flutter view's hierarchy, so UIKit's tracking re-runs it;
  decide "folded" from the hinge status rather than `isActive`, which lags it; read again when
  the app becomes active; and expect a frame or two between Flutter's new metrics and the
  channel's news.

## Where Apple's guidance is thin

- Where a bottom accessory, such as a mini player, belongs when bars are on the side. The
  HIG and talks do not say.
- How a tab bar's labels appear in the vertical bar. The talks show symbols only and say
  vertical bars suit "symbol-only item representations"; nothing says what becomes of a
  label.
- Which way the reading order of facing pages should run, or whether documents with fixed
  pages count as the "documents" that need not avoid the fold.
- The exact side of the column on the outer display in each landscape rotation. The API
  gives it; no document describes the rule.
- Safe-area sizes as numbers: no Apple page gives them; the figures here are measured.
- Whether a full-screen video folded like a book should span the fold. Apple's games
  guidance prefers filling the screen; its picture-in-picture behaviour gives video half the
  screen when folded. Neither speaks to an app's own full-screen video.

## The simulator

- **Measured**: Xcode 27.1 has no Simulator app; the iPhone Duo simulator runs in Device
  Hub (`/Applications/Xcode.app/Contents/Applications/DeviceHub.app`), whose buttons under
  the device close, partially open and open it and turn it right. Option-drag on the slider
  sets any angle. `simctl` has no pose command.
- **Measured**: `xcrun simctl io <udid> screenshot --display=primary` captures the outer
  display and `--display=primary-1` the inner one; the one not in use is black.
  `recordVideo` takes the same `--display`.
- `scripts/duo/duo_pose.swift` presses Device Hub's buttons through the accessibility API,
  and `scripts/duo/tour.sh` runs the screens tour through every pose with it.

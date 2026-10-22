import 'dart:math' as math;
import 'dart:ui' show DisplayFeature, DisplayFeatureState, DisplayFeatureType;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recital/core/duo/screen_geometry.dart';
import 'package:recital/core/duo/screen_geometry_providers.dart';

/// The strip along one side of the screen where iPhone Duo puts the status bar, the
/// Dynamic Island and the app's bars, closed or open on its side (DEC-3). Flutter reports
/// it as a safe-area inset on that side; the system's bars sit inside it, so this app's
/// do too.
@immutable
class SideColumn {
  const SideColumn({
    required this.side,
    required this.width,
    required this.top,
    required this.bottom,
  });

  final BarSide side;

  /// The inset on [side]: 84 points on iPhone Duo.
  final double width;

  /// Where controls may start: below the status bar and the camera at the column's top.
  final double top;

  /// The home indicator's inset at the bottom.
  final double bottom;

  @override
  bool operator ==(Object other) =>
      other is SideColumn &&
      other.side == side &&
      other.width == width &&
      other.top == top &&
      other.bottom == bottom;

  @override
  int get hashCode => Object.hash(side, width, top, bottom);
}

/// The screen as this app lays out for it: the geometry the platform reported and the side
/// column, if bars go to the side now.
@immutable
class ScreenLayout {
  const ScreenLayout({required this.geometry, this.column});

  static const none = ScreenLayout(geometry: ScreenGeometry.none);

  final ScreenGeometry geometry;
  final SideColumn? column;

  /// The fold while the device is partially open, in the view's coordinates.
  Rect? get fold => geometry.fold;

  static ScreenLayout of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_ScreenLayoutScope>()
          ?.layout ??
      none;

  /// The side column, or null where bars are horizontal.
  static SideColumn? columnOf(BuildContext context) => of(context).column;

  /// Whether a list [width] wide goes two to a row: a window wider than tall, as an
  /// iPhone Duo's inner display held open, with the list as wide as Apple's regular
  /// width. A list in one pane of a split keeps one column. Size decides, never the
  /// device, as Apple asks.
  static bool twoColumns(BuildContext context, double width) {
    final window = MediaQuery.sizeOf(context);
    return window.width > window.height && width >= wideScreenWidth;
  }

  /// Where Apple's regular width starts, about; iPhone Duo's inner display is 951 wide.
  static const wideScreenWidth = 600.0;

  @override
  bool operator ==(Object other) =>
      other is ScreenLayout &&
      other.geometry == geometry &&
      other.column == column;

  @override
  int get hashCode => Object.hash(geometry, column);
}

/// Above every page: gives them [ScreenLayout], and puts the fold into
/// [MediaQueryData.displayFeatures] while the device is partially open, so Flutter's
/// dialogs, sheets and menus open on one side of it, as UIKit's do. Flutter reports no
/// display features on iOS itself (DEC-3).
class ScreenLayoutScope extends ConsumerWidget {
  const ScreenLayoutScope({required this.child, super.key});

  final Widget child;

  /// The gap kept between the status bar's bottom and the first control below it.
  static const statusGap = 8.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geometry = ref.watch(screenGeometryProvider);
    final media = MediaQuery.of(context);
    final layout = ScreenLayout(
      geometry: geometry,
      column: _column(geometry, media),
    );
    // Should Flutter come to report the fold itself (flutter/flutter#193025), it wins.
    final reported = media.displayFeatures.any(
      (feature) => feature.type != DisplayFeatureType.cutout,
    );
    final fold = reported ? null : _foldWithin(geometry.fold, media.size);
    // Always the same widgets, whatever the pose, so folding never rebuilds the pages'
    // state.
    return MediaQuery(
      data: media.copyWith(
        displayFeatures: [
          ...media.displayFeatures,
          if (fold != null)
            DisplayFeature(
              bounds: fold,
              type: DisplayFeatureType.fold,
              state: DisplayFeatureState.postureHalfOpened,
            ),
        ],
      ),
      child: _ScreenLayoutScope(layout: layout, child: child),
    );
  }

  /// The platform's fold and Flutter's view size arrive separately while the device
  /// moves; a fold outside the view belongs to the pose before.
  static Rect? _foldWithin(Rect? fold, Size view) {
    if (fold == null) return null;
    return (Offset.zero & view).contains(fold.center) ? fold : null;
  }

  static SideColumn? _column(ScreenGeometry geometry, MediaQueryData media) {
    final side = geometry.barSide;
    if (side == null) return null;
    final padding = media.viewPadding;
    final width = side == BarSide.left ? padding.left : padding.right;
    // The trait can name an edge a frame before Flutter's insets catch up.
    if (width <= 0) return null;
    final strip = side == BarSide.left
        ? Rect.fromLTWH(0, 0, width, media.size.height)
        : Rect.fromLTWH(media.size.width - width, 0, width, media.size.height);
    var top = padding.top;
    for (final occlusion in geometry.activeOcclusions) {
      if (occlusion.overlaps(strip)) top = math.max(top, occlusion.bottom);
    }
    return SideColumn(
      side: side,
      width: width,
      top: top + statusGap,
      bottom: padding.bottom,
    );
  }
}

class _ScreenLayoutScope extends InheritedWidget {
  const _ScreenLayoutScope({required this.layout, required super.child});

  final ScreenLayout layout;

  @override
  bool updateShouldNotify(_ScreenLayoutScope oldWidget) =>
      layout != oldWidget.layout;
}

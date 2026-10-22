import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// The state of a device's hinge, as UIKit reports it.
enum Hinge {
  /// No hinge, or nothing reported yet.
  none,
  closed,
  partiallyOpen,
  fullyOpen,
}

/// The physical side of the screen where the system puts vertical bars on iPhone Duo. It
/// stays on that side in right-to-left languages, as Apple's own bars do.
enum BarSide { left, right }

/// An area the hardware or the system reserves within the app's view: the fold (a
/// division) or a camera and the status bar (an occlusion), in logical pixels.
@immutable
class ReservedRegion {
  const ReservedRegion(this.frame, {required this.active});

  final Rect frame;

  /// Whether it affects the view now; the fold is active only while the device is
  /// partially open, the inner camera only while it is in use.
  final bool active;

  @override
  bool operator ==(Object other) =>
      other is ReservedRegion && other.frame == frame && other.active == active;

  @override
  int get hashCode => Object.hash(frame, active);
}

/// What Flutter 3.47 does not report on iOS about the screen the app is on, from
/// `ios/Runner/ScreenGeometryPlugin.swift` (DEC-3). On other platforms and before iOS 27.1 only [screen] may
/// be known.
@immutable
class ScreenGeometry {
  const ScreenGeometry({
    this.screen,
    this.hinge = Hinge.none,
    this.hingeAngle = 0,
    this.divisions = const [],
    this.occlusions = const [],
    this.barSide,
  });

  /// From the platform channel's event.
  factory ScreenGeometry.fromMap(Map<Object?, Object?> map) {
    final screen = map['screen'] as List<Object?>?;
    return ScreenGeometry(
      screen: screen == null
          ? null
          : Size(
              (screen[0]! as num).toDouble(),
              (screen[1]! as num).toDouble(),
            ),
      hinge:
          Hinge.values.elementAtOrNull((map['hinge'] as num?)?.toInt() ?? 0) ??
          Hinge.none,
      hingeAngle: (map['hingeAngle'] as num?)?.toDouble() ?? 0,
      divisions: _regions(map['divisions']),
      occlusions: _regions(map['occlusions']),
      barSide: switch (map['barEdge']) {
        'left' => BarSide.left,
        'right' => BarSide.right,
        _ => null,
      },
    );
  }

  /// A device that reports nothing: a phone or tablet laid out as before.
  static const none = ScreenGeometry();

  /// The size of the screen the app's scene is on, in logical pixels, which changes
  /// when an iPhone Duo opens or closes.
  final Size? screen;

  final Hinge hinge;

  /// In degrees: 0 closed, 180 flat.
  final double hingeAngle;

  final List<ReservedRegion> divisions;
  final List<ReservedRegion> occlusions;

  /// Where the system puts vertical bars now, or null where bars are horizontal: the inner
  /// display held upright, and every device without a vertical bar.
  final BarSide? barSide;

  /// The fold while the device is partially open, in the view's coordinates. The hinge
  /// decides rather than the region's own flag, which lags it.
  Rect? get fold {
    if (hinge != Hinge.partiallyOpen) return null;
    for (final division in divisions) {
      if (!division.frame.isEmpty) return division.frame;
    }
    return null;
  }

  /// The occlusions that cover content now.
  Iterable<Rect> get activeOcclusions => [
    for (final region in occlusions)
      if (region.active) region.frame,
  ];

  static List<ReservedRegion> _regions(Object? value) => [
    for (final region in (value as List<Object?>?) ?? const <Object?>[])
      if (region case [
        final num left,
        final num top,
        final num width,
        final num height,
        final num active,
      ])
        ReservedRegion(
          Rect.fromLTWH(
            left.toDouble(),
            top.toDouble(),
            width.toDouble(),
            height.toDouble(),
          ),
          active: active != 0,
        ),
  ];

  @override
  bool operator ==(Object other) =>
      other is ScreenGeometry &&
      other.screen == screen &&
      other.hinge == hinge &&
      other.hingeAngle == hingeAngle &&
      listEquals(other.divisions, divisions) &&
      listEquals(other.occlusions, occlusions) &&
      other.barSide == barSide;

  @override
  int get hashCode => Object.hash(
    screen,
    hinge,
    hingeAngle,
    Object.hashAll(divisions),
    Object.hashAll(occlusions),
    barSide,
  );

  @override
  String toString() =>
      'ScreenGeometry(screen: $screen, hinge: $hinge ${hingeAngle.round()}°, '
      'divisions: ${divisions.map((d) => '${d.frame}${d.active ? '' : ' inactive'}')}, '
      'occlusions: ${occlusions.map((o) => '${o.frame}${o.active ? '' : ' inactive'}')}, '
      'barSide: $barSide)';
}

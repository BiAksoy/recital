import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:recital/core/duo/screen_geometry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'screen_geometry_providers.g.dart';

const _channel = EventChannel('dev.biaksoy.recital/screen_geometry');

/// Every change `ScreenGeometryPlugin.swift` reports. Only iOS has the plugin.
@Riverpod(keepAlive: true)
Stream<ScreenGeometry> screenGeometryUpdates(Ref ref) {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) {
    return Stream.value(ScreenGeometry.none);
  }
  return _channel.receiveBroadcastStream().map(
    (event) => ScreenGeometry.fromMap(event as Map<Object?, Object?>),
  );
}

/// The screen's geometry now, [ScreenGeometry.none] until the platform has said; a test
/// chooses one by overriding it.
@Riverpod(keepAlive: true)
ScreenGeometry screenGeometry(Ref ref) =>
    ref.watch(screenGeometryUpdatesProvider).value ?? ScreenGeometry.none;

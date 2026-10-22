// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_geometry_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every change `ScreenGeometryPlugin.swift` reports. Only iOS has the plugin.

@ProviderFor(screenGeometryUpdates)
final screenGeometryUpdatesProvider = ScreenGeometryUpdatesProvider._();

/// Every change `ScreenGeometryPlugin.swift` reports. Only iOS has the plugin.

final class ScreenGeometryUpdatesProvider
    extends
        $FunctionalProvider<
          AsyncValue<ScreenGeometry>,
          ScreenGeometry,
          Stream<ScreenGeometry>
        >
    with $FutureModifier<ScreenGeometry>, $StreamProvider<ScreenGeometry> {
  /// Every change `ScreenGeometryPlugin.swift` reports. Only iOS has the plugin.
  ScreenGeometryUpdatesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'screenGeometryUpdatesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$screenGeometryUpdatesHash();

  @$internal
  @override
  $StreamProviderElement<ScreenGeometry> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ScreenGeometry> create(Ref ref) {
    return screenGeometryUpdates(ref);
  }
}

String _$screenGeometryUpdatesHash() =>
    r'59a0683baf535bb9ec07c85900e02a1991c75a38';

/// The screen's geometry now, [ScreenGeometry.none] until the platform has said; a test
/// chooses one by overriding it.

@ProviderFor(screenGeometry)
final screenGeometryProvider = ScreenGeometryProvider._();

/// The screen's geometry now, [ScreenGeometry.none] until the platform has said; a test
/// chooses one by overriding it.

final class ScreenGeometryProvider
    extends $FunctionalProvider<ScreenGeometry, ScreenGeometry, ScreenGeometry>
    with $Provider<ScreenGeometry> {
  /// The screen's geometry now, [ScreenGeometry.none] until the platform has said; a test
  /// chooses one by overriding it.
  ScreenGeometryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'screenGeometryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$screenGeometryHash();

  @$internal
  @override
  $ProviderElement<ScreenGeometry> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScreenGeometry create(Ref ref) {
    return screenGeometry(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScreenGeometry value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScreenGeometry>(value),
    );
  }
}

String _$screenGeometryHash() => r'528da508d6aec731549eee14d20ecf9a747e4e74';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The one audio player every screen starts, streaming from archive.org (DEC-2).

@ProviderFor(audioPlayer)
final audioPlayerProvider = AudioPlayerProvider._();

/// The one audio player every screen starts, streaming from archive.org (DEC-2).

final class AudioPlayerProvider
    extends $FunctionalProvider<AudioPlayer, AudioPlayer, AudioPlayer>
    with $Provider<AudioPlayer> {
  /// The one audio player every screen starts, streaming from archive.org (DEC-2).
  AudioPlayerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioPlayerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioPlayerHash();

  @$internal
  @override
  $ProviderElement<AudioPlayer> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AudioPlayer create(Ref ref) {
    return audioPlayer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioPlayer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioPlayer>(value),
    );
  }
}

String _$audioPlayerHash() => r'da4907d740d3974621d680b1ce2ac2a61956bb40';

@ProviderFor(PlayerController)
final playerControllerProvider = PlayerControllerProvider._();

final class PlayerControllerProvider
    extends $NotifierProvider<PlayerController, NowPlaying?> {
  PlayerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerControllerHash();

  @$internal
  @override
  PlayerController create() => PlayerController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NowPlaying? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NowPlaying?>(value),
    );
  }
}

String _$playerControllerHash() => r'2a34caaf426a2ebf7300d06254daf9b7fec82ea7';

abstract class _$PlayerController extends $Notifier<NowPlaying?> {
  NowPlaying? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NowPlaying?, NowPlaying?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NowPlaying?, NowPlaying?>,
              NowPlaying?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

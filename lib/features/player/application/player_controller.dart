import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:recital/features/catalog/domain/catalog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_controller.g.dart';

/// What is in the player.
class NowPlaying {
  const NowPlaying({
    required this.poem,
    required this.recording,
    required this.playing,
    required this.position,
  });

  final Poem poem;
  final Recording recording;
  final bool playing;
  final Duration position;

  NowPlaying copyWith({bool? playing, Duration? position}) => NowPlaying(
    poem: poem,
    recording: recording,
    playing: playing ?? this.playing,
    position: position ?? this.position,
  );
}

/// The one audio player every screen starts, streaming from archive.org (DEC-2).
@Riverpod(keepAlive: true)
AudioPlayer audioPlayer(Ref ref) {
  final player = AudioPlayer();
  ref.onDispose(player.dispose);
  return player;
}

@Riverpod(keepAlive: true)
class PlayerController extends _$PlayerController {
  final _subscriptions = <StreamSubscription<Object?>>[];

  @override
  NowPlaying? build() {
    final player = ref.watch(audioPlayerProvider);
    _subscriptions
      ..add(
        player.playingStream.listen(
          (playing) => _update((now) => now.copyWith(playing: playing)),
        ),
      )
      ..add(
        player.positionStream.listen(
          (position) => _update((now) => now.copyWith(position: position)),
        ),
      );
    ref.onDispose(() {
      for (final subscription in _subscriptions) {
        unawaited(subscription.cancel());
      }
    });
    return null;
  }

  void _update(NowPlaying Function(NowPlaying now) change) {
    final now = state;
    if (now != null) state = change(now);
  }

  AudioPlayer get _player => ref.read(audioPlayerProvider);

  Future<void> play(Poem poem, Recording recording) async {
    state = NowPlaying(
      poem: poem,
      recording: recording,
      playing: false,
      position: Duration.zero,
    );
    await _player.setUrl(recording.url);
    unawaited(_player.play());
  }

  Future<void> toggle() => _player.playing ? _player.pause() : _player.play();

  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> skip(Duration by) {
    final now = state;
    if (now == null) return Future.value();
    final target = now.position + by;
    final end = now.recording.length;
    return _player.seek(
      target < Duration.zero ? Duration.zero : (target > end ? end : target),
    );
  }

  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  Future<void> stop() async {
    await _player.stop();
    state = null;
  }
}

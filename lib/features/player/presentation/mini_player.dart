import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recital/core/l10n.dart';
import 'package:recital/core/router/app_router.gr.dart';
import 'package:recital/core/theme/theme_context.dart';
import 'package:recital/features/catalog/presentation/poem_view.dart';
import 'package:recital/features/player/application/player_controller.dart';

/// What is playing, over the tabs, opening into the player.
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(playerControllerProvider);
    if (now == null) return const SizedBox.shrink();
    final colors = context.colors;
    final length = now.recording.length.inMilliseconds;
    return Material(
      color: colors.surface,
      child: InkWell(
        onTap: () => context.router.push(const PlayerRoute()),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(
              value: length == 0
                  ? 0
                  : (now.position.inMilliseconds / length).clamp(0, 1),
              minHeight: 2,
              color: colors.accent,
              backgroundColor: colors.hairline,
            ),
            ListTile(
              title: Text(
                now.poem.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(readerLine(context, now.recording)),
              trailing: IconButton(
                onPressed: ref.read(playerControllerProvider.notifier).toggle,
                tooltip: now.playing ? context.l10n.pause : context.l10n.play,
                icon: Icon(
                  now.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

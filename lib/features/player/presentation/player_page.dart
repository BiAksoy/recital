import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recital/core/duo/fold_anchors.dart';
import 'package:recital/core/duo/fold_split.dart';
import 'package:recital/core/duo/page_scaffold.dart';
import 'package:recital/core/l10n.dart';
import 'package:recital/core/theme/theme_context.dart';
import 'package:recital/features/catalog/application/catalog_providers.dart';
import 'package:recital/features/catalog/presentation/poem_view.dart';
import 'package:recital/features/player/application/player_controller.dart';

/// The player. Its layouts follow Apple's guidance for iPhone Duo (DEC-3):
///
/// - one column on a phone and on the inner display held upright;
/// - wide, and folded like a book, the controls and the other readings beside the poem,
///   so the poem can be read along, as Podcasts puts Now Playing beside its transcript;
/// - on a table, folded with the crease across, the poem above the fold, to be read from
///   a distance, and the controls on the half that rests on the table, where a tap does
///   not rock the device.
@RoutePage()
class PlayerPage extends ConsumerWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(playerControllerProvider);
    final catalog = ref.watch(catalogProvider).value;
    if (now == null || catalog == null) return const Scaffold();
    final poem = PoemView(poem: now.poem, poet: catalog.poetOf(now.poem));
    final controls = _Controls(now: now);
    final readings = ReadingsList(poem: now.poem);
    return PageScaffold(
      title: Text(context.l10n.nowPlaying),
      actions: [
        IconButton(
          onPressed: () => _showSource(context, now),
          tooltip: context.l10n.aboutRecording,
          icon: const Icon(Icons.info_outline_rounded),
        ),
      ],
      body: FoldSplit(
        single: (context) => ListView(children: [controls, poem, readings]),
        sideBySide: (context) => (
          ListView(children: [controls, readings]),
          ListView(primary: false, children: [poem]),
        ),
        stacked: (context) => (
          ListView(children: [poem]),
          ListView(primary: false, children: [controls, readings]),
        ),
      ),
    );
  }

  /// Where the reading comes from. Partially open, the dialog opens on the side Apple
  /// puts alerts.
  static Future<void> _showSource(BuildContext context, NowPlaying now) =>
      showDialog<void>(
        context: context,
        anchorPoint: foldDialogAnchor,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.aboutRecording),
          content: Text(
            context.l10n.recordingSource(
              readerLine(context, now.recording),
              now.poem.librivox.week,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.l10n.close),
            ),
          ],
        ),
      );
}

class _Controls extends ConsumerWidget {
  const _Controls({required this.now});

  final NowPlaying now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(playerControllerProvider.notifier);
    final spacing = context.spacing;
    final colors = context.colors;
    final length = now.recording.length;
    final position = now.position > length ? length : now.position;
    return Padding(
      padding: EdgeInsets.all(spacing.lg),
      child: Column(
        children: [
          Text(
            now.poem.title,
            style: context.text.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.xs),
          Text(
            readerLine(context, now.recording),
            style: context.text.bodyMedium?.copyWith(color: colors.inkMuted),
          ),
          SizedBox(height: spacing.md),
          Slider(
            value: position.inMilliseconds.toDouble(),
            max: length.inMilliseconds.toDouble(),
            activeColor: colors.accent,
            inactiveColor: colors.hairline,
            onChanged: (value) =>
                controller.seek(Duration(milliseconds: value.round())),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_time(position), style: context.text.labelMedium),
              Text(_time(length), style: context.text.labelMedium),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => controller.skip(const Duration(seconds: -10)),
                tooltip: context.l10n.back10,
                iconSize: 32,
                icon: const Icon(Icons.replay_10_rounded),
              ),
              SizedBox(width: spacing.lg),
              IconButton.filled(
                onPressed: controller.toggle,
                tooltip: now.playing ? context.l10n.pause : context.l10n.play,
                iconSize: 40,
                style: IconButton.styleFrom(backgroundColor: colors.accent),
                icon: Icon(
                  now.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                ),
              ),
              SizedBox(width: spacing.lg),
              IconButton(
                onPressed: () => controller.skip(const Duration(seconds: 10)),
                tooltip: context.l10n.forward10,
                iconSize: 32,
                icon: const Icon(Icons.forward_10_rounded),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: () => _chooseSpeed(context, ref),
            icon: const Icon(Icons.speed_rounded),
            label: Text(context.l10n.speed),
          ),
        ],
      ),
    );
  }

  /// A sheet of choices. Partially open, it opens on the side Apple puts controls.
  Future<void> _chooseSpeed(BuildContext context, WidgetRef ref) async {
    // Read first: a change of pose while the sheet is open lays the page out again, and
    // this widget may be built anew in the other pane before the choice comes back.
    final controller = ref.read(playerControllerProvider.notifier);
    final speed = await showModalBottomSheet<double>(
      context: context,
      anchorPoint: foldSheetAnchor,
      useSafeArea: sheetUsesSafeArea(context),
      showDragHandle: true,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [
          for (final speed in const [0.75, 1.0, 1.25, 1.5])
            ListTile(
              title: Text(context.l10n.speedValue(speed)),
              onTap: () => Navigator.of(context).pop(speed),
            ),
        ],
      ),
    );
    if (speed != null) await controller.setSpeed(speed);
  }

  static String _time(Duration duration) =>
      '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
}

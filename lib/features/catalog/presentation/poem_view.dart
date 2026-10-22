import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recital/core/l10n.dart';
import 'package:recital/core/theme/app_theme.dart';
import 'package:recital/core/theme/theme_context.dart';
import 'package:recital/features/catalog/domain/catalog.dart';
import 'package:recital/features/player/application/player_controller.dart';

/// A poem's title, its poet and year, then its lines, as a page sets them.
class PoemView extends StatelessWidget {
  const PoemView({required this.poem, required this.poet, super.key});

  final Poem poem;
  final Poet poet;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(poem.title, style: context.text.headlineSmall),
          SizedBox(height: spacing.xs),
          Text(
            context.l10n.poetAndYear(poet.name, '${poem.year}'),
            style: context.text.bodyMedium?.copyWith(color: colors.inkMuted),
          ),
          SizedBox(height: spacing.lg),
          // Each line as the poet broke it; an empty line between stanzas.
          for (final line in poem.lines)
            if (line.isEmpty)
              SizedBox(height: spacing.md)
            else
              Text(line, style: poemTextStyle(context)),
        ],
      ),
    );
  }
}

/// The volunteers' readings of [poem], each played on a tap, the one playing marked.
class ReadingsList extends ConsumerWidget {
  const ReadingsList({required this.poem, super.key});

  final Poem poem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playing = ref.watch(
      playerControllerProvider.select((now) => now?.recording.url),
    );
    final colors = context.colors;
    final spacing = context.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.lg,
            spacing.lg,
            spacing.sm,
          ),
          child: Text(
            context.l10n.readingsTitle(poem.recordings.length),
            style: context.text.titleMedium,
          ),
        ),
        for (final recording in poem.recordings)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: spacing.lg),
            selected: recording.url == playing,
            selectedTileColor: colors.accentWash,
            selectedColor: colors.accent,
            leading: Icon(
              recording.url == playing
                  ? Icons.graphic_eq_rounded
                  : Icons.play_circle_outline_rounded,
            ),
            title: Text(readerLine(context, recording)),
            trailing: Text(
              recording.duration,
              style: context.text.labelMedium?.copyWith(color: colors.inkMuted),
            ),
            onTap: () => ref
                .read(playerControllerProvider.notifier)
                .play(poem, recording),
          ),
      ],
    );
  }
}

/// Who reads [recording], as the file names them.
String readerLine(BuildContext context, Recording recording) {
  final reader = recording.reader;
  return reader == null
      ? context.l10n.readByVolunteer
      : context.l10n.readBy(reader);
}

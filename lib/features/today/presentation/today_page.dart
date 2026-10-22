import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recital/core/duo/page_scaffold.dart';
import 'package:recital/core/l10n.dart';
import 'package:recital/core/theme/theme_context.dart';
import 'package:recital/features/catalog/presentation/catalog_view.dart';
import 'package:recital/features/catalog/presentation/poem_layout.dart';

/// The day's poem, a day at a time.
@RoutePage()
class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  DateTime _day = DateUtils.dateOnly(DateTime.now());

  void _move(int days) => setState(() => _day = _day.add(Duration(days: days)));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final today = DateUtils.isSameDay(_day, DateTime.now());
    return PageScaffold(
      title: Text(l10n.todayTitle),
      actions: [
        if (!today)
          TextButton(
            onPressed: () =>
                setState(() => _day = DateUtils.dateOnly(DateTime.now())),
            child: Text(l10n.backToToday),
          ),
        IconButton(
          onPressed: () => _move(-1),
          tooltip: l10n.previousDay,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        IconButton(
          onPressed: () => _move(1),
          tooltip: l10n.nextDay,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
      body: CatalogView(
        data: (catalog) {
          final poem = catalog.poemOfTheDay(_day);
          return PoemLayout(
            poem: poem,
            poet: catalog.poetOf(poem),
            header: Padding(
              padding: EdgeInsets.fromLTRB(
                context.spacing.lg,
                context.spacing.lg,
                context.spacing.lg,
                0,
              ),
              child: Text(
                DateFormat.yMMMMEEEEd().format(_day).toUpperCase(),
                style: context.text.labelMedium?.copyWith(
                  color: context.colors.accent,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

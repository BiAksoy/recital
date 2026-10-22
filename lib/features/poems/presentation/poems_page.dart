import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:recital/core/duo/fold_row.dart';
import 'package:recital/core/duo/page_scaffold.dart';
import 'package:recital/core/l10n.dart';
import 'package:recital/core/router/app_router.gr.dart';
import 'package:recital/core/theme/theme_context.dart';
import 'package:recital/features/catalog/presentation/catalog_view.dart';

/// Every poem, by title. Two to a row in a wide window, the gap at the fold (DEC-3).
@RoutePage()
class PoemsPage extends StatelessWidget {
  const PoemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: Text(context.l10n.poemsTitle),
      body: CatalogView(
        data: (catalog) {
          final poems = [...catalog.poems]
            ..sort((a, b) => a.title.compareTo(b.title));
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: context.spacing.sm),
                sliver: TwoColumnSliverList(
                  itemCount: poems.length,
                  itemBuilder: (context, index) {
                    final poem = poems[index];
                    return ListTile(
                      title: Text(poem.title),
                      subtitle: Text(catalog.poetOf(poem).name),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () =>
                          context.router.push(PoemRoute(poemId: poem.id)),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

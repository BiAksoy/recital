import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:recital/core/duo/fold_row.dart';
import 'package:recital/core/duo/page_scaffold.dart';
import 'package:recital/core/l10n.dart';
import 'package:recital/core/router/app_router.gr.dart';
import 'package:recital/core/theme/theme_context.dart';
import 'package:recital/features/catalog/presentation/catalog_view.dart';

/// A poet's years and poems.
@RoutePage()
class PoetPage extends StatelessWidget {
  const PoetPage({@PathParam('poetId') required this.poetId, super.key});

  final String poetId;

  @override
  Widget build(BuildContext context) {
    return CatalogView(
      data: (catalog) {
        final poet = catalog.poets.firstWhere((poet) => poet.id == poetId);
        final poems = catalog.poemsBy(poet);
        final spacing = context.spacing;
        return PageScaffold(
          title: Text(poet.name),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    spacing.lg,
                    spacing.lg,
                    spacing.lg,
                    spacing.sm,
                  ),
                  child: Text(
                    context.l10n.poetYears(poet.born, poet.died),
                    style: context.text.bodyLarge?.copyWith(
                      color: context.colors.inkMuted,
                    ),
                  ),
                ),
              ),
              TwoColumnSliverList(
                itemCount: poems.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(poems[index].title),
                  subtitle: Text('${poems[index].year}'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () =>
                      context.router.push(PoemRoute(poemId: poems[index].id)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

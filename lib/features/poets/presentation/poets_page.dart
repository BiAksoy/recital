import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:recital/core/duo/fold_row.dart';
import 'package:recital/core/duo/page_scaffold.dart';
import 'package:recital/core/l10n.dart';
import 'package:recital/core/router/app_router.gr.dart';
import 'package:recital/core/theme/theme_context.dart';
import 'package:recital/features/catalog/presentation/catalog_view.dart';

/// Every poet, by surname as the catalogue lists them.
@RoutePage()
class PoetsPage extends StatelessWidget {
  const PoetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: Text(context.l10n.poetsTitle),
      body: CatalogView(
        data: (catalog) => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: context.spacing.sm),
              sliver: TwoColumnSliverList(
                itemCount: catalog.poets.length,
                itemBuilder: (context, index) {
                  final poet = catalog.poets[index];
                  return ListTile(
                    title: Text(poet.name),
                    subtitle: Text(
                      context.l10n.poetLife(
                        poet.born,
                        poet.died,
                        catalog.poemsBy(poet).length,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () =>
                        context.router.push(PoetRoute(poetId: poet.id)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

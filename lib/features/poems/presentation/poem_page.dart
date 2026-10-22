import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:recital/core/duo/page_scaffold.dart';
import 'package:recital/features/catalog/presentation/catalog_view.dart';
import 'package:recital/features/catalog/presentation/poem_layout.dart';

@RoutePage()
class PoemPage extends StatelessWidget {
  const PoemPage({@PathParam('poemId') required this.poemId, super.key});

  final String poemId;

  @override
  Widget build(BuildContext context) {
    return CatalogView(
      data: (catalog) {
        final poem = catalog.poems.firstWhere((poem) => poem.id == poemId);
        return PageScaffold(
          title: Text(poem.title),
          body: PoemLayout(poem: poem, poet: catalog.poetOf(poem)),
        );
      },
    );
  }
}

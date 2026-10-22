import 'package:flutter/material.dart';
import 'package:recital/core/duo/fold_split.dart';
import 'package:recital/features/catalog/domain/catalog.dart';
import 'package:recital/features/catalog/presentation/poem_view.dart';

/// A poem and its readings. On a wide window, such as iPhone Duo's inner display, the
/// readings sit beside the poem, the next level of the hierarchy Apple asks the inner
/// display to show, and folded like a book they meet at the fold (DEC-3).
class PoemLayout extends StatelessWidget {
  const PoemLayout({
    required this.poem,
    required this.poet,
    this.header,
    super.key,
  });

  final Poem poem;
  final Poet poet;

  /// Above the poem, such as Today's day.
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return FoldSplit(
      single: (context) => ListView(
        children: [
          ?header,
          PoemView(poem: poem, poet: poet),
          ReadingsList(poem: poem),
        ],
      ),
      sideBySide: (context) => (
        ListView(
          children: [
            ?header,
            PoemView(poem: poem, poet: poet),
          ],
        ),
        ListView(primary: false, children: [ReadingsList(poem: poem)]),
      ),
    );
  }
}

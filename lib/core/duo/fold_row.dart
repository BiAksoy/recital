import 'package:flutter/widgets.dart';
import 'package:recital/core/duo/screen_layout.dart';

/// Two children side by side, [gap] apart, or, while iPhone Duo is partially open like a
/// book and the row crosses the fold, one on each side of it, so neither sits in the
/// crease (DEC-3). A list of these is the two-column grid Apple asks for at a fold: an
/// even number of columns.
class FoldRow extends StatefulWidget {
  const FoldRow({
    required this.first,
    required this.second,
    required this.gap,
    this.matchHeights = false,
    super.key,
  });

  /// Makes each child as tall as the taller one, so two cards' borders line up. It
  /// measures their intrinsic heights, which a child built by a [LayoutBuilder] cannot
  /// give.
  final bool matchHeights;

  /// On the left in a left-to-right language.
  final Widget first;
  final Widget second;
  final double gap;

  @override
  State<FoldRow> createState() => _FoldRowState();
}

class _FoldRowState extends State<FoldRow> {
  /// This row's left edge in the view, measured after layout while there is a fold.
  double? _left;

  void _measure(Duration _) {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final left = box.localToGlobal(Offset.zero).dx;
    if (left != _left) setState(() => _left = left);
  }

  @override
  Widget build(BuildContext context) {
    final fold = ScreenLayout.of(context).fold;
    final vertical = fold != null && fold.height > fold.width;
    if (vertical) WidgetsBinding.instance.addPostFrameCallback(_measure);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        var start = (width - widget.gap) / 2;
        var end = start + widget.gap;
        final left = _left;
        if (vertical && left != null) {
          final foldStart = fold.left - left;
          final foldEnd = fold.right - left;
          if (foldStart > 0 && foldEnd < width) {
            start = foldStart;
            end = foldEnd;
          }
        }
        final (leftChild, rightChild) = rtl
            ? (widget.second, widget.first)
            : (widget.first, widget.second);
        final row = Row(
          textDirection: TextDirection.ltr,
          crossAxisAlignment: widget.matchHeights
              ? CrossAxisAlignment.stretch
              : CrossAxisAlignment.start,
          children: [
            SizedBox(width: start, child: leftChild),
            SizedBox(width: end - start),
            Expanded(child: rightChild),
          ],
        );
        return widget.matchHeights ? IntrinsicHeight(child: row) : row;
      },
    );
  }
}

/// A [SliverList] of [itemCount] items, one to a row, or in a wide window two
/// to a row in [FoldRow]s, the gap at the fold when there is one (DEC-3): Apple's list
/// that "rearranges itself into a two-column layout when there's more horizontal space".
/// [separatorBuilder] separates rows, and is told the index of the row's first item.
class TwoColumnSliverList extends StatelessWidget {
  const TwoColumnSliverList({
    required this.itemCount,
    required this.itemBuilder,
    this.separatorBuilder,
    this.gap = 0,
    super.key,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;

  /// Between the two columns where there is no fold.
  final double gap;

  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
    builder: (context, constraints) => _list(
      context,
      wide: ScreenLayout.twoColumns(context, constraints.crossAxisExtent),
    ),
  );

  Widget _list(BuildContext context, {required bool wide}) {
    final separatorBuilder = this.separatorBuilder;
    if (!wide) {
      return separatorBuilder == null
          ? SliverList.builder(itemCount: itemCount, itemBuilder: itemBuilder)
          : SliverList.separated(
              itemCount: itemCount,
              itemBuilder: itemBuilder,
              separatorBuilder: separatorBuilder,
            );
    }
    final rows = (itemCount + 1) ~/ 2;
    Widget row(BuildContext context, int row) => FoldRow(
      first: itemBuilder(context, row * 2),
      second: row * 2 + 1 < itemCount
          ? itemBuilder(context, row * 2 + 1)
          : const SizedBox.shrink(),
      gap: gap,
    );
    return separatorBuilder == null
        ? SliverList.builder(itemCount: rows, itemBuilder: row)
        : SliverList.separated(
            itemCount: rows,
            itemBuilder: row,
            separatorBuilder: (context, row) =>
                separatorBuilder(context, row * 2),
          );
  }
}

/// Builds a sliver for one column or two, as [ScreenLayout.twoColumns] decides from the
/// sliver's own width. The width is read from the sliver's constraints, which change with
/// every frame of a scroll; the built sliver is kept while the answer stays the same, so
/// scrolling does not rebuild the rows.
class TwoColumnsBuilder extends StatefulWidget {
  const TwoColumnsBuilder({required this.builder, super.key});

  final Widget Function(BuildContext context, {required bool twoColumns})
  builder;

  @override
  State<TwoColumnsBuilder> createState() => _TwoColumnsBuilderState();
}

class _TwoColumnsBuilderState extends State<TwoColumnsBuilder> {
  (bool, Widget)? _built;

  @override
  void didUpdateWidget(TwoColumnsBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    _built = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _built = null;
  }

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final wide = ScreenLayout.twoColumns(
          context,
          constraints.crossAxisExtent,
        );
        final built = _built;
        if (built != null && built.$1 == wide) return built.$2;
        final sliver = widget.builder(context, twoColumns: wide);
        _built = (wide, sliver);
        return sliver;
      },
    );
  }
}

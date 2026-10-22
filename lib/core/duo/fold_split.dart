import 'package:flutter/material.dart';
import 'package:recital/core/duo/screen_layout.dart';
import 'package:recital/core/theme/theme_context.dart';

/// Two panes, laid out as Apple's split arrangement lays out its primary and secondary
/// views on iPhone Duo (DEC-3), or one page where neither fits:
///
/// - across a fold running up and down (the device partially open like a book), the
///   panes meet at the fold, one on each side, so nothing sits in the crease;
/// - across a fold running side to side (partially open on its side, like a laptop),
///   [stacked] puts one pane above the fold and one below, if given;
/// - on a window wider than tall with room for two panes of [minPaneWidth], the panes
///   share it equally;
/// - anywhere else, [single], the phone layout.
///
/// The panes keep apart by the fold's width, or by a hairline where there is none.
class FoldSplit extends StatefulWidget {
  const FoldSplit({
    required this.single,
    required this.sideBySide,
    this.stacked,
    this.minPaneWidth = 320,
    super.key,
  });

  final WidgetBuilder single;

  /// The leading and trailing panes.
  final (Widget, Widget) Function(BuildContext context) sideBySide;

  /// The panes above and below a fold that runs side to side.
  final (Widget, Widget) Function(BuildContext context)? stacked;

  final double minPaneWidth;

  @override
  State<FoldSplit> createState() => _FoldSplitState();
}

class _FoldSplitState extends State<FoldSplit> {
  /// Where this widget is in the view, to place the fold in its own coordinates. Known a
  /// frame after layout, which the device's own fold animation covers.
  Offset _origin = Offset.zero;

  void _measure(Duration _) {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final origin = box.localToGlobal(Offset.zero);
    if (origin != _origin) setState(() => _origin = origin);
  }

  @override
  Widget build(BuildContext context) {
    final layout = ScreenLayout.of(context);
    WidgetsBinding.instance.addPostFrameCallback(_measure);
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final fold = layout.fold?.shift(-_origin);
        final bounds = Offset.zero & size;
        if (fold != null && fold.overlaps(bounds)) {
          if (fold.height > fold.width) {
            final (leading, trailing) = widget.sideBySide(context);
            return _split(
              Axis.horizontal,
              leading,
              trailing,
              fold.left.clamp(0, size.width),
              fold.right.clamp(0, size.width),
            );
          }
          if (widget.stacked case final stacked?) {
            final (top, bottom) = stacked(context);
            return _split(
              Axis.vertical,
              top,
              bottom,
              fold.top.clamp(0, size.height),
              fold.bottom.clamp(0, size.height),
            );
          }
        }
        final wide =
            size.width > size.height && size.width >= 2 * widget.minPaneWidth;
        if (!wide) return widget.single(context);
        final (leading, trailing) = widget.sideBySide(context);
        return _split(
          Axis.horizontal,
          leading,
          trailing,
          size.width / 2,
          size.width / 2,
        );
      },
    );
  }

  /// [first] up to [start] and [second] from [end], along [axis], in physical order:
  /// the fold is where it is whatever the language's direction.
  Widget _split(
    Axis axis,
    Widget first,
    Widget second,
    double start,
    double end,
  ) {
    final gap = end - start;
    return Flex(
      direction: axis,
      textDirection: TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: axis == Axis.horizontal ? start : null,
          height: axis == Axis.vertical ? start : null,
          child: first,
        ),
        if (gap > 0)
          SizedBox(
            width: axis == Axis.horizontal ? gap : null,
            height: axis == Axis.vertical ? gap : null,
          )
        else if (axis == Axis.horizontal)
          VerticalDivider(width: 1, color: context.colors.hairline)
        else
          Divider(height: 1, color: context.colors.hairline),
        Expanded(child: second),
      ],
    );
  }
}

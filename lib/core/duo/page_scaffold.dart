import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recital/core/duo/screen_geometry.dart';
import 'package:recital/core/duo/screen_layout.dart';
import 'package:recital/core/theme/theme_context.dart';

/// A page with its app bar. Where bars are horizontal it is a [Scaffold] with an [AppBar].
/// Where iPhone Duo puts bars in the side column (DEC-3), the
/// back or close button and the actions go to the column's top, under the status bar,
/// Back first as Apple orders them, and the title stays in a slimmer row over the content.
/// Actions that do not fit above the tabs stay in that row, as text items stay in the
/// system's horizontal bar.
class PageScaffold extends StatelessWidget {
  const PageScaffold({
    required this.title,
    required this.body,
    this.leading,
    this.actions = const [],
    this.backgroundColor,
    super.key,
  });

  final Widget title;
  final Widget body;

  /// In place of the back or close button the route implies.
  final Widget? leading;

  /// Icon buttons, each as wide as an [IconButton], and [TextButton]s, which stay in
  /// the title row.
  final List<Widget> actions;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final column = ScreenLayout.columnOf(context);
    if (column == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(leading: leading, title: title, actions: actions),
        body: body,
      );
    }
    final leadingItem = leading ?? impliedLeading(context);
    // Text buttons stay in the title row, as text items stay in the system's horizontal
    // bar; the icons go to the column.
    final icons = [
      for (final action in actions)
        if (action is! TextButton) action,
    ];
    final texts = [
      for (final action in actions)
        if (action is TextButton) action,
    ];
    // Where the icons start among the column's items.
    final first = leadingItem == null ? 0 : 1;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SideColumnLayout(
        column: column,
        items: [?leadingItem, ...icons],
        content: (context, overflow) => Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: title,
              centerTitle: false,
              actions: [
                ...texts,
                for (final index in overflow)
                  if (index >= first) icons[index - first],
              ],
              // The status bar is in the side column now, over the page's colour
              // rather than the bar's navy.
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: body,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The button [AppBar] would put first on this route: close on a full-screen dialog,
  /// back on any other page with one under it.
  static Widget? impliedLeading(BuildContext context) {
    final route = ModalRoute.of(context);
    if (!(route?.impliesAppBarDismissal ?? false)) return null;
    return route is PageRoute && route.fullscreenDialog
        ? const CloseButton()
        : const BackButton();
  }
}

/// How much of the side column, from the bottom of the screen, the tabs take; nothing
/// above the tab shell.
class SideRailExtent extends InheritedWidget {
  const SideRailExtent({required this.extent, required super.child, super.key});

  final double extent;

  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SideRailExtent>()?.extent ?? 0;

  @override
  bool updateShouldNotify(SideRailExtent oldWidget) =>
      extent != oldWidget.extent;
}

/// [content] beside the side column, with as many of [items] at the column's top as fit
/// above the tabs. [content] is told which items did not fit, by index into [items], and
/// does not get the column's inset.
class SideColumnLayout extends StatelessWidget {
  const SideColumnLayout({
    required this.column,
    required this.items,
    required this.content,
    super.key,
  });

  final SideColumn column;
  final List<Widget> items;
  final Widget Function(BuildContext context, List<int> overflow) content;

  /// An [IconButton]'s height and the gap between two.
  static const itemExtent = 48.0;
  static const itemGap = 4.0;

  @override
  Widget build(BuildContext context) {
    final rail = SideRailExtent.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final room =
            constraints.maxHeight -
            column.top -
            math.max(rail, column.bottom) -
            itemGap;
        final fits = math.max(
          0,
          ((room + itemGap) / (itemExtent + itemGap)).floor(),
        );
        final shown = math.min(fits, items.length);
        final strip = SizedBox(
          width: column.width,
          child: ColoredBox(
            color: context.colors.surface,
            child: Padding(
              padding: EdgeInsets.only(top: column.top),
              child: Column(
                children: [
                  for (var i = 0; i < shown; i++) ...[
                    if (i > 0) const SizedBox(height: itemGap),
                    SizedBox(
                      height: itemExtent,
                      child: Center(child: items[i]),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
        final body = Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeLeft: column.side == BarSide.left,
            removeRight: column.side == BarSide.right,
            child: Builder(
              builder: (context) => content(context, [
                for (var i = shown; i < items.length; i++) i,
              ]),
            ),
          ),
        );
        // The column is on a physical side, whatever the language's direction.
        return Row(
          textDirection: TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: column.side == BarSide.left ? [strip, body] : [body, strip],
        );
      },
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:recital/core/duo/page_scaffold.dart';
import 'package:recital/core/duo/screen_geometry.dart';
import 'package:recital/core/duo/screen_layout.dart';
import 'package:recital/core/l10n.dart';
import 'package:recital/core/router/app_router.dart';
import 'package:recital/core/theme/theme_context.dart';
import 'package:recital/features/player/presentation/mini_player.dart';

/// The three tabs, each with its own stack, and the mini player above them.
///
/// Where iPhone Duo puts bars on the side (closed, or open and wider than tall), the tabs
/// stand at the foot of the side column, as Apple bottom-aligns a vertical tab bar, and
/// each page puts its own buttons at the column's top ([PageScaffold]) (DEC-3).
@RoutePage()
class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tabs = [
      _Tab(Icons.today_outlined, Icons.today_rounded, l10n.todayTab),
      _Tab(Icons.menu_book_outlined, Icons.menu_book_rounded, l10n.poemsTab),
      _Tab(Icons.people_outline_rounded, Icons.people_rounded, l10n.poetsTab),
    ];
    return AutoTabsRouter(
      routes: [todayTab(), poemsTab(), poetsTab()],
      builder: (context, child) {
        final router = AutoTabsRouter.of(context);
        void select(int index) {
          if (index == router.activeIndex) {
            router.stackRouterOfIndex(index)?.popUntilRoot();
          }
          router.setActiveIndex(index);
        }

        // One shape whatever the pose, so a pose change keeps every tab's pages: the
        // tabs along the bottom, or at the foot of iPhone Duo's side column.
        final column = ScreenLayout.columnOf(context);
        final onLeft = column?.side == BarSide.left;
        return SideRailExtent(
          extent: column == null
              ? 0
              : tabs.length * _sideTabExtent + column.bottom,
          child: Stack(
            children: [
              Scaffold(
                body: child,
                bottomNavigationBar: column == null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const MiniPlayer(),
                          NavigationBar(
                            selectedIndex: router.activeIndex,
                            onDestinationSelected: select,
                            destinations: [
                              for (final tab in tabs)
                                NavigationDestination(
                                  icon: Icon(tab.icon),
                                  selectedIcon: Icon(tab.selectedIcon),
                                  label: tab.label,
                                ),
                            ],
                          ),
                        ],
                      )
                    // The mini player stays under the page, beside the column.
                    : Padding(
                        padding: EdgeInsets.only(
                          left: onLeft ? column.width : 0,
                          right: onLeft ? 0 : column.width,
                        ),
                        child: MediaQuery.removePadding(
                          context: context,
                          removeLeft: true,
                          removeRight: true,
                          child: const SafeArea(
                            top: false,
                            child: MiniPlayer(),
                          ),
                        ),
                      ),
              ),
              if (column != null)
                Positioned(
                  left: onLeft ? 0 : null,
                  right: onLeft ? null : 0,
                  bottom: column.bottom,
                  width: column.width,
                  child: _SideTabs(
                    tabs: tabs,
                    selected: router.activeIndex,
                    onSelected: select,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  static const _sideTabExtent = 56.0;
}

class _Tab {
  const _Tab(this.icon, this.selectedIcon, this.label);

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// The tabs stacked in the side column: symbols only, as Apple's vertical bars show them,
/// each label its tooltip and what a screen reader says.
class _SideTabs extends StatelessWidget {
  const _SideTabs({
    required this.tabs,
    required this.selected,
    required this.onSelected,
  });

  final List<_Tab> tabs;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < tabs.length; index++)
            SizedBox(
              height: HomeShellPage._sideTabExtent,
              child: Center(
                child: IconButton(
                  onPressed: () => onSelected(index),
                  tooltip: tabs[index].label,
                  isSelected: index == selected,
                  color: colors.inkMuted,
                  selectedIcon: Icon(
                    tabs[index].selectedIcon,
                    color: colors.accent,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: index == selected
                        ? colors.accentWash
                        : null,
                  ),
                  icon: Icon(tabs[index].icon),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

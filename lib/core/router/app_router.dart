import 'package:auto_route/auto_route.dart';
import 'package:recital/core/router/app_router.gr.dart';

const todayTab = EmptyShellRoute('TodayTab');
const poemsTab = EmptyShellRoute('PoemsTab');
const poetsTab = EmptyShellRoute('PoetsTab');

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: HomeShellRoute.page,
      path: '/',
      initial: true,
      children: [
        AutoRoute(
          page: todayTab.page,
          path: 'today',
          initial: true,
          children: [AutoRoute(page: TodayRoute.page, path: '')],
        ),
        AutoRoute(
          page: poemsTab.page,
          path: 'poems',
          children: [
            AutoRoute(page: PoemsRoute.page, path: ''),
            AutoRoute(page: PoemRoute.page, path: ':poemId'),
          ],
        ),
        AutoRoute(
          page: poetsTab.page,
          path: 'poets',
          children: [
            AutoRoute(page: PoetsRoute.page, path: ''),
            AutoRoute(page: PoetRoute.page, path: ':poetId'),
            AutoRoute(page: PoemRoute.page, path: 'poem/:poemId'),
          ],
        ),
      ],
    ),
    // Over the tabs and the mini player.
    AutoRoute(page: PlayerRoute.page, path: '/player', fullscreenDialog: true),
  ];
}

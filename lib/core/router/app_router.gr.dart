// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;
import 'package:recital/core/shell/home_shell_page.dart' as _i1;
import 'package:recital/features/player/presentation/player_page.dart' as _i2;
import 'package:recital/features/poems/presentation/poem_page.dart' as _i3;
import 'package:recital/features/poems/presentation/poems_page.dart' as _i4;
import 'package:recital/features/poets/presentation/poet_page.dart' as _i5;
import 'package:recital/features/poets/presentation/poets_page.dart' as _i6;
import 'package:recital/features/today/presentation/today_page.dart' as _i7;

/// generated route for
/// [_i1.HomeShellPage]
class HomeShellRoute extends _i8.PageRouteInfo<void> {
  const HomeShellRoute({List<_i8.PageRouteInfo>? children})
    : super(HomeShellRoute.name, initialChildren: children);

  static const String name = 'HomeShellRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomeShellPage();
    },
  );
}

/// generated route for
/// [_i2.PlayerPage]
class PlayerRoute extends _i8.PageRouteInfo<void> {
  const PlayerRoute({List<_i8.PageRouteInfo>? children})
    : super(PlayerRoute.name, initialChildren: children);

  static const String name = 'PlayerRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.PlayerPage();
    },
  );
}

/// generated route for
/// [_i3.PoemPage]
class PoemRoute extends _i8.PageRouteInfo<PoemRouteArgs> {
  PoemRoute({
    required String poemId,
    _i9.Key? key,
    List<_i8.PageRouteInfo>? children,
  }) : super(
         PoemRoute.name,
         args: PoemRouteArgs(poemId: poemId, key: key),
         rawPathParams: {'poemId': poemId},
         initialChildren: children,
       );

  static const String name = 'PoemRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PoemRouteArgs>(
        orElse: () => PoemRouteArgs(poemId: pathParams.getString('poemId')),
      );
      return _i3.PoemPage(poemId: args.poemId, key: args.key);
    },
  );
}

class PoemRouteArgs {
  const PoemRouteArgs({required this.poemId, this.key});

  final String poemId;

  final _i9.Key? key;

  @override
  String toString() {
    return 'PoemRouteArgs{poemId: $poemId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PoemRouteArgs) return false;
    return poemId == other.poemId && key == other.key;
  }

  @override
  int get hashCode => poemId.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i4.PoemsPage]
class PoemsRoute extends _i8.PageRouteInfo<void> {
  const PoemsRoute({List<_i8.PageRouteInfo>? children})
    : super(PoemsRoute.name, initialChildren: children);

  static const String name = 'PoemsRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i4.PoemsPage();
    },
  );
}

/// generated route for
/// [_i5.PoetPage]
class PoetRoute extends _i8.PageRouteInfo<PoetRouteArgs> {
  PoetRoute({
    required String poetId,
    _i9.Key? key,
    List<_i8.PageRouteInfo>? children,
  }) : super(
         PoetRoute.name,
         args: PoetRouteArgs(poetId: poetId, key: key),
         rawPathParams: {'poetId': poetId},
         initialChildren: children,
       );

  static const String name = 'PoetRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PoetRouteArgs>(
        orElse: () => PoetRouteArgs(poetId: pathParams.getString('poetId')),
      );
      return _i5.PoetPage(poetId: args.poetId, key: args.key);
    },
  );
}

class PoetRouteArgs {
  const PoetRouteArgs({required this.poetId, this.key});

  final String poetId;

  final _i9.Key? key;

  @override
  String toString() {
    return 'PoetRouteArgs{poetId: $poetId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PoetRouteArgs) return false;
    return poetId == other.poetId && key == other.key;
  }

  @override
  int get hashCode => poetId.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i6.PoetsPage]
class PoetsRoute extends _i8.PageRouteInfo<void> {
  const PoetsRoute({List<_i8.PageRouteInfo>? children})
    : super(PoetsRoute.name, initialChildren: children);

  static const String name = 'PoetsRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i6.PoetsPage();
    },
  );
}

/// generated route for
/// [_i7.TodayPage]
class TodayRoute extends _i8.PageRouteInfo<void> {
  const TodayRoute({List<_i8.PageRouteInfo>? children})
    : super(TodayRoute.name, initialChildren: children);

  static const String name = 'TodayRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.TodayPage();
    },
  );
}

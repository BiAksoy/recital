import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recital/app.dart';
import 'package:recital/core/duo/screen_geometry.dart';
import 'package:recital/core/duo/screen_geometry_providers.dart';
import 'package:recital/features/catalog/application/catalog_providers.dart';
import 'package:recital/features/catalog/domain/catalog.dart';
import 'package:recital/features/player/application/player_controller.dart';

/// iPhone Duo's poses as its simulator reports them (docs/reference/iphone-duo.md), in
/// points at 3x.
const _outer = Size(466, 678);
const _innerWide = Size(951, 669);
const _innerTall = Size(669, 951);
const _bookFold = Rect.fromLTWH(455.5, 0, 40, 669);
const _tableFold = Rect.fromLTWH(0, 455.5, 669, 40);

/// The status bar and camera at the top of the outer display's side column.
const _outerStatus = Rect.fromLTWH(382, 0, 84, 150);

const _closed = ScreenGeometry(
  screen: _outer,
  hinge: Hinge.closed,
  barSide: BarSide.right,
  occlusions: [ReservedRegion(_outerStatus, active: true)],
);
const _open = ScreenGeometry(
  screen: _innerWide,
  hinge: Hinge.fullyOpen,
  barSide: BarSide.right,
);
const _book = ScreenGeometry(
  screen: _innerWide,
  hinge: Hinge.partiallyOpen,
  barSide: BarSide.right,
  divisions: [ReservedRegion(_bookFold, active: true)],
);
const _table = ScreenGeometry(
  screen: _innerTall,
  hinge: Hinge.partiallyOpen,
  divisions: [ReservedRegion(_tableFold, active: true)],
);

/// Read from disk once: the bundle's real reads do not finish under a widget test's
/// clock.
final Catalog _catalog = CatalogMapper.fromJson(
  File('assets/catalog.json').readAsStringSync(),
);

/// A player that holds the first reading of the first poem and plays nothing.
class _HeldPlayer extends PlayerController {
  @override
  NowPlaying? build() {
    final catalog = ref.watch(catalogProvider).value;
    if (catalog == null) return null;
    final poem = catalog.poems.first;
    return NowPlaying(
      poem: poem,
      recording: poem.recordings.first,
      playing: false,
      position: Duration.zero,
    );
  }
}

/// The app on a surface [size] points with the Duo's insets: the side column on the
/// right while bars are on the side, the status bar along the top otherwise.
void _surface(WidgetTester tester, Size size, {required bool sideColumn}) {
  const ratio = 3.0;
  final padding = FakeViewPadding(
    right: sideColumn ? 84 * ratio : 0,
    top: sideColumn ? 0 : 82 * ratio,
    bottom: 34 * ratio,
  );
  tester.view
    ..physicalSize = size * ratio
    ..devicePixelRatio = ratio
    ..padding = padding
    ..viewPadding = padding;
}

Future<void> _pumpApp(
  WidgetTester tester,
  Size size,
  ScreenGeometry geometry, {
  bool playing = false,
  ValueListenable<ScreenGeometry>? changes,
}) async {
  const ratio = 3.0;
  final sideColumn = geometry.barSide != null;
  final padding = FakeViewPadding(
    right: sideColumn ? 84 * ratio : 0,
    top: sideColumn ? 0 : 82 * ratio,
    bottom: 34 * ratio,
  );
  tester.view
    ..physicalSize = size * ratio
    ..devicePixelRatio = ratio
    ..padding = padding
    ..viewPadding = padding;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        catalogProvider.overrideWith((ref) async => _catalog),
        if (changes == null)
          screenGeometryProvider.overrideWithValue(geometry)
        else
          screenGeometryProvider.overrideWith((ref) {
            void changed() => ref.invalidateSelf();
            changes.addListener(changed);
            ref.onDispose(() => changes.removeListener(changed));
            return changes.value;
          }),
        if (playing) playerControllerProvider.overrideWith(_HeldPlayer.new),
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _openPlayer(WidgetTester tester) async {
  await tester.tap(
    find.byTooltip('Pause').hitTestable().evaluate().isEmpty
        ? find.textContaining('Read by').last
        : find.byTooltip('Pause'),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a phone has its tabs along the bottom', (tester) async {
    await _pumpApp(tester, const Size(393, 852), ScreenGeometry.none);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('closed, the tabs stand at the foot of the side column and the '
      "day's buttons at its top", (tester) async {
    await _pumpApp(tester, _outer, _closed);
    expect(find.byType(NavigationBar), findsNothing);
    final poets = tester.getRect(find.byTooltip('Poets'));
    expect(poets.left, greaterThanOrEqualTo(_outer.width - 84));
    expect(poets.bottom, lessThanOrEqualTo(_outer.height - 34));
    final next = tester.getRect(find.byTooltip('Next day'));
    expect(next.left, greaterThanOrEqualTo(_outer.width - 84));
    expect(next.top, greaterThanOrEqualTo(_outerStatus.bottom));
  });

  testWidgets('open, the poem sits beside its readings', (tester) async {
    await _pumpApp(tester, _innerWide, _open);
    final half = (_innerWide.width - 84) / 2;
    expect(
      tester.getRect(find.textContaining('readings')).left,
      greaterThan(half),
    );
    expect(tester.getRect(find.byType(Text).at(1)).left, lessThan(half));
  });

  testWidgets(
    'folded like a book, the player meets the fold and its dialog opens '
    'on the right',
    (tester) async {
      await _pumpApp(tester, _innerWide, _book, playing: true);
      await _openPlayer(tester);
      expect(
        tester.getRect(find.byTooltip('Play')).right,
        lessThanOrEqualTo(_bookFold.left),
      );
      await tester.tap(find.byTooltip('About this reading'));
      await tester.pumpAndSettle();
      expect(
        tester.getRect(find.byType(AlertDialog)).left,
        greaterThanOrEqualTo(_bookFold.right),
      );
    },
  );

  testWidgets('on a table, the poem is above the fold and the controls below', (
    tester,
  ) async {
    await _pumpApp(tester, _innerTall, _table, playing: true);
    await _openPlayer(tester);
    expect(
      tester.getRect(find.byTooltip('Play')).top,
      greaterThanOrEqualTo(_tableFold.bottom),
    );
  });

  testWidgets('a change of pose keeps the page a tab has open', (tester) async {
    final geometry = ValueNotifier(_closed);
    addTearDown(geometry.dispose);
    addTearDown(tester.view.reset);
    await _pumpApp(tester, _outer, _closed, changes: geometry);
    await tester.tap(find.byTooltip('Poems'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ozymandias of Egypt'));
    await tester.pumpAndSettle();

    _surface(tester, _innerTall, sideColumn: false);
    geometry.value = const ScreenGeometry(
      screen: _innerTall,
      hinge: Hinge.fullyOpen,
    );
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);
    expect(find.text('Ozymandias of Egypt'), findsWidgets);
  });
}

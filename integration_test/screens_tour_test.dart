import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:recital/app.dart';
import 'package:recital/features/player/application/player_controller.dart';
import 'package:recital/features/player/presentation/mini_player.dart';

/// Walks every screen and screenshots it. On the iPhone Duo simulator,
/// `scripts/duo/tour.sh` runs it and screenshots each screen in every pose (DEC-3); on
/// its own it saves them through the driver:
///
///     flutter drive --driver test_driver/integration_test.dart \
///       --target integration_test/screens_tour_test.dart -d <device>
///
/// It plays a recording from archive.org, so it needs the network.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  var shot = 0;

  Future<void> screenshot(
    WidgetTester tester,
    String name, {
    bool settle = true,
  }) async {
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump(const Duration(seconds: 1));
    }
    shot++;
    final shotName = '${shot.toString().padLeft(2, '0')}_$name';
    if (_duoSync.isEmpty) {
      await binding.takeScreenshot(shotName);
    } else {
      await _holdForPoses(tester, shotName);
    }
  }

  Future<void> tapTab(WidgetTester tester, String label) async {
    await tester.tap(find.byTooltip(label).first);
    await tester.pumpAndSettle();
  }

  testWidgets('every screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();
    await screenshot(tester, 'today');

    await tapTab(tester, 'Poems');
    await screenshot(tester, 'poems');
    await tester.tap(find.text('Ozymandias of Egypt'));
    await tester.pumpAndSettle();
    await screenshot(tester, 'poem');

    await tapTab(tester, 'Poets');
    await screenshot(tester, 'poets');
    await tester.tap(find.text('Walt Whitman'));
    await tester.pumpAndSettle();
    await screenshot(tester, 'poet');

    await tapTab(tester, 'Poems');
    await tester.tap(find.textContaining('Read by').first);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(App)),
    );
    for (var i = 0; i < 80; i++) {
      final now = container.read(playerControllerProvider);
      if (now != null && now.position > const Duration(seconds: 2)) break;
      await tester.pump(const Duration(milliseconds: 250));
    }
    await screenshot(tester, 'mini_player', settle: false);
    await tester.tap(find.byType(MiniPlayer));
    await tester.pump(const Duration(seconds: 1));
    await screenshot(tester, 'player', settle: false);
    await tester.tap(find.text('Speed'));
    await tester.pump(const Duration(seconds: 1));
    await screenshot(tester, 'speed_sheet', settle: false);
    await tester.tap(find.text('1×'));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byTooltip('About this reading'));
    await tester.pump(const Duration(seconds: 1));
    await screenshot(tester, 'about_reading', settle: false);
    await tester.tap(find.text('Close'));
    await tester.pump(const Duration(seconds: 1));
    await container.read(playerControllerProvider.notifier).stop();
    await tester.pumpAndSettle();
  });
}

/// A folder `scripts/duo/tour.sh` shares with the simulator; empty when the tour runs on its
/// own.
const _duoSync = String.fromEnvironment('DUO_TOUR_SYNC');

/// Leaves the screen as it is while `scripts/duo/tour.sh` turns the iPhone Duo through its
/// poses and screenshots each one, and goes on when the script leaves a file named after
/// the shot. Frames keep coming meanwhile, so the app lays itself out for each pose.
Future<void> _holdForPoses(WidgetTester tester, String shotName) async {
  debugPrint('DUO_TOUR_SHOT $shotName');
  final done = File('$_duoSync/$shotName.done');
  for (var i = 0; i < 1200 && !done.existsSync(); i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(done.existsSync(), isTrue, reason: 'tour.sh did not finish $shotName');
}

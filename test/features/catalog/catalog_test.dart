import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:recital/features/catalog/domain/catalog.dart';

void main() {
  final catalog = CatalogMapper.fromJson(
    File('assets/catalog.json').readAsStringSync(),
  );

  test('every poem has its poet, its lines and readings', () {
    expect(catalog.poems, hasLength(12));
    for (final poem in catalog.poems) {
      expect(catalog.poetOf(poem).id, poem.poetId);
      expect(poem.lines.where((line) => line.isNotEmpty), isNotEmpty);
      expect(poem.recordings, isNotEmpty);
      for (final recording in poem.recordings) {
        expect(Uri.parse(recording.url).host, 'archive.org');
        expect(recording.length, greaterThan(Duration.zero));
      }
    }
  });

  test('the poem of the day goes through the catalogue, one a day', () {
    final first = catalog.poemOfTheDay(DateTime(2026));
    expect(first, catalog.poems.first);
    expect(catalog.poemOfTheDay(DateTime(2026, 1, 2)), catalog.poems[1]);
    expect(
      catalog.poemOfTheDay(DateTime(2026).add(const Duration(days: 12))),
      first,
    );
  });

  test('reads a recording without a reader', () {
    final recording = RecordingMapper.fromMap(
      jsonDecode('{"reader": null, "duration": "01:28", "url": "u"}')
          as Map<String, dynamic>,
    );
    expect(recording.reader, isNull);
    expect(recording.length, const Duration(minutes: 1, seconds: 28));
  });
}

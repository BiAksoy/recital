import 'package:dart_mappable/dart_mappable.dart';

part 'catalog.mapper.dart';

/// Everything the app shows, read from `assets/catalog.json` (DEC-2): public-domain poems
/// and LibriVox volunteers' readings of them.
@MappableClass()
class Catalog with CatalogMappable {
  const Catalog({required this.poets, required this.poems});

  final List<Poet> poets;
  final List<Poem> poems;

  Poet poetOf(Poem poem) => poets.firstWhere((poet) => poet.id == poem.poetId);

  List<Poem> poemsBy(Poet poet) => [
    for (final poem in poems)
      if (poem.poetId == poet.id) poem,
  ];

  /// The poem for [day]: the catalogue in order, one a day, round again at the end.
  Poem poemOfTheDay(DateTime day) {
    final days = DateTime.utc(
      day.year,
      day.month,
      day.day,
    ).difference(DateTime.utc(2026)).inDays;
    return poems[days % poems.length];
  }
}

@MappableClass()
class Poet with PoetMappable {
  const Poet({
    required this.id,
    required this.name,
    required this.born,
    required this.died,
  });

  final String id;
  final String name;
  final int born;
  final int died;
}

@MappableClass()
class Poem with PoemMappable {
  const Poem({
    required this.id,
    required this.title,
    required this.poetId,
    required this.year,
    required this.lines,
    required this.recordings,
    required this.librivox,
  });

  final String id;
  final String title;
  final String poetId;

  /// First published.
  final int year;

  /// The text, line by line; an empty line between stanzas.
  final List<String> lines;
  final List<Recording> recordings;
  final LibriVoxItem librivox;
}

/// One volunteer's reading of a poem.
@MappableClass()
class Recording with RecordingMappable {
  const Recording({
    required this.reader,
    required this.duration,
    required this.url,
  });

  /// As LibriVox names the reader on the file, often by initials; null where the file
  /// does not say.
  final String? reader;

  /// "mm:ss", as archive.org gives it.
  final String duration;
  final String url;

  Duration get length {
    final [minutes, seconds] = duration.split(':').map(int.parse).toList();
    return Duration(minutes: minutes, seconds: seconds);
  }
}

/// The archive.org item a poem's readings come from.
@MappableClass()
class LibriVoxItem with LibriVoxItemMappable {
  const LibriVoxItem({required this.week, required this.page});

  /// The week LibriVox's weekly poetry project read it.
  final String week;
  final String page;
}

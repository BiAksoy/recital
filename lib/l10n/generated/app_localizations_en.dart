// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Recital';

  @override
  String get todayTab => 'Today';

  @override
  String get poemsTab => 'Poems';

  @override
  String get poetsTab => 'Poets';

  @override
  String get todayTitle => 'Today\'s poem';

  @override
  String get poemsTitle => 'Poems';

  @override
  String get poetsTitle => 'Poets';

  @override
  String get backToToday => 'Today';

  @override
  String get previousDay => 'Previous day';

  @override
  String get nextDay => 'Next day';

  @override
  String get catalogUnreadable => 'The poems could not be read.';

  @override
  String poetAndYear(String poet, String year) {
    return '$poet, $year';
  }

  @override
  String poetYears(int born, int died) {
    return '$born to $died';
  }

  @override
  String poetLife(int born, int died, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poems',
      one: '1 poem',
    );
    return '$born to $died · $_temp0';
  }

  @override
  String readingsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count readings',
      one: '1 reading',
    );
    return '$_temp0';
  }

  @override
  String readBy(String reader) {
    return 'Read by $reader';
  }

  @override
  String get readByVolunteer => 'Read by a LibriVox volunteer';

  @override
  String get nowPlaying => 'Now playing';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get back10 => 'Back 10 seconds';

  @override
  String get forward10 => 'Forward 10 seconds';

  @override
  String get speed => 'Speed';

  @override
  String speedValue(double speed) {
    final intl.NumberFormat speedNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String speedString = speedNumberFormat.format(speed);

    return '$speedString×';
  }

  @override
  String get aboutRecording => 'About this reading';

  @override
  String recordingSource(String reader, String week) {
    return '$reader, for LibriVox\'s weekly poetry project, the week of $week. LibriVox recordings are in the public domain.';
  }

  @override
  String get close => 'Close';
}

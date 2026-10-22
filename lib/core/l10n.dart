import 'package:flutter/widgets.dart';
import 'package:recital/l10n/generated/app_localizations.dart';

extension L10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

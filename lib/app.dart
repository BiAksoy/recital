import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:recital/core/duo/screen_layout.dart';
import 'package:recital/core/router/app_router.dart';
import 'package:recital/core/theme/app_theme.dart';
import 'package:recital/l10n/generated/app_localizations.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: buildAppTheme(),
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router.config(),
      // Every page sees the screen as iPhone Duo reports it (DEC-3).
      builder: (context, child) => ScreenLayoutScope(child: child!),
    );
  }
}

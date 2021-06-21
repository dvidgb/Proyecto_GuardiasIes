import 'package:flutter/material.dart';
import 'package:prueba_seneca/src/pages/guardias_home.dart';

import 'package:prueba_seneca/src/pages/loggin_page.dart';
import 'package:prueba_seneca/src/pages/personal_centro.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('es', ''), // Arabic, no country code
        const Locale.fromSubtags(
            languageCode: 'es'), // Chinese *See Advanced Locales below*
        // ... other locales the app supports
      ],
      debugShowCheckedModeBanner: false,
      title: 'GuardiasIES Jándula',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => LogginPage(),
        'menupage': (BuildContext context) => PersonalCentro(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tegnordbok/screens/search_screen.dart';

void main() {
  runApp(const ProviderScope(child: TegnordbokApp()));
}

class TegnordbokApp extends StatelessWidget {
  const TegnordbokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tegnordbok",
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: const Locale("nb", "NO"),
      supportedLocales: const [Locale("nb", "NO")],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SearchScreen(),
    );
  }
}

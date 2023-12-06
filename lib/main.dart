import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tegnordbok/screens/search_screen.dart';
import 'package:tegnordbok/settings_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      preferencesProvider.overrideWithValue(sharedPreferences),
    ],
    child: const TegnordbokApp(),
  ));
}

const mainColor = Colors.blue;

class TegnordbokApp extends ConsumerWidget {
  const TegnordbokApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      final themeMode = ref.watch(themeModeProvider);
      final dynamicColors = ref.watch(dynamicColorsProvider);

      return MaterialApp(
        title: "Tegnordbok",
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        locale: const Locale("nb", "NO"),
        supportedLocales: const [Locale("nb", "NO")],
        themeMode: themeMode,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: dynamicColors ? lightDynamic : null,
          colorSchemeSeed:
              lightDynamic == null || !dynamicColors ? mainColor : null,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          colorScheme: dynamicColors ? darkDynamic : null,
          colorSchemeSeed:
              darkDynamic == null || !dynamicColors ? mainColor : null,
        ),
        home: const SearchScreen(),
      );
    });
  }
}

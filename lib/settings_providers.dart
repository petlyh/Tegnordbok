import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferencesProvider = Provider<SharedPreferences>((ref) {
  throw StateError("Invalid access of SharedPreferences");
});

class Settings {}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

extension ThemeModeString on ThemeMode {
  String get name => switch (this) {
        ThemeMode.system => "Enhetstema",
        ThemeMode.light => "Lys",
        ThemeMode.dark => "Mørk",
      };
}

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const key = "thememode";
  static const themes = ["Enhetstema", "Lys", "Mørk"];
  static const defaultValue = "Enhetstema";

  @override
  ThemeMode build() => getThemeMode();

  ThemeMode getThemeMode() => fromString(getThemeModeString());

  void setThemeMode(ThemeMode themeMode) => state = themeMode;

  String getThemeModeString() =>
      ref.read(preferencesProvider).getString(key) ?? defaultValue;

  void setThemeModeString(String input) {
    setThemeMode(fromString(input));
    ref.read(preferencesProvider).setString(key, input);
  }

  ThemeMode fromString(String input) => switch (input) {
        "Enhetstema" => ThemeMode.system,
        "Lys" => ThemeMode.light,
        "Mørk" => ThemeMode.dark,
        _ => throw Exception("Unknown theme: $input"),
      };
}

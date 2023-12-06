import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:tegnordbok/settings_providers.dart";

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final themeModeNotifier = ref.read(themeModeProvider.notifier);

    final dynamicColors = ref.watch(dynamicColorsProvider);
    final dynamicColorsNotifier = ref.read(dynamicColorsProvider.notifier);

    return DynamicColorBuilder(builder: (dynamicColorScheme, _) {
      return Scaffold(
        appBar: AppBar(title: const Text("Innstillinger")),
        body: Column(children: [
          ListTile(
            leading: const Icon(Icons.water_drop, size: 32.0),
            title: const Text("Tema"),
            trailing: DropdownButton(
              value: currentThemeMode.name,
              items: ThemeModeNotifier.themes
                  .map((theme) =>
                      DropdownMenuItem(value: theme, child: Text(theme)))
                  .toList(),
              onChanged: (value) =>
                  themeModeNotifier.setThemeModeString(value!),
            ),
          ),
          if (dynamicColorScheme != null)
            ListTile(
              leading: const Icon(Icons.format_color_fill, size: 32.0),
              title: const Text("Dynamiske Farger"),
              trailing: Switch(
                value: dynamicColors,
                onChanged: dynamicColorsNotifier.set,
              ),
            ),
          const Divider(),
          ListTile(
            onTap: () async {
              final packageInfo = await PackageInfo.fromPlatform();

              if (!context.mounted) {
                return;
              }

              showAboutDialog(
                context: context,
                applicationVersion: packageInfo.version,
                applicationLegalese: _legalese,
              );
            },
            leading: const Icon(Icons.info, size: 32.0),
            title: const Text("Om"),
          ),
        ]),
      );
    });
  }
}

const _legalese = """Lisensiert under GPLv3.

Appen henter data fra Statpeds Tegnordbok og TegnWiki.

YouTube-videoer blir hentet gjennom Piped.video.""";

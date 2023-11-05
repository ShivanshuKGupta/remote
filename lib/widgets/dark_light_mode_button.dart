import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote/providers/settings.dart';

class DarkLightModeIconButton extends ConsumerWidget {
  const DarkLightModeIconButton({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final settingsObj = ref.watch(settings);
    final settingsClass = ref.read(settings.notifier);
    return IconButton(
      onPressed: () {
        if (settingsObj.autoDarkMode) {
          settingsObj.autoDarkMode = false;
          settingsObj.darkMode =
              !(MediaQuery.of(context).platformBrightness == Brightness.dark);
        } else {
          if (MediaQuery.of(context).platformBrightness ==
              (settingsObj.darkMode ? Brightness.dark : Brightness.light)) {
            settingsObj.autoDarkMode = true;
          }
          settingsObj.darkMode = !settingsObj.darkMode;
        }
        settingsClass.notifyListeners();
      },
      icon: Icon(
        settingsObj.autoDarkMode
            ? Icons.brightness_auto_rounded
            : !settingsObj.darkMode
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
      ),
    );
  }
}

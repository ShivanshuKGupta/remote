// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_android_volume_keydown/flutter_android_volume_keydown.dart';

import 'package:remote/providers/server.dart';
import 'package:remote/providers/settings.dart';
import 'package:remote/providers/volume_button_functions.dart';
import 'package:remote/widgets/select_one.dart';

import '../providers/remote_buttons.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsInstance = ref.read(settings);
    final settingsClass = ref.read(settings.notifier);
    const options = {
      VolumButtonFunctions.leftRight: "Left Right",
      VolumButtonFunctions.upDown: "Up Down",
      VolumButtonFunctions.scroll: "Scroll Up Down",
      VolumButtonFunctions.switchMode: "Toggle Scroll Mode",
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // SwitchListTile(
          //     title: const Text('Dark Mode'),
          //     subtitle: Text(
          //       'Reduce Glare',
          //       style: TextStyle(color: Theme.of(context).colorScheme.primary),
          //     ),
          //     value: ref.watch(settings).darkMode,
          //     onChanged: (value) {
          //       settingsInstance.darkMode = value;
          //       settingsClass.notifyListeners();
          //     }),
          // const Divider(),
          SwitchListTile(
              title: const Text('Receive Screenshot'),
              isThreeLine: true,
              subtitle: Text(
                'This disables the screenshot receiving feature, can improve performance',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              value: ref.watch(settings).receiveImage,
              onChanged: (value) {
                settingsInstance.receiveImage = value;
                settingsClass.notifyListeners();
                ref.read(server.notifier).send(settingsClass.encodeServer());
              }),
          const Divider(),
          SwitchListTile(
              title: const Text('Use Keys instead of Clicks'),
              isThreeLine: true,
              subtitle: Text(
                'Press left/right arrow keys for touches on left/right side of the screen instead of mouse click (in mouse mode).',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              value: ref.watch(settings).clicksToKeys,
              onChanged: (value) {
                settingsInstance.clicksToKeys = value;
                settingsClass.notifyListeners();
              }),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                SelectOne<String>(
                  expanded: true,
                  title: "Volume Button Function",
                  allOptions: options.values.toSet(),
                  // allOptions: [
                  //   'Left/Right',
                  //   'Up/Down',
                  //   'Scroll',
                  //   'Toggle Scroll Mode'
                  // ],
                  selectedOption:
                      options[settingsInstance.volumeButtonFunctions],
                  onChange: (value) {
                    settingsInstance.volumeButtonFunctions = options.entries
                        .firstWhere((entry) => entry.value == value)
                        .key;
                    settingsClass.notifyListeners();
                    return true;
                  },
                ),
                // DropdownButton(
                //   // icon: const Icon(Icons.arrow_downward_rounded),
                //   elevation: 5,
                //   isDense: false,
                //   hint: const Text('Function'),
                //   borderRadius: BorderRadius.circular(20),
                //   value: settingsInstance.volumeButtonFunctions,
                //   items: const <DropdownMenuItem<VolumButtonFunctions>>[
                //     DropdownMenuItem(
                //       value: VolumButtonFunctions.leftRight,
                //       child: Text('Left/Right'),
                //     ),
                //     DropdownMenuItem(
                //       value: VolumButtonFunctions.upDown,
                //       child: Text('Up/Down'),
                //     ),
                //     DropdownMenuItem(
                //       value: VolumButtonFunctions.scroll,
                //       child: Text('Scroll'),
                //     ),
                //     DropdownMenuItem(
                //       value: VolumButtonFunctions.switchMode,
                //       child: Text('Toggle Scroll Mode'),
                //     ),
                //   ],
                //   onChanged: (value) {
                //     settingsInstance.volumeButtonFunctions =
                //         value ?? VolumButtonFunctions.leftRight;
                //     settingsClass.notifyListeners();
                //   },
                // ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Screenshot Response Delay (in sec)'),
            subtitle: Text(
              'Delay in receiving the screenshot, so that you may get expected image after a slide change',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            isThreeLine: true,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: _DelaySlider(
              (value) {
                ref.read(settings).delayTime = value;
                settingsClass.saveSettings();
                ref.read(server.notifier).send(settingsClass.encodeServer());
              },
              max: 1,
              min: 0,
              value: settingsInstance.delayTime,
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Mouse Sensitivity'),
            subtitle: _DelaySlider(
              (value) {
                settingsInstance.mouseSensitivity = value;
              },
              min: 0.1,
              max: 10,
              value: settingsInstance.mouseSensitivity,
            ),
          ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.refresh_rounded),
              iconColor: Colors.redAccent,
              title: const Text('Reset Saved Settings'),
              textColor: Colors.redAccent,
              onTap: () async {
                await ref.read(server.notifier).disconnect();
                await settingsClass.clearSettings();
                await ref.read(remoteButtons.notifier).loadButtons();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }),
          const Divider(),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _DelaySlider extends StatefulWidget {
  _DelaySlider(
    this.onChange, {
    required this.min,
    required this.max,
    this.value,
  });
  double min, max;
  double? value;
  void Function(double value) onChange;

  @override
  State<_DelaySlider> createState() => _DelaySliderState();
}

class _DelaySliderState extends State<_DelaySlider> {
  @override
  void initState() {
    super.initState();
    delayTime = widget.value ?? (widget.max + widget.min) / 2;
  }

  double delayTime = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Slider(
          label: 'Delay Time',
          value: delayTime,
          min: widget.min,
          max: widget.max,
          onChanged: (value) {
            setState(() {
              delayTime = value;
            });
          },
          onChangeEnd: (value) => widget.onChange(value),
        ),
        Text(delayTime.toStringAsFixed(2)),
      ],
    );
  }
}

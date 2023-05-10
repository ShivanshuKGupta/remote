import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote/providers/server.dart';

import 'package:remote/providers/settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
              title: const Text('Dark Mode'),
              value: ref.watch(settings).darkMode,
              onChanged: (value) {
                ref.read(settings).darkMode = value;
                ref.read(settings.notifier).notifyListeners();
                ref
                    .read(server.notifier)
                    .send(ref.read(settings.notifier).toString());
              }),
          const Divider(),
          SwitchListTile(
              title: const Text('Receive Image'),
              value: ref.watch(settings).receiveImage,
              onChanged: (value) {
                ref.read(settings).receiveImage = value;
                ref.read(settings.notifier).notifyListeners();
                ref
                    .read(server.notifier)
                    .send(ref.read(settings.notifier).toString());
              }),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 17.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Response Delay',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const DelaySlider(),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class DelaySlider extends ConsumerStatefulWidget {
  const DelaySlider({super.key});

  @override
  ConsumerState<DelaySlider> createState() => _DelaySliderState();
}

class _DelaySliderState extends ConsumerState<DelaySlider> {
  @override
  void initState() {
    super.initState();
    delayTime = ref.read(settings).delayTime;
  }

  double delayTime = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Slider(
          label: 'Delay Time',
          value: delayTime,
          min: 0,
          max: 1,
          onChanged: (value) {
            setState(() {
              delayTime = value;
            });
          },
          onChangeEnd: (value) {
            ref.read(settings).delayTime = value;
            ref.read(settings.notifier).saveSettings();
            ref
                .read(server.notifier)
                .send(ref.read(settings.notifier).toString());
          },
        ),
        Text("${delayTime.toStringAsFixed(2)} secs"),
      ],
    );
  }
}

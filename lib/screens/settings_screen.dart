import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote/providers/server.dart';

import 'package:remote/providers/settings.dart';

import '../providers/remote_buttons.dart';

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
              subtitle: Text(
                'Reduce Glare',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
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
              isThreeLine: true,
              subtitle: Text(
                'This disables the screenshot receiving feature, can improve performance',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              value: ref.watch(settings).receiveImage,
              onChanged: (value) {
                ref.read(settings).receiveImage = value;
                ref.read(settings.notifier).notifyListeners();
                ref
                    .read(server.notifier)
                    .send(ref.read(settings.notifier).toString());
              }),
          const Divider(),
          ListTile(
            title: const Text('Response Delay'),
            subtitle: Text(
              'Delay in receiving the screenshot, so that you may get expected image after a slide change',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            isThreeLine: true,
          ),
          const _DelaySlider(),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.refresh_rounded),
              iconColor: Colors.redAccent,
              title: const Text('Reset Saved Settings'),
              textColor: Colors.redAccent,
              onTap: () async {
                await ref.read(server.notifier).disconnect();
                await ref.read(settings.notifier).clearSettings();
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

class _DelaySlider extends ConsumerStatefulWidget {
  const _DelaySlider({super.key});

  @override
  ConsumerState<_DelaySlider> createState() => _DelaySliderState();
}

class _DelaySliderState extends ConsumerState<_DelaySlider> {
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

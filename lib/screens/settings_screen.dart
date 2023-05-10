import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              }),
          const Divider(),
          SwitchListTile(
              title: const Text('Receive Image'),
              value: ref.watch(settings).receiveImage,
              onChanged: (value) {
                ref.read(settings).receiveImage = value;
                ref.read(settings.notifier).notifyListeners();
              }),
        ],
      ),
    );
  }
}

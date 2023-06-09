import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote/providers/settings.dart';
import 'package:remote/screens/main_drawer.dart';
import 'package:remote/screens/connection_screen.dart';
import 'package:remote/widgets/pc_screen.dart';
import 'package:remote/providers/server.dart';
import 'package:remote/widgets/remote_buttons.dart';

import '../tools/tools.dart';
import '../widgets/touchpad.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0),
        title: Text(ref.watch(server) == null ? 'Connect' : 'Remote',
            style: Theme.of(context).textTheme.titleLarge),
        actions: [
          if (ref.watch(server) != null)
            IconButton(
              tooltip: 'Mouse mode',
              onPressed: () {
                ref.read(settings).mouseMode = !ref.read(settings).mouseMode;
                ref.read(settings.notifier).notifyListeners();
                ref.read(server.notifier).keyboard('');
              },
              color: ref.watch(settings).mouseMode
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              icon: Icon(ref.read(settings).mouseMode
                  ? Icons.mouse_rounded
                  : Icons.mouse_outlined),
            ),
          if (ref.watch(server) != null)
            IconButton(
              tooltip: 'Reload Image',
              onPressed: () {
                ref.read(server.notifier).keyboard('');
              },
              icon: const Icon(Icons.refresh_rounded),
            ),
          if (ref.watch(server) != null)
            IconButton(
              tooltip: 'Disconnect',
              onPressed: () {
                ref.read(server.notifier).disconnect().then((value) {
                  if (!value) {
                    showMsg(context, "Error disconnecting");
                    return;
                  }
                  showMsg(context, 'Disconnected');
                });
              },
              color: Colors.red,
              icon: const Icon(Icons.close_rounded),
            ),
        ],
      ),
      drawer: const Drawer(child: MainDrawer()),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Show quick buttons bar',
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        child: const Icon(Icons.border_outer_outlined),
        onPressed: () {
          showModalBottomSheet(
              constraints: const BoxConstraints(maxHeight: 150),
              context: context,
              enableDrag: true,
              useSafeArea: true,
              isDismissible: true,
              builder: (context) {
                return RemoteButtons();
              });
        },
      ),
      body: ref.watch(server) == null
          ? ServerScreen()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: PcScreen(),
                      ),
                      TouchPad(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

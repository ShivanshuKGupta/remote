import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote/screens/main_drawer.dart';
import 'package:remote/screens/server_screen.dart';
import 'package:remote/widgets/pc_screen.dart';
import 'package:remote/providers/server.dart';
import 'package:remote/widgets/remote_buttons.dart';

import '../tools/tools.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0),
        title: ref.watch(server) == null
            ? const Text('Connect')
            : const Text('Remote'),
        actions: [
          if (ref.watch(server) != null)
            IconButton(
              onPressed: () {
                ref.read(server.notifier).keyboard('');
              },
              icon: const Icon(Icons.refresh_rounded),
            ),
          if (ref.watch(server) != null)
            IconButton(
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
      body: ref.watch(server) == null
          ? ServerScreen()
          : Column(
              children: [
                PcScreen(),
                RemoteButtons(),
              ],
            ),
    );
  }
}

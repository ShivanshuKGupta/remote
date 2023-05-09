import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote/screens/main_drawer.dart';
import 'package:remote/widgets/pc_screen.dart';
import 'package:remote/providers/server.dart';
import 'package:remote/widgets/remote_buttons.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0),
        title: const Text('Remote'),
        actions: [
          IconButton(
              onPressed: ref.watch(server) == null
                  ? null
                  : () {
                      ref.read(server.notifier).bttn('');
                    },
              icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      drawer: const Drawer(child: MainDrawer()),
      body: Column(
        children: [
          PcScreen(),
          RemoteButtons(),
        ],
      ),
    );
  }
}

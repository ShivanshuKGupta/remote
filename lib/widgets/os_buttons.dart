import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/server.dart';

class OsButtons extends ConsumerWidget {
  const OsButtons({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OS Buttons'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            childAspectRatio: 3,
            mainAxisExtent: 50,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          children: [
            ElevatedButton.icon(
              onPressed: ref.read(server) == null
                  ? null
                  : () {
                      ref.read(server.notifier).os('echo Hello World');
                    },
              icon: const Icon(
                Icons.abc,
              ),
              label: const Text(
                'echo Hello World',
              ),
            ),
            ElevatedButton.icon(
              onPressed: ref.read(server) == null
                  ? null
                  : () {
                      ref.read(server.notifier).custom('lock');
                    },
              icon: const Icon(
                Icons.lock_rounded,
                color: Colors.blue,
              ),
              label: const Text(
                'lock',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            ElevatedButton.icon(
              onPressed: ref.read(server) == null
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      ref.read(server.notifier).os('shutdown /s');
                    },
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.red,
              ),
              label: const Text(
                'ShutDown',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

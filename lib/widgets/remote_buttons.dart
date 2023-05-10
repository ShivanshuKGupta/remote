import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote/tools/tools.dart';

import '../providers/settings.dart';
import '../providers/server.dart';

class RemoteButtons extends ConsumerWidget {
  RemoteButtons({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: ref.watch(server) == null
                              ? null
                              : () => ref.read(server.notifier).keyboard('esc'),
                          child: const Text('esc')),
                      IconButton(
                        onPressed: ref.watch(server) == null
                            ? null
                            : () => ref.read(server.notifier).keyboard('up'),
                        icon: const Icon(Icons.arrow_drop_up),
                      ),
                      TextButton(
                          onPressed: ref.watch(server) == null
                              ? null
                              : () =>
                                  ref.read(server.notifier).keyboard('ctrl+f5'),
                          child: const Text('ctrl+F5')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: ref.watch(server) == null
                            ? null
                            : () => ref.read(server.notifier).keyboard('left'),
                        icon: const Icon(Icons.arrow_left),
                      ),
                      TextButton(
                          onPressed: ref.watch(server) == null
                              ? null
                              : () => ref.read(server.notifier).keyboard('f5'),
                          child: const Text('F5')),
                      IconButton(
                        onPressed: ref.watch(server) == null
                            ? null
                            : () => ref.read(server.notifier).keyboard('right'),
                        icon: const Icon(Icons.arrow_right),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: ref.watch(server) == null
                        ? null
                        : () => ref.read(server.notifier).keyboard('down'),
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

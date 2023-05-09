import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote/tools/tools.dart';

import '../providers/settings.dart';
import '../providers/server.dart';

class RemoteButtons extends ConsumerWidget {
  TextEditingController serverAddr = TextEditingController();
  TextEditingController portNo = TextEditingController();

  RemoteButtons({super.key});

  @override
  Widget build(BuildContext context, ref) {
    print("Build function of remote buttons called");
    serverAddr.text = ref.watch(settings).serverAddr;
    portNo.text = ref.watch(settings).portNo;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: serverAddr,
            enabled: ref.watch(server) == null,
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: const InputDecoration(
                label: Text('Enter Server Address'), alignLabelWithHint: true),
          ),
          TextField(
            style: Theme.of(context).textTheme.bodyLarge,
            keyboardType: TextInputType.number,
            controller: portNo,
            enabled: ref.watch(server) == null,
            decoration: const InputDecoration(
                hintText: '8080', label: Text('Enter Port Number')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: ref.watch(server) != null
                        ? null
                        : () {
                            try {
                              ref.read(settings.notifier).state.serverAddr =
                                  serverAddr.text;
                              ref.read(settings.notifier).state.portNo =
                                  portNo.text;
                              ref.read(settings.notifier).saveSettings();
                              ref
                                  .read(server.notifier)
                                  .connect(serverAddr.text, portNo.text)
                                  .then((connected) {
                                if (connected != null) {
                                  showMsg(
                                      context,
                                      connected
                                          ? 'Connected'
                                          : 'Connection Failed :-(');
                                } else {}
                              });
                            } catch (e) {
                              showMsg(context, e.toString());
                            }
                          },
                    child: const Text('Connect')),
                ElevatedButton(
                    onPressed: ref.watch(server) == null
                        ? null
                        : () {
                            ref
                                .read(server.notifier)
                                .disconnect()
                                .then((value) {
                              if (!value) {
                                showMsg(context, "Error disconnecting");
                                return;
                              }
                              showMsg(context, 'Disconnected');
                            });
                          },
                    child: const Text('Disconnect')),
              ],
            ),
          ),
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
                              : () => ref.read(server.notifier).bttn('esc'),
                          child: const Text('esc')),
                      IconButton(
                        onPressed: ref.watch(server) == null
                            ? null
                            : () => ref.read(server.notifier).bttn('up'),
                        icon: const Icon(Icons.arrow_drop_up),
                      ),
                      TextButton(
                          onPressed: ref.watch(server) == null
                              ? null
                              : () => ref.read(server.notifier).bttn('ctrl+f5'),
                          child: const Text('ctrl+F5')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: ref.watch(server) == null
                            ? null
                            : () => ref.read(server.notifier).bttn('left'),
                        icon: const Icon(Icons.arrow_left),
                      ),
                      TextButton(
                          onPressed: ref.watch(server) == null
                              ? null
                              : () => ref.read(server.notifier).bttn('f5'),
                          child: const Text('F5')),
                      IconButton(
                        onPressed: ref.watch(server) == null
                            ? null
                            : () => ref.read(server.notifier).bttn('right'),
                        icon: const Icon(Icons.arrow_right),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: ref.watch(server) == null
                        ? null
                        : () => ref.read(server.notifier).bttn('down'),
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

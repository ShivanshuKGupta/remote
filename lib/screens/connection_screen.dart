import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/server.dart';
import '../providers/settings.dart';
import '../tools/tools.dart';

class ServerScreen extends ConsumerStatefulWidget {
  const ServerScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServerScreenState();
}

class _ServerScreenState extends ConsumerState<ServerScreen> {
  final TextEditingController _serverAddr = TextEditingController();
  final TextEditingController _portNo = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final settingsObj = ref.watch(settings);
    final settingsClass = ref.watch(settings.notifier);
    _serverAddr.text = settingsObj.serverAddr;
    _portNo.text = settingsObj.portNo;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _serverAddr,
              // enabled: ref.watch(server) == null,
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(
                  hintText: "eg, 192.168.10.74",
                  label: Text('Enter Server Address'),
                  alignLabelWithHint: true),
            ),
            TextField(
              style: Theme.of(context).textTheme.bodyLarge,
              keyboardType: TextInputType.number,
              controller: _portNo,
              // enabled: ref.watch(server) == null,
              decoration: const InputDecoration(
                  hintText: 'eg, 8080', label: Text('Enter Port Number')),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton.icon(
              onPressed: ref.watch(server) != null || _isLoading
                  ? null
                  : () {
                      setState(() => _isLoading = true);
                      try {
                        ref.read(settings).serverAddr = _serverAddr.text;
                        ref.read(settings).portNo = _portNo.text;
                        ref.read(settings.notifier).saveSettings();
                        ref
                            .read(server.notifier)
                            .connect(_serverAddr.text, _portNo.text)
                            .then((connected) {
                          if (connected != null) {
                            showMsg(context,
                                connected ? 'Connected' : 'Connection Failed',
                                icon: Icon(
                                  connected
                                      ? Icons.check_rounded
                                      : Icons.close_rounded,
                                  color: connected ? Colors.green : Colors.red,
                                ));
                            setState(() => _isLoading = false);
                          }
                          ref
                              .read(server.notifier)
                              .send(ref.read(settings.notifier).encodeServer());
                        });
                      } catch (e) {
                        showMsg(context, e.toString(),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.red,
                            ));
                        setState(() => _isLoading = false);
                      }
                    },
              icon: const Icon(Icons.wifi),
              label: _isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Connect'),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 35)),
              onPressed: () {
                settingsObj.manuallyConnect = false;
                settingsClass.notifyListeners();
              },
              child: const Text(
                "Don't know the ip address?\nScan instead",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote/providers/scan_service.dart';
import 'package:remote/providers/server.dart';
import 'package:remote/providers/settings.dart';
import 'package:remote/tools/tools.dart';
import 'package:remote/widgets/loading_elevated_button.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  ScanService? scanService;
  DeviceInfo? deviceInfo;

  @override
  void initState() {
    super.initState();
    getIPAddresses().then((addresses) {
      addresses.retainWhere((addr) => addr.startsWith('192'));
      if (addresses.isNotEmpty) {
        deviceInfo = DeviceInfo(
          InternetAddress(addresses[0]),
          8079,
          name: 'Android123',
          platform: 'Android',
        );
        scanService = ScanService(deviceInfo: deviceInfo!);
        setState(() {}); // to update the ip address shown
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsObj = ref.read(settings);
    deviceInfo?.name = settingsObj.deviceName;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device Name: ${settingsObj.deviceName}'),
            Text(
              deviceInfo == null
                  ? "No Connection"
                  : '${scanService?.socket?.address.address}:${scanService?.socket?.port}',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      ),
      body: Column(
        children: [
          if (scanService != null)
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: scanService!.devices,
                builder: (context, devices, child) {
                  debugPrint("List Updated");
                  return ListView(
                      children: devices
                          .map<Widget>(
                            (device) => ListTile(
                              onTap: () async {
                                scanService?.stopScanning();
                                try {
                                  final serverInfo =
                                      await sendConnectionRequest(
                                          scanService!.socket!, device);
                                  if (serverInfo == null) return;
                                  debugPrint(
                                      "Connection Request Accepted! Connecting to ${serverInfo.encode()}");
                                  ref
                                      .read(server.notifier)
                                      .connect(serverInfo.ipAddr.address,
                                          serverInfo.port.toString())
                                      .then((connected) {
                                    if (connected != null) {
                                      showMsg(
                                          context,
                                          connected
                                              ? 'Connected'
                                              : 'Connection Failed',
                                          icon: Icon(
                                            connected
                                                ? Icons.check_rounded
                                                : Icons.close_rounded,
                                            color: connected
                                                ? Colors.green
                                                : Colors.red,
                                          ));
                                    }
                                    ref.read(server.notifier).send(ref
                                        .read(settings.notifier)
                                        .encodeServer());
                                  });
                                } catch (e) {
                                  showMsg(context, e.toString(),
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        color: Colors.red,
                                      ));
                                }
                              },
                              title: Text(
                                  "${device.name ?? 'Unknown'}(${device.platform ?? 'Linux'})"),
                              subtitle: Text("${device.ipAddr}:${device.port}"),
                            ),
                          )
                          .toList()
                        ..add(
                          Center(
                            child: ValueListenableBuilder(
                              valueListenable: scanService!.scanning,
                              builder: (context, status, child) {
                                return status
                                    ? circularProgressIndicator()
                                    : Container();
                              },
                            ),
                          ),
                        ));
                },
              ),
            ),
          Wrap(
            children: [
              if (scanService != null)
                ValueListenableBuilder(
                  valueListenable: scanService!.scanning,
                  builder: (context, value, child) => LoadingElevatedButton(
                    enabled: !value,
                    icon: const Icon(Icons.search_rounded),
                    label: const Text('Start Scanning'),
                    onPressed: () async {
                      scanService?.startScanning();
                    },
                  ),
                ),
              if (scanService != null)
                ValueListenableBuilder(
                  valueListenable: scanService!.scanning,
                  builder: (context, value, child) => LoadingElevatedButton(
                    enabled: value,
                    icon: const Icon(Icons.stop_rounded),
                    label: const Text('Stop Scanning'),
                    onPressed: () async {
                      scanService?.stopScanning();
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

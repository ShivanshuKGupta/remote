import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote/providers/scan_service.dart';
import 'package:remote/providers/server.dart';
import 'package:remote/providers/settings.dart';
import 'package:remote/screens/main_drawer.dart';
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
        scanService!
            .createSocket()
            .then((value) => scanService!.startScanning());
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
        title: ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (rect) {
            return const LinearGradient(
                    colors: [Colors.deepPurpleAccent, Colors.blue])
                .createShader(rect);
          },
          child: Text(
            'Remote',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      drawer: const Drawer(child: MainDrawer()),
      floatingActionButton: scanService == null
          ? null
          : ValueListenableBuilder(
              valueListenable: scanService!.scanning,
              builder: (ctx, value, child) => LoadingElevatedButton(
                enabled: scanService != null,
                style: ElevatedButton.styleFrom(
                    foregroundColor: value ? Colors.red : null),
                icon: Icon(value ? Icons.stop_rounded : Icons.search_rounded),
                label: Text(value ? 'Stop' : 'Scan'),
                onPressed: () async {
                  if (value) {
                    scanService?.stopScanning();
                  } else {
                    scanService?.startScanning();
                  }
                },
              ),
            ),
      body: (scanService == null)
          ? null
          : ValueListenableBuilder(
              valueListenable: scanService!.devices,
              builder: (ctx, devices, child) {
                debugPrint("List Updated");
                return ListView(
                  children: devices
                      .map<Widget>(
                        (device) => ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                          ),
                          onTap: () async {
                            if (await askUser(
                                  context,
                                  "Do you want to connect to this device?",
                                  description:
                                      "Name: ${device.name ?? 'Unknown'}\nPlatform: ${device.platform ?? 'Unknown'}\nIP address: ${device.ipAddr.address}\nPort:${device.port}",
                                  yes: true,
                                  cancel: true,
                                ) !=
                                'yes') return;
                            scanService?.stopScanning();
                            try {
                              final serverInfo = await sendConnectionRequest(
                                  scanService!.socket!, device);
                              if (serverInfo == null) {
                                showMsg(context, "Connection refused by server",
                                    icon: const Icon(Icons.close_rounded));
                                return;
                              }
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
                                ref.read(server.notifier).send(
                                    ref.read(settings.notifier).encodeServer());
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
                          leading: Icon(
                              ['Windows', 'Linux'].contains(device.platform)
                                  ? Icons.laptop_rounded
                                  : Icons.compass_calibration_rounded),
                        ),
                      )
                      .toList()
                    ..add(
                      Center(
                        child: ValueListenableBuilder(
                          valueListenable: scanService!.scanning,
                          builder: (context, status, child) {
                            return status
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        circularProgressIndicator(),
                                        if (child != null) child,
                                      ],
                                    ),
                                  )
                                : Container();
                          },
                          child: TextButton(
                            onPressed: () {
                              scanService?.stopScanning();
                              settingsObj.manuallyConnect = true;
                              ref.watch(settings.notifier).notifyListeners();
                            },
                            child: const Text(
                              'Can\'t find your device?\nConnect Manually',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    )
                    ..insertAll(
                      0,
                      [
                        Card(
                          margin: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Device Name: ${settingsObj.deviceName}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  deviceInfo == null
                                      ? "No Connection"
                                      : '${scanService?.socket?.address.address}:${scanService?.socket?.port}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            bottom: 10,
                          ),
                          child: Text(
                            'Available Devices',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                );
              },
            ),
    );
  }
}

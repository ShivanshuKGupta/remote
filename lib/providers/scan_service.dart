import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

/// Returns all ip addresses
Future<List<String>> getIPAddresses() async {
  final interfaces = await NetworkInterface.list();
  interfaces.retainWhere((interface) =>
      interface.addresses.any((addr) => addr.type == InternetAddressType.IPv4));
  return interfaces
      .map((interface) => interface.addresses
          .firstWhere((addr) => addr.type == InternetAddressType.IPv4)
          .address)
      .toList();
}

/// A class to store device info
class DeviceInfo {
  InternetAddress ipAddr;
  String? name;
  String? platform;
  int port;
  DeviceInfo(this.ipAddr, this.port, {this.name, this.platform});
  Map<String, dynamic> encode() {
    return {
      "ip": ipAddr.address,
      "port": port,
      "name": name,
    };
  }
}

/// Sends a msg to a device
Future<void> sendMessage(RawDatagramSocket socket, Map<String, dynamic> message,
    InternetAddress address, int port) async {
  final messageBytes = utf8.encode(json.encode(message));
  debugPrint("Sending msg: '$message' to ${address.address}:$port");
  socket.send(messageBytes, address, port);
}

/// Sends a msg to a device
Future<void> sendBroadcastMessage(
    RawDatagramSocket socket, Map<String, dynamic> message, int port) async {
  /// Finding Broadcast Address
  final host = socket.address.address;
  final broadcastAddress = InternetAddress(
      host.replaceRange(host.lastIndexOf('.') + 1, null, '255'));

  final messageBytes = utf8.encode(json.encode(message));
  debugPrint("Sending msg: '$message' to ${broadcastAddress.address}:$port");
  socket.send(messageBytes, broadcastAddress, port);
}

Future<DeviceInfo?> sendConnectionRequest(
    RawDatagramSocket socket, DeviceInfo deviceInfo) async {
  await sendMessage(
      socket,
      deviceInfo.encode()
        ..addAll({
          "action": 'connect',
        }),
      deviceInfo.ipAddr,
      deviceInfo.port);
  Datagram? ack;
  int k = 10;
  for (int i = 0;
      i < k;
      ++i, await Future.delayed(Duration(milliseconds: 5000 ~/ k))) {
    do {
      ack = socket.receive();
      if (ack != null) {
        final Map<String, dynamic> serverData =
            json.decode(utf8.decode(ack.data));
        final serverAddress = ack.address;
        final serverPort = ack.port;
        debugPrint(
            "Received msg: '$serverData' from $serverAddress:$serverPort");
        debugPrint("action: ${serverData['action']}");
        if (serverData['action'] == 'accept') {
          return DeviceInfo(
              InternetAddress(serverData['ip']), serverData['port']);
        }
      }
    } while (ack != null);
  }
  return null;
}

class ScanService {
  RawDatagramSocket? socket;
  ValueNotifier<List<DeviceInfo>> devices = ValueNotifier([]);
  ValueNotifier<bool> scanning = ValueNotifier(false);

  /// Device Info of the Client
  DeviceInfo deviceInfo;

  ScanService({required this.deviceInfo}) {
    scanning.addListener(_scan);
  }

  Future<void> createSocket() async {
    socket ??= await RawDatagramSocket.bind(deviceInfo.ipAddr.address, 0);
    socket?.broadcastEnabled = true;
  }

  void startScanning() {
    assert(socket != null);
    debugPrint("Scanning Started");
    scanning.value = true;
  }

  void stopScanning() {
    scanning.value = false;
    debugPrint("Scanning Stopped");
  }

  void closeSocket() {
    stopScanning();
    socket?.close();
    socket = null;
  }

  void _scan() async {
    /// Finding Broadcast Address
    // final host = deviceInfo.ipAddr.address;
    // final broadcastAddress = InternetAddress(
    //     host.replaceRange(host.lastIndexOf('.') + 1, null, '255'));

    /// Sending broadcast msg
    while (scanning.value == true && socket != null) {
      sendBroadcastMessage(
          socket!,
          deviceInfo.encode()
            ..addAll({
              "action": 'discovery',
            }),
          deviceInfo.port);
      Datagram? ack;
      int k = 10;
      for (int i = 0;
          i < k && scanning.value == true;
          ++i, await Future.delayed(Duration(milliseconds: 1000 ~/ k))) {
        do {
          ack = socket?.receive();
          if (ack != null) {
            final Map<String, dynamic> serverData =
                json.decode(utf8.decode(ack.data));
            final serverAddress = ack.address;
            final serverPort = ack.port;
            debugPrint(
                "Received msg: '$serverData' from $serverAddress:$serverPort");
            if ((devices.value.any((device) =>
                    device.ipAddr == serverAddress &&
                    device.port == serverPort)) ==
                true) continue;
            List<DeviceInfo> newList = devices.value.map((e) => e).toList();
            newList.add(
              DeviceInfo(
                serverAddress,
                serverPort,
                name: serverData['name'],
                platform: serverData['platform'],
              ),
            );
            devices.value = newList;
          }
        } while (ack != null && scanning.value == true);
      }
    }
  }
}

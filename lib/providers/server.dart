import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote/widgets/pc_screen.dart';

class _Server extends StateNotifier<Socket?> {
  _Server() : super(null);
  Uint8List imageBytes = Uint8List(0);
  Image? image;

  Future<bool?> connect(String addr, String portNo) async {
    if (state != null) disconnect();
    try {
      await Socket.connect(addr, int.parse(portNo)).then((value) {
        print("Connection to $addr successful.");
        state = value;
        state!.listen((Uint8List data) {
          if (data.isEmpty) return;
          String decodedData = utf8.decode(data);
          if (decodedData.isEmpty) return;
          List<String> splittedData = decodedData.split("'");
          if (splittedData.length == 1) {
            imageBytes = add(imageBytes, base64.decode(splittedData[0]));
          } else {
            int n = splittedData.length;
            for (int i = 0; i < n - 1; ++i) {
              if (splittedData[i].isNotEmpty) {
                imageBytes = add(imageBytes, base64.decode(splittedData[i]));
                image = Image.memory(imageBytes);
                imageBytes = Uint8List(0);
                setImage!(image!);
              }
            }
            imageBytes = splittedData[n - 1].isNotEmpty
                ? base64.decode(splittedData[n - 1])
                : Uint8List(0);
          }
        });
        return true;
      });
    } catch (e) {
      print('connection error: $e');
      state = null;
      return false;
    }
    return true;
  }

  String receiveString() {
    String message = "-1";
    try {
      state?.listen((List<int> data) {
        message = String.fromCharCodes(data);
        print('Received: $message');
      });
    } catch (e) {
      print('Error receiving from server: $e');
    }
    return message;
  }

  bool isReceiving = false;
  Uint8List add(Uint8List a, Uint8List b) {
    var ans = BytesBuilder();
    if (a.length > 1) ans.add(a);
    ans.add(b);
    return ans.toBytes();
  }

  bool send(String message) {
    try {
      state?.write(message);
    } catch (e) {
      print('Error sending to server: $e');
      return false;
    }
    return true;
  }

  void keyboard(String key) => send("${json.encode({"keyboard": key})};");
  void os(String cmd) => send("${json.encode({"os": cmd})};");
  void custom(String cmd) => send("${json.encode({"custom": cmd})};");
  void mouse(double x, double y, {String? click}) {
    if (x != double.infinity && y != double.infinity) {
      send("${json.encode(
        {
          "mouse": json.encode({
            "x": x,
            "y": y,
            if (click != null) "click": click,
          }),
        },
      )};");
    }
  }

  Future<bool> disconnect() async {
    if (state == null) return false;
    await state!.close();
    state = null;
    image = null;
    Uint8List tmp = Uint8List(1);
    imageBytes = tmp;
    return true;
  }
}

final server = StateNotifierProvider<_Server, Socket?>((ref) => _Server());

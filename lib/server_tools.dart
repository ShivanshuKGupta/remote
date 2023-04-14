import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class Server {
  Socket? socket;
  Uint8List? imageBytes;
  Image? image;

  void connect(String addr) {
    try {
      Socket.connect(addr, 8080).then((value) {
        socket = value;
      });
    } catch (e) {
      print('connection error: $e');
    }
  }

  String receiveString() {
    String message = "-1";
    try {
      socket?.listen((List<int> data) {
        message = String.fromCharCodes(data);
        print('Received: $message');
      });
    } catch (e) {
      print('Error receiving from server: $e');
    }
    return message;
  }

  void receiveImage() {
    try {
      while (true) {
        socket?.listen((data) {
          print('listen is called');
          imageBytes = base64.decode(utf8.decode(data));
          image = Image.memory(imageBytes!);
        });
      }
    } catch (e) {
      if (imageBytes != null) {
        print('ImageBytes: $imageBytes');
        image = Image.memory(imageBytes!);
      } else {
        print('error receiving image: $e');
      }
    }
  }

  bool send(String message) {
    try {
      socket?.write(message);
    } catch (e) {
      print('Error sending to server: $e');
      return false;
    }
    return true;
  }

  void disconnect() {
    socket?.close();
  }
}

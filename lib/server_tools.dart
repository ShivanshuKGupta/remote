import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:remote/home_screen.dart';

class Server {
  Socket? socket;
  Uint8List? imageBytes;
  Image? image;

  void connect(String addr) {
    if (socket != null) disconnect();
    try {
      Socket.connect(addr, 8080).then((value) {
        print("Connection to $value successful.");
        socket = value;
        refresh!();
      });
    } catch (e) {
      print('connection error: $e');
      socket = null;
      refresh!();
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
        print("Trying to listen");
        socket?.listen((data) {
          print('listen is called');
          imageBytes = base64.decode(utf8.decode(data));
          image = Image.memory(imageBytes!);
          refresh!();
        });
      }
    } catch (e) {
      print('error receiving image: $e');
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
    socket = null;
    refresh!();
  }
}

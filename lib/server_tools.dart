import 'dart:ffi';
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
        // print("Connection to $value successful.");
        socket = value;
        refresh!();
      });
    } catch (e) {
      // print('connection error: $e');
      socket = null;
      refresh!();
    }
  }

  String receiveString() {
    String message = "-1";
    try {
      socket?.listen((List<int> data) {
        message = String.fromCharCodes(data);
        // print('Received: $message');
      });
    } catch (e) {
      // print('Error receiving from server: $e');
    }
    return message;
  }

  bool isReceiving = false;
  void receiveImage() {
    try {
      while (true) {
        // print("Trying to listen");
        socket?.listen((data) {
          // print('listen is called');
          // print('packet received: ${utf8.decode(data)}');
          String decodedData = utf8.decode(data);
          List<String> splittedData = decodedData.split("'");
          if (!isReceiving) {
            isReceiving = true;
            decodedData = splittedData[1];
          } else if (decodedData.contains("'")) {
            isReceiving = false;
            decodedData = splittedData[0];
          }
          if (imageBytes != null) {
            var b = BytesBuilder();
            Uint8List l1 = imageBytes!;
            Uint8List l2 = base64.decode(decodedData);
            b.add(l1);
            b.add(l2);
            imageBytes = b.toBytes();
          } else {
            imageBytes = base64.decode(decodedData);
          }
          if (!isReceiving) {
            // print('Got an image fully!!');
            image = Image.memory(imageBytes!);
            imageBytes = null;
            refresh!();
            if (splittedData.length > 1) {
              // print("Got two images in one packet :-(");
              imageBytes = base64.decode(splittedData[1]);
            }
          }
          // if (isReceiving) {
          //   // print("Got length.");
          //   firstPacket = false;
          //   // // print("Package Value: ${utf8.decode(data)}");
          //   final packets = utf8.decode(data).split("'");
          //   dataLen = int.parse(packets[1]);
          //   // print("Length of packet: $dataLen");
          //   imageBytes = base64.decode(packets[2]);
          //   // print("Initial length: ${imageBytes?.length}");
          // } else {
          //   // print("Got another package.");
          //   // imageBytes?.addAll(base64.decode(utf8.decode(data)));
          // var b = BytesBuilder();
          // Uint8List l1 = imageBytes!;
          // Uint8List l2 = base64.decode(utf8.decode(data));
          // b.add(l1);
          // b.add(l2);
          // imageBytes = b.toBytes();

          //   Uint8List encodeData = base64.decode(utf8.decode(data));
          //   Uint8List concatenatedList =
          //       Uint8List(imageBytes!.length + encodeData.length);
          //   concatenatedList.setRange(0, imageBytes!.length, imageBytes!);
          //   concatenatedList.setRange(
          //       imageBytes!.length, concatenatedList.length, encodeData);
          //   imageBytes = concatenatedList;
          //   // print("Now the length becomes: ${imageBytes?.length}");
          // }
          // image = Image.memory(imageBytes!);
          // refresh!();
        });
      }
    } catch (e) {
      // print("Server stopped sending packets");
      // if (imageBytes != null) {
      //   firstPacket = true;
      //   // print('Got an image fully!!');
      //   image = Image.memory(imageBytes!);
      //   imageBytes = null;
      //   refresh!();
      //   // break;
      // } else {
      // print('error receiving image: $e');
      // }
    }
    // print('Ending receive');
  }

  bool send(String message) {
    try {
      socket?.write(message);
    } catch (e) {
      // print('Error sending to server: $e');
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

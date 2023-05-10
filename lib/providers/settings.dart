import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Settings {
  bool darkMode = false;
  bool receiveImage = true;
  String serverAddr = "";
  String portNo = "";
  double delayTime = 0.1;
}

class _SettingsProvider extends StateNotifier<_Settings> {
  _SettingsProvider() : super(_Settings()) {
    loadSettings();
  }

  String encode() {
    return json.encode({
      "darkMode": state.darkMode,
      "receiveImage": state.receiveImage,
      "serverAddr": state.serverAddr,
      "portNo": state.portNo,
      "delayTime": state.delayTime,
    });
  }

  void decodeAndSet(String setStr) {
    final settings = json.decode(setStr);
    state.darkMode = settings["darkMode"] ?? false;
    state.receiveImage = settings["receiveImage"] ?? true;
    state.serverAddr = settings["serverAddr"] ?? "192.168.";
    state.portNo = settings["portNo"] ?? "8080";
    state.delayTime = settings["delayTime"] ?? 0.1;
  }

  Future<bool> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    decodeAndSet(prefs.getString('settings') ?? "{}");
    // state.darkMode = prefs.getBool('darkMode') ?? false;
    // state.receiveImage = prefs.getBool('receiveImage') ?? true;
    // state.serverAddr = prefs.getString('serverAddr') ?? "192.168.";
    // state.portNo = prefs.getString('portNo') ?? "8080";
    notifyListeners();
    return true;
  }

  Future<bool> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    prefs.setString('settings', encode());
    // prefs.setBool('darkMode', state.darkMode);
    // prefs.setBool('receiveImage', state.receiveImage);
    // prefs.setString('serverAddr', state.serverAddr);
    // prefs.setString('portNo', state.portNo);
    return true;
  }

  void notifyListeners() {
    saveSettings();
    _Settings savedSettings = state;
    state = _Settings();
    state = savedSettings;
  }

  @override
  String toString() {
    return "${json.encode({"settings": encode()})};";
  }
}

final settings = StateNotifierProvider<_SettingsProvider, _Settings>(
    (ref) => _SettingsProvider());

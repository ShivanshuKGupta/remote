import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote/providers/volume_button_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Settings {
  // server settings
  bool receiveImage = true;
  double delayTime = 0.1;

  // app settings
  bool darkMode = false;
  String serverAddr = "";
  String portNo = "";
  bool mouseMode = false;
  bool scrollMode = false;
  bool clicksToKeys = false; // Replaces mouse click to arrow keys in mouse mode
  VolumButtonFunctions volumeButtonFunctions = VolumButtonFunctions.leftRight;
  String deviceName = "Android";
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
      "mouseMode": state.mouseMode,
      "deviceName": state.deviceName,
      "scrollMode": state.scrollMode,
      "clicksToKeys": state.clicksToKeys,
      "volumeButtonFunctions": state.volumeButtonFunctions.index,
    });
  }

  String encodeServer() {
    return json.encode({
      "settings": json.encode({
        "receiveImage": state.receiveImage,
        "delayTime": state.delayTime,
        "deviceName": state.deviceName,
      })
    });
  }

  void decodeAndSet(String setStr) {
    final settings = json.decode(setStr);
    state.darkMode = settings["darkMode"] ?? false;
    state.receiveImage = settings["receiveImage"] ?? false;
    state.serverAddr = settings["serverAddr"] ?? "192.168.";
    state.portNo = settings["portNo"] ?? "8080";
    state.delayTime = settings["delayTime"] ?? 0.1;
    state.mouseMode = settings["mouseMode"] ?? true;
    state.scrollMode = settings["scrollMode"] ?? true;
    state.clicksToKeys = settings["clicksToKeys"] ?? false;
    state.deviceName = settings["deviceName"] ?? state.deviceName;
    state.volumeButtonFunctions =
        VolumButtonFunctions.values[settings["volumeButtonFunctions"] ?? 0];
  }

  Future<bool> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    decodeAndSet(prefs.getString('settings') ?? "{}");
    notifyListeners();
    return true;
  }

  Future<bool> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('settings', encode());
    prefs.setString('deviceName', state.deviceName);
    return true;
  }

  Future<void> clearSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    loadSettings();
  }

  void notifyListeners() {
    saveSettings();
    _Settings savedSettings = state;
    state = _Settings();
    state = savedSettings;
  }
}

final settings = StateNotifierProvider<_SettingsProvider, _Settings>(
    (ref) => _SettingsProvider());

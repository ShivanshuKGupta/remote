import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Settings {
  bool darkMode = false;
  bool receiveImage = true;
  String serverAddr = "";
  String portNo = "";
}

class _SettingsProvider extends StateNotifier<_Settings> {
  _SettingsProvider() : super(_Settings()) {
    loadSettings();
  }

  Future<bool> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state.darkMode = prefs.getBool('darkMode') ?? false;
    state.receiveImage = prefs.getBool('receiveImage') ?? true;
    state.serverAddr = prefs.getString('serverAddr') ?? "192.168.";
    state.portNo = prefs.getString('portNo') ?? "8080";
    notifyListeners();
    return true;
  }

  Future<bool> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    prefs.setBool('darkMode', state.darkMode);
    prefs.setBool('receiveImage', state.receiveImage);
    prefs.setString('serverAddr', state.serverAddr);
    prefs.setString('portNo', state.portNo);
    return true;
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

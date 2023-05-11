import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote/screens/customize_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

IconData? morph(String bttn) {
  switch (bttn) {
    case 'volumeup':
      return Icons.volume_up_rounded;
    case 'volumedown':
      return Icons.volume_down_rounded;
    case 'volumemute':
      return Icons.volume_mute_rounded;
    case 'add':
      return Icons.add_rounded;
    case 'apps':
      return Icons.apps;
    case 'backspace':
      return Icons.keyboard_backspace_rounded;
    case 'browserfavorites':
      return Icons.star_rounded;
    case 'browserhome':
      return Icons.home_rounded;
    case 'browserrefresh':
      return Icons.refresh_rounded;
    case 'capslock':
      return Icons.abc_rounded;
    case 'clear':
      return Icons.clear;
    case 'del':
      return Icons.delete_rounded;
    case 'delete':
      return Icons.delete_rounded;
    case 'down':
      return Icons.keyboard_arrow_down_rounded;
    case 'end':
      return Icons.keyboard_double_arrow_right_rounded;
    case 'esc':
    case 'escape':
      return Icons.arrow_back_rounded;
    case 'help':
      return Icons.help_rounded;
    case 'home':
      return Icons.keyboard_double_arrow_left_rounded;
    case 'left':
      return Icons.keyboard_arrow_left_rounded;
    // case 'enter':
    //   return Icons.arrow_for;
    // case 'multiply':
    //   return Icons.asteris;
    // case 'divide':
    //   return Icons.divide;
    // case 'subtract':
    //   return Icons.skip_previous_rounded;
    case 'pause':
      return Icons.pause_rounded;
    case 'playpause':
      return Icons.play_arrow_rounded;
    case 'prevtrack':
      return Icons.skip_previous_rounded;
    case 'nexttrack':
      return Icons.skip_next_rounded;
    case 'print':
      return Icons.print_rounded;
    case 'printscreen':
      return Icons.screenshot_monitor_rounded;
    case 'prntscrn':
      return Icons.screenshot_monitor_rounded;
    case 'prtsc':
      return Icons.screenshot_monitor_rounded;
    case 'prtscr':
      return Icons.screenshot_monitor_rounded;
    case 'right':
      return Icons.keyboard_arrow_right_rounded;
    case 'space':
    case ' ':
      return Icons.space_bar_rounded;
    case 'stop':
      return Icons.stop_rounded;
    case 'sleep':
      return Icons.brightness_2_rounded;
    case 'tab':
      return Icons.keyboard_tab_rounded;
    case 'up':
      return Icons.keyboard_arrow_up_rounded;
  }
  return null;
}

class _RemoteButtonsProvider extends StateNotifier<List<String>> {
  _RemoteButtonsProvider() : super([]) {
    loadButtons();
  }

  void toggle(String bttn) {
    List<String> newState = [];
    newState = state;
    state = [];
    if (newState.contains(bttn)) {
      newState.remove(bttn);
    } else {
      newState.add(bttn);
    }
    state = newState;
    saveButtons();
  }

  Future<bool> saveButtons() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('quickBar', state);
    return true;
  }

  Future<bool> loadButtons() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getStringList('quickBar') ??
        allButtonsList.getRange(0, 20).toList();
    return true;
  }
}

final remoteButtons =
    StateNotifierProvider<_RemoteButtonsProvider, List<String>>(
        (ref) => _RemoteButtonsProvider());

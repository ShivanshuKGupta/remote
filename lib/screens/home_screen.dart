import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote/providers/server.dart';
import 'package:remote/providers/settings.dart';
import 'package:remote/screens/connection_screen.dart';
import 'package:remote/screens/main_drawer.dart';
import 'package:remote/widgets/dark_light_mode_button.dart';
import 'package:remote/widgets/pc_screen.dart';
import 'package:remote/widgets/remote_buttons.dart';

import '../tools/tools.dart';
import '../widgets/touchpad.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState {
  bool skipKey = false;
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final serverSettings = ref.watch(server);
    final serverClass = ref.watch(server.notifier);
    final settingsObj = ref.watch(settings);
    final settingsClass = ref.watch(settings.notifier);
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    final mediaQuery = MediaQuery.of(context);
    // final List<String> buttons = ['left', 'right', 'up', 'down', 'home', 'end'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0),
        title: Text(serverSettings == null ? 'Connect to a PC' : '',
            style: Theme.of(context).textTheme.titleLarge),
        actions: [
          if (serverSettings != null)
            IconButton(
              tooltip: "Disconnect",
              onPressed: () async {
                final response = await askUser(
                  context,
                  "Do you really want to disconnect?",
                  yes: true,
                  no: true,
                );
                if (response != "yes") return;
                try {
                  await serverClass.disconnect();
                } catch (e) {
                  if (context.mounted) {
                    showMsg(context, "Error disconnecting");
                  }
                }
                if (context.mounted) {
                  showMsg(context, 'Disconnected');
                }
              },
              style: IconButton.styleFrom(foregroundColor: Colors.red),
              icon: const Icon(Icons.close_rounded),
            ),
          if (serverSettings != null)
            IconButton(
              tooltip: 'Mouse mode',
              onPressed: () {
                settingsObj.mouseMode = !settingsObj.mouseMode;
                settingsObj.scrollMode =
                    !settingsObj.mouseMode ? false : settingsObj.scrollMode;
                showMsg(context,
                    "Mouse mode is ${settingsObj.mouseMode ? 'on' : 'off'} now");
                settingsClass.notifyListeners();
              },
              color: settingsObj.mouseMode
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              icon: Icon(settingsObj.mouseMode
                  ? Icons.mouse_rounded
                  : Icons.mouse_outlined),
            ),
          if (serverSettings != null)
            IconButton(
              tooltip: 'Scroll mode',
              onPressed: () {
                settingsObj.scrollMode = !settingsObj.scrollMode;
                settingsObj.mouseMode =
                    settingsObj.scrollMode ? true : settingsObj.mouseMode;
                showMsg(context,
                    "Scroll mode is ${settingsObj.scrollMode ? 'on' : 'off'} now");
                settingsClass.notifyListeners();
              },
              color: settingsObj.scrollMode
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              icon: Icon(settingsObj.scrollMode
                  ? Icons.swap_vert_circle
                  : Icons.swap_vert_circle_outlined),
            ),
          if (serverSettings != null && settingsObj.receiveImage)
            IconButton(
              tooltip: 'Reload Image',
              onPressed: () {
                serverClass.keyboard('');
              },
              icon: const Icon(Icons.refresh_rounded),
            ),
          const DarkLightModeIconButton(),
        ],
      ),
      drawer: const Drawer(child: MainDrawer()),
      // floatingActionButton: FloatingActionButton(
      //   tooltip: 'Show quick buttons bar',
      //   backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      //   child: const Icon(Icons.border_outer_outlined),
      //   onPressed: () {
      //     showModalBottomSheet(
      //       constraints: const BoxConstraints(maxHeight: 250),
      //       context: context,
      //       enableDrag: true,
      //       useSafeArea: true,
      //       isDismissible: true,
      //       builder: (context) {
      //         return const RemoteButtons();
      //       },
      //     );
      //   },
      // ),
      body: serverSettings == null
          ? const ServerScreen()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: PcScreen(),
                      ),
                      if (settingsObj.mouseMode) const TouchPad(),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  height:
                      (mediaQuery.size.height - mediaQuery.viewInsets.bottom) /
                          4,
                  child: const RemoteButtons(),
                ),
                // Wrap(
                //   children: buttons.map(
                //     (bttn) {
                //       final String bttnTxt = bttn;
                //       final icon = morph(bttnTxt);
                //       return TextButton(
                //         onPressed: () => serverClass.keyboard(bttnTxt),
                //         child: icon != null ? Icon(icon) : Text(bttnTxt),
                //       );
                //     },
                //   ).toList(),
                // ),
                KeyboardListener(
                  focusNode: FocusNode(),
                  autofocus: true,
                  onKeyEvent: (event) {
                    if (event.logicalKey.keyLabel == 'Backspace' && !skipKey) {
                      serverClass.keyboard('\b');
                      skipKey = true;
                    } else {
                      skipKey = false;
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: null,
                      controller: _textEditingController,
                      onChanged: (txt) {
                        print(txt);
                        for (final ch in txt.characters) {
                          serverClass.keyboard(ch);
                        }
                        _textEditingController.text = "";
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: isKeyboardOpen
                              ? "Start Typing"
                              : "Open Keyboard"),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

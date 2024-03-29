import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/remote_buttons.dart';

final allButtonsList = [
  "home",
  "left",
  "up",
  "right",
  "end",
  "esc",
  "add",
  "down",
  "tab",
  "space",

  // Playing Controls
  "volumeup",
  "prevtrack",
  "playpause",
  "nexttrack",
  "stop",
  // Volume Controls
  "volumedown",
  "volumemute",
  "prtscr",
  "apps",
  "enter",

  "backspace",
  "del",
  "\t",
  "\n",
  "\r",
  " ",
  "!",
  '"',
  "#",
  "\$",
  "%",
  "&",
  "'",
  "(",
  ")",
  "*",
  "+",
  ",",
  "-",
  ".",
  "/",
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  ":",
  ";",
  "<",
  "=",
  ">",
  "?",
  "@",
  "[",
  "\\",
  "]",
  "^",
  "_",
  "`",
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
  "g",
  "h",
  "i",
  "j",
  "k",
  "l",
  "m",
  "n",
  "o",
  "p",
  "q",
  "r",
  "s",
  "t",
  "u",
  "v",
  "w",
  "x",
  "y",
  "z",
  "{",
  "|",
  "}",
  "~",
  "accept",
  "alt",
  "altleft",
  "altright",
  "browserback",
  "browserfavorites",
  "browserforward",
  "browserhome",
  "browserrefresh",
  "browsersearch",
  "browserstop",
  "capslock",
  "clear",
  "convert",
  "ctrl",
  "ctrlleft",
  "ctrlright",
  "decimal",
  "delete",
  "divide",
  "escape",
  "execute",
  "f1",
  "f10",
  "f11",
  "f12",
  "f13",
  "f14",
  "f15",
  "f16",
  "f17",
  "f18",
  "f19",
  "f2",
  "f20",
  "f21",
  "f22",
  "f23",
  "f24",
  "f3",
  "f4",
  "f5",
  "f6",
  "f7",
  "f8",
  "f9",
  "final",
  "fn",
  "hanguel",
  "hangul",
  "hanja",
  "help",
  "insert",
  "junja",
  "kana",
  "kanji",
  "launchapp1",
  "launchapp2",
  "launchmail",
  "launchmediaselect",
  "modechange",
  "multiply",
  "nonconvert",
  "num0",
  "num1",
  "num2",
  "num3",
  "num4",
  "num5",
  "num6",
  "num7",
  "num8",
  "num9",
  "numlock",
  "pagedown",
  "pageup",
  "pause",
  "pgdn",
  "pgup",
  "print",
  "printscreen",
  "prntscrn",
  "prtsc",
  "return",
  "scrolllock",
  "select",
  "separator",
  "shift",
  "shiftleft",
  "shiftright",
  "sleep",
  "subtract",
  "win",
  "winleft",
  "winright",
  "yen",
  "command",
  "option",
  "optionleft",
  "optionright",
];

class CustomizeQuickButtons extends ConsumerWidget {
  const CustomizeQuickButtons({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final buttonNotifier = ref.read(remoteButtons.notifier);
    final buttons = ref.watch(remoteButtons);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Quick Buttons Bar'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: buttons.isEmpty
                    ? Center(
                        child: Text(
                          'Quick Buttons Bar',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : GridView.builder(
                        itemCount: buttons.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 80, childAspectRatio: 2),
                        itemBuilder: (ctx, index) {
                          final String bttnTxt = buttons[index];
                          final icon = morph(bttnTxt);
                          return TextButton(
                            onPressed: () => buttonNotifier.toggle(bttnTxt),
                            child: icon != null
                                ? Icon(icon)
                                : Text(
                                    bttnTxt,
                                  ),
                          );
                        }),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: GridView.builder(
              itemCount: allButtonsList.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                childAspectRatio: 4 / 2,
              ),
              itemBuilder: ((context, index) {
                String txt = allButtonsList[index];
                if (txt == '\t') txt = "\\t";
                if (txt == '\r') txt = "\\r";
                if (txt == '\n') txt = "\\n";
                if (txt == ' ') txt = "Space";
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      buttonNotifier.toggle(allButtonsList[index]);
                    },
                    child: Text(txt),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../providers/server.dart';
import '../providers/settings.dart';

// ignore: must_be_immutable
class TouchPad extends ConsumerWidget {
  TouchPad({super.key});

  String clickText = "";
  final GlobalKey _ssKey = GlobalKey();
  Offset oldpos = Offset.zero;
  bool _longPress = false;

  @override
  Widget build(BuildContext context, ref) {
    final serverUtils = ref.read(server.notifier);
    final settingsObj = ref.read(settings);
    return (settingsObj.mouseMode == false)
        ? Container()
        : GestureDetector(
            key: _ssKey,
            child: Container(
              color: Colors.white.withOpacity(0),
            ),
            onTap: () {
              if (settingsObj.clicksToKeys) {
                serverUtils.keyboard(clickText);
              } else {
                serverUtils.mouse(0, 0, click: 'primary');
              }
              //  instead of 'primary', 'left' can cause issues
              //  if the pc has its primary button settings changed
              clickText = "";
            },
            onLongPressStart: (details) {
              _longPress = true;
              final RenderBox box =
                  _ssKey.currentContext!.findRenderObject() as RenderBox;
              final size = box.size;
              final Offset pos = details.localPosition;
              // double x = pos.dx.toInt() / size.width;
              double y = pos.dy.toInt() / size.height;
              if (y > 0.5) {
                // click on right hand side
                clickText = "down";
              } else {
                clickText = "up";
              }
              _keepScrolling(clickText, handler: serverUtils.scroll);
            },
            onLongPressEnd: (details) {
              _longPress = false;
            },
            // onLongPressMoveUpdate: (details) {
            //   final RenderBox box =
            //       _ssKey.currentContext!.findRenderObject() as RenderBox;
            //   final size = box.size;
            //   final Offset pos = details.localPosition;
            //   // double x = pos.dx.toInt() / size.width;
            //   double y = pos.dy.toInt() / size.height;
            //   if (y > 0.5) {
            //     // click on right hand side
            //     clickText = "down";
            //   } else {
            //     clickText = "up";
            //   }
            //   // serverUtils.keyboard(clickText);
            //   // debugPrint(clickText);
            // },
            onTapDown: (details) => clickText = "",
            onTapUp: (details) {
              final RenderBox box =
                  _ssKey.currentContext!.findRenderObject() as RenderBox;
              final size = box.size;
              final Offset pos = details.localPosition;
              double x = pos.dx.toInt() / size.width;
              // double y = pos.dy.toInt() / size.height;
              if (x > 0.5) {
                // click on right hand side
                clickText = "right";
              } else {
                clickText = "left";
              }
            },
            onPanStart: (details) {
              oldpos = details.localPosition;
            },
            onPanEnd: (details) {
              oldpos = Offset.zero;
            },
            onPanUpdate: (details) {
              final pos = details.localPosition;
              Offset change = pos - oldpos;
              change *= 5;
              oldpos = pos;
              // print("change = $change dx=${change.dx}");
              serverUtils.mouse(change.dx, change.dy);
            },
          );
  }

  void _keepScrolling(String clickText,
      {required void Function(int) handler}) async {
    while (_longPress) {
      await Future.delayed(const Duration(milliseconds: 100)).then((value) {
        handler(clickText == "up" ? 100 : -100);
        debugPrint("Sent $clickText");
      });
    }
  }
}

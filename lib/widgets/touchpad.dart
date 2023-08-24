import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../providers/server.dart';
import '../providers/settings.dart';

// ignore: must_be_immutable
class TouchPad extends ConsumerWidget {
  bool _scrolling = false;

  int scrollValue = 0;

  TouchPad({super.key});

  String clickText = "";
  final GlobalKey _ssKey = GlobalKey();
  Offset oldpos = Offset.zero;

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
              if (settingsObj.scrollMode) {
                _scrolling = true;
                _keepScrolling(handler: serverUtils.scroll);
              }
            },
            onPanEnd: (details) {
              oldpos = Offset.zero;
              _scrolling = false;
            },
            onPanUpdate: (details) {
              final pos = details.localPosition;
              Offset change = pos - oldpos;
              change *= 5;
              oldpos = pos;
              // print("change = $change dx=${change.dx}");
              if (settingsObj.scrollMode) {
                scrollValue += ((change.dy * 2).toInt());
              } else if (settingsObj.mouseMode) {
                serverUtils.mouse(change.dx, change.dy);
              }
            },
          );
  }

  void _keepScrolling({required void Function(int) handler}) async {
    while (_scrolling) {
      await Future.delayed(const Duration(milliseconds: 100)).then((value) {
        if (scrollValue != 0) handler(scrollValue);
        scrollValue = 0;
      });
    }
  }
}

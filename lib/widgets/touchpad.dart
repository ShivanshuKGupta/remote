import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../providers/server.dart';
import '../providers/settings.dart';

class TouchPad extends ConsumerWidget {
  TouchPad({super.key});

  String clickText = "";
  final GlobalKey _ssKey = GlobalKey();
  Offset oldpos = Offset.zero;

  @override
  Widget build(BuildContext context, ref) {
    return (ref.read(settings).mouseMode == false)
        ? Container()
        : GestureDetector(
            key: _ssKey,
            child: Container(
              color: Colors.white.withOpacity(0),
            ),
            onTap: () {
              ref.read(server.notifier).keyboard(clickText);
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
            },
            onPanEnd: (details) {
              oldpos = Offset.zero;
            },
            onPanUpdate: (details) {
              final pos = details.localPosition;
              Offset change = pos - oldpos;
              change *= 5;
              oldpos = pos;
              print("change = $change dx=${change.dx}");
              ref.read(server.notifier).mouse(change.dx, change.dy);
            },
          );
  }
}

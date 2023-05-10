import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/server.dart';
import '../providers/settings.dart';

void Function(Image)? setImage;

class PcScreen extends ConsumerStatefulWidget {
  Image? image;
  PcScreen({super.key});

  @override
  ConsumerState<PcScreen> createState() => _PcScreenState();
}

class _PcScreenState extends ConsumerState<PcScreen> {
  String clickText = "";

  void refreshImage(image) {
    setState(() {
      widget.image = image;
    });
  }

  _PcScreenState() {
    setImage = refreshImage;
  }

  final GlobalKey _ssKey = GlobalKey();
  Offset oldpos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    var viewerKey = GlobalKey();
    return Expanded(
      child: widget.image == null || !ref.watch(settings).receiveImage
          ? Center(
              child: Text(
                'Turn on receive image in settings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          : InteractiveViewer(
              key: viewerKey,
              child: ref.read(settings).mouseMode == false
                  ? widget.image!
                  : GestureDetector(
                      key: _ssKey,
                      child: widget.image!,
                      onTap: () {
                        ref.read(server.notifier).keyboard(clickText);
                        clickText = "";
                      },
                      onTapDown: (details) => clickText = "",
                      onTapUp: (details) {
                        final RenderBox box = _ssKey.currentContext!
                            .findRenderObject() as RenderBox;
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
                    ),
            ),
    );
  }
}

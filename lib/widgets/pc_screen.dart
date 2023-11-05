import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote/providers/settings.dart';

void Function(Image)? setImage;

// ignore: must_be_immutable
class PcScreen extends ConsumerStatefulWidget {
  Image? image;
  PcScreen({super.key});

  @override
  ConsumerState<PcScreen> createState() => _PcScreenState();
}

class _PcScreenState extends ConsumerState<PcScreen> {
  void refreshImage(image) {
    setState(() {
      widget.image = image;
    });
  }

  _PcScreenState() {
    setImage = refreshImage;
  }

  final viewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return (widget.image == null || !ref.watch(settings).receiveImage)
        ? Center(
            child: Text(
              ref.read(settings).scrollMode
                  ? 'Move your finger here to\nscroll up and down'
                  : (ref.read(settings).mouseMode
                      ? "Move your finger here to\nmove the mouse"
                      : "Mouse mode is off"),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          )
        : InteractiveViewer(
            key: viewerKey,
            maxScale: 200,
            child: widget.image!,
          );
  }
}

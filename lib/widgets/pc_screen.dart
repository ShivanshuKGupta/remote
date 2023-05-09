import 'package:flutter/material.dart';

void Function(Image)? setImage;

class PcScreen extends StatefulWidget {
  Image? image;
  PcScreen({super.key});

  @override
  State<PcScreen> createState() => _PcScreenState();
}

class _PcScreenState extends State<PcScreen> {
  void refreshImage(image) {
    setState(() {
      widget.image = image;
    });
  }

  _PcScreenState() {
    setImage = refreshImage;
  }

  @override
  Widget build(BuildContext context) {
    var viewerKey = GlobalKey();
    return Expanded(
      child: widget.image == null
          ? Center(
              child: Text(
                'Connect to a PC then refresh',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          : GestureDetector(
              onTapDown: (details) {
                print('localpos = ${details.localPosition}');
              },
              child: InteractiveViewer(
                key: viewerKey,
                child: widget.image!,
              ),
            ),
    );
  }
}

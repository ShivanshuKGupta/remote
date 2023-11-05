import 'package:flutter/material.dart';
import 'package:remote/widgets/select_one_tile.dart';

// ignore: must_be_immutable
class SelectOne<T> extends StatefulWidget {
  final Set<T> allOptions;
  final Set<T> disabledOptions;
  T? selectedOption;
  final bool Function(T chosenOption) onChange;
  final String? title;
  final String? subtitle;
  bool expanded;
  SelectOne({
    super.key,
    required this.allOptions,
    this.disabledOptions = const {},
    this.selectedOption,
    required this.onChange,
    this.title,
    this.subtitle,
    this.expanded = false,
  });

  @override
  State<SelectOne<T>> createState() => _SelectOneState<T>();
}

class _SelectOneState<T> extends State<SelectOne<T>> {
  @override
  Widget build(BuildContext context) {
    final Wrap body = Wrap(
      alignment: WrapAlignment.start,
      runSpacing: 0,
      spacing: 5,
      children: widget.allOptions
          .map((e) => SelectOneTile(
                enabled: !widget.disabledOptions.contains(e.toString()),
                label: e.toString(),
                isSelected: widget.selectedOption == e,
                onPressed: () {
                  if (widget.onChange(e)) {
                    setState(() {
                      widget.selectedOption = e;
                    });
                  }
                },
              ))
          .toList(),
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        if (widget.subtitle != null)
                          Text(
                            widget.subtitle!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.expanded = !widget.expanded;
                        });
                      },
                      icon: Icon(widget.expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded),
                    ),
                  ],
                ),
              ),
            ),
          if (widget.expanded)
            body
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: body,
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

void showMsg(BuildContext context, String message, {Icon? icon}) =>
    showSnackBar(
        context,
        SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) icon,
                if (icon != null) const SizedBox(width: 10),
                Text(message),
              ],
            ),
            showCloseIcon: true));

showSnackBar(BuildContext context, SnackBar snackBar) {
  ScaffoldMessenger.of(context).clearSnackBars();
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Widget circularProgressIndicator() {
  return const SizedBox(
    width: 16,
    height: 16,
    child: CircularProgressIndicator(),
  );
}

/// A quick ready-made alertbox with yes/no/cancel etc. buttons
/// This is used to ask user about some quick confirmations or
/// to show him a message
Future<String?> askUser(
  context,
  String msg, {
  String? description,
  bool yes = false,
  bool ok = false,
  bool no = false,
  bool cancel = false,
  List<String> custom = const [],
}) async {
  List<Widget> buttons = [
    if (ok == true)
      TextButton.icon(
        label: const Text("OK"),
        onPressed: () {
          Navigator.of(context).pop("ok");
        },
        icon: const Icon(Icons.check_rounded),
      ),
    if (yes == true)
      TextButton.icon(
        label: const Text("Yes"),
        onPressed: () {
          Navigator.of(context).pop("yes");
        },
        icon: const Icon(Icons.check_rounded),
      ),
    if (no == true)
      TextButton.icon(
        label: const Text("No"),
        onPressed: () {
          Navigator.of(context).pop("no");
        },
        icon: const Icon(Icons.close_rounded),
      ),
    if (cancel == true)
      TextButton.icon(
        label: const Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop("cancel");
        },
        icon: const Icon(Icons.close_rounded),
      ),
    ...custom.map(
      (e) => TextButton(
        onPressed: () {
          Navigator.of(context).pop(e);
        },
        child: Text(e),
      ),
    ),
  ];
  if (buttons.isEmpty) {
    buttons.add(
      TextButton.icon(
        label: const Text("OK"),
        onPressed: () {
          Navigator.of(context).pop("ok");
        },
        icon: const Icon(Icons.check_rounded),
      ),
    );
  }
  return await Navigator.push(
    context,
    DialogRoute(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(msg),
        content: description != null ? Text(description) : null,
        actions: buttons,
        actionsAlignment: MainAxisAlignment.spaceAround,
      ),
    ),
  );
}

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

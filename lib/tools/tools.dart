import 'package:flutter/material.dart';

void showMsg(BuildContext context, String message) => showSnackBar(
    context, SnackBar(content: Text(message), showCloseIcon: true));

showSnackBar(BuildContext context, SnackBar snackBar) {
  ScaffoldMessenger.of(context).clearSnackBars();
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

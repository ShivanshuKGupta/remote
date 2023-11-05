import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote/providers/remote_buttons.dart';

import '../providers/server.dart';

class RemoteButtons extends ConsumerWidget {
  const RemoteButtons({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final serverNotifier = ref.read(server.notifier);
    final socket = ref.watch(server);
    final buttons = ref.watch(remoteButtons);
    // final buttonNotifier = ref.watch(remoteButtons.notifier);
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: buttons.isEmpty
          ? Center(
              child: Text(
                'Quick Buttons Bar',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            )
          : GridView.builder(
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 80,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (ctx, index) {
                final String bttnTxt = buttons[index];
                final icon = morph(bttnTxt);
                return TextButton(
                  onPressed: socket == null
                      ? null
                      : () => serverNotifier.keyboard(bttnTxt),
                  child: icon != null
                      ? Icon(icon)
                      : Text(
                          bttnTxt,
                        ),
                );
              }),
    );
  }
}

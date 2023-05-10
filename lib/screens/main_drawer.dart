import 'package:flutter/material.dart';
import 'package:remote/screens/settings_screen.dart';
import 'package:remote/widgets/os_buttons.dart';

import 'help_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Widget modeList(context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Connect to a PC',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Divider(),
        tile(
          context,
          "OS tools",
          () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const OsButtons(),
              ),
            );
          },
        ),
        tile(
          context,
          "Settings",
          () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
        ),
        tile(
          context,
          "How to use?",
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HelpScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.2),
                Colors.purple.withOpacity(0.2)
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: modeList(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget tile(context, title, onTap) {
    return ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        onTap: onTap);
  }
}

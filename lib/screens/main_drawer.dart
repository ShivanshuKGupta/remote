import 'package:flutter/material.dart';
import 'package:remote/screens/settings_screen.dart';
import 'package:remote/widgets/os_buttons.dart';

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
        ListTile(
            title: const Text('OS Tools'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OsButtons(),
                ),
              );
            }),
        ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            }),
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
              // Padding(
              //   padding: EdgeInsets.only(bottom: viewInsets.bottom),
              //   child: const RemoteButtons(),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

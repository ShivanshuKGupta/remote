import 'package:flutter/material.dart';
import 'package:remote/screens/customize_buttons.dart';
import 'package:remote/screens/settings_screen.dart';
import 'package:remote/widgets/os_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'help_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Widget widgetList(context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (rect) {
                  return const LinearGradient(
                          colors: [Colors.deepPurpleAccent, Colors.blue])
                      .createShader(rect);
                },
                child: Text(
                  'Remote',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                child: ShaderMask(
                  blendMode: BlendMode.srcATop,
                  shaderCallback: (rect) {
                    return LinearGradient(colors: [
                      Theme.of(context).colorScheme.primary,
                      Colors.deepPurple
                    ]).createShader(rect);
                  },
                  child: Text(
                    '@ShivanshuKGupta',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                onTap: () {
                  launchUrl(Uri.parse('https://github.com/ShivanshuKGupta/'));
                },
              ),
            ],
          ),
        ),
        const Divider(),
        tile(
          context,
          title: "Quick Buttons Bar",
          subtitle: 'Customize quick button menu bar',
          icon: Icons.keyboard_alt_rounded,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CustomizeQuickButtons(),
              ),
            );
          },
        ),
        tile(
          context,
          title: "Other",
          subtitle: 'Micellaneous Functions',
          icon: Icons.more_horiz,
          onTap: () {
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
          title: "Settings",
          icon: Icons.settings_rounded,
          subtitle: "Customize the app to your needs",
          onTap: () {
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
          title: "How to use?",
          icon: Icons.help_rounded,
          subtitle: "Help on using the app",
          onTap: () {
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
          width: double.infinity,
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [
          //       Colors.blue.withOpacity(0.4),
          //       Colors.purple.withOpacity(0.4),
          //     ],
          //   ),
          // ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: widgetList(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget tile(context,
      {required String title,
      required String subtitle,
      required void Function() onTap,
      IconData? icon}) {
    return ListTile(
        leading: icon == null ? null : Icon(icon),
        subtitle: Text(subtitle),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        onTap: onTap);
  }
}

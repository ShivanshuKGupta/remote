import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remote/providers/server.dart';
import 'package:remote/providers/settings.dart';
import 'package:remote/screens/customize_buttons.dart';
import 'package:remote/screens/settings_screen.dart';
import 'package:remote/tools/tools.dart';
import 'package:remote/widgets/dark_light_mode_button.dart';
import 'package:remote/widgets/loading_elevated_button.dart';
import 'package:remote/widgets/os_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'help_screen.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  Widget widgetList(context, WidgetRef ref) {
    final serverSettings = ref.watch(server);
    final serverClass = ref.watch(server.notifier);
    final settingsObj = ref.watch(settings);
    final settingsClass = ref.watch(settings.notifier);
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
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
                  linkText(context, '@ShivanshuKGupta',
                      'https://github.com/ShivanshuKGupta/remote/releases/latest'),
                ],
              ),
            ),
            SizedBox(
              width: constraints.maxWidth,
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                children: [
                  if (serverSettings != null)
                    LoadingElevatedButton(
                      label: const Text("Disconnect"),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        try {
                          await serverClass.disconnect();
                        } catch (e) {
                          showMsg(context, "Error disconnecting");
                        }
                        showMsg(context, 'Disconnected');
                      },
                      style: IconButton.styleFrom(foregroundColor: Colors.red),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  const DarkLightModeIconButton(),
                ],
              ),
            ),
            const Divider(),
            tile(
              context,
              title: "Quick Buttons Bar",
              subtitle: 'Customize quick buttons bar',
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
      },
    );
  }

  Widget linkText(context, String title, String url, {IconData? icon}) {
    return GestureDetector(
      child: ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (rect) {
          return const LinearGradient(colors: [
            // Theme.of(context).colorScheme.primary,
            Colors.blue,
            Colors.deepPurple
          ]).createShader(rect);
        },
        child: icon != null
            ? Icon(icon)
            : Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
      ),
      onTap: () {
        launchUrl(Uri.parse(url));
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                child: widgetList(context, ref),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  linkText(
                      context, 'Email', "mailto:shivanshukgupta@gmail.com"),
                  linkText(context, 'Linkedin',
                      "https://www.linkedin.com/in/shivanshukgupta/"),
                  linkText(context, 'Github',
                      "https://www.github.com/shivanshukgupta/"),
                ],
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
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        onTap: onTap);
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to use?'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  "Download all files from the below link (all .py and .bat files)"),
              GestureDetector(
                onTap: () => launchUrl(
                  Uri.parse(
                      'https://github.com/ShivanshuKGupta/remote/tree/master/lib/python'),
                ),
                child: const Text(
                  'github.com/ShivanshuKGupta/remote/tree/master/lib/python',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Text(
                  "Then run 'runMe.bat' in administrative mode on your PC."),
            ],
          ),
        ),
      ),
    );
  }
}

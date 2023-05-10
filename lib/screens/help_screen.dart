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
            children: [
              const Text('Download the python script from here.'),
              GestureDetector(
                onTap: () => launchUrl(
                  Uri.parse(
                      'https://github.com/ShivanshuKGupta/remote/blob/master/lib/python/remote.py'),
                ),
                child: const Text(
                  'github.com/ShivanshuKGupta/remote/blob/master/lib/python/remote.py',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Text('Then run it on your PC.'),
            ],
          ),
        ),
      ),
    );
  }
}

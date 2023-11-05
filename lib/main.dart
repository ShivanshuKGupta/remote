import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remote/providers/server.dart';
import 'package:remote/providers/settings.dart';
import 'package:remote/screens/home_screen.dart';
import 'package:remote/screens/scan_screen.dart';

void main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsRef = ref.watch(settings);
    final bool darkMode = settingsRef.autoDarkMode
        ? (MediaQuery.of(context).platformBrightness == Brightness.dark
            ? true
            : false)
        : settingsRef.darkMode;
    final serverRef = ref.watch(server);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Remote',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            brightness: darkMode ? Brightness.dark : Brightness.light,
            seedColor: const Color.fromARGB(255, 0, 17, 255),
          ),
          textTheme: GoogleFonts.quicksandTextTheme().apply(
            bodyColor: darkMode ? Colors.white : Colors.black,
            displayColor: darkMode ? Colors.white : Colors.black,
          )),
      home: serverRef == null && !settingsRef.manuallyConnect
          ? const ScanScreen()
          : const HomeScreen(),
    );
  }
}

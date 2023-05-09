import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remote/providers/settings.dart';
import 'screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool darkMode = ref.watch(settings).darkMode;
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
      home: HomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_tutur/screens/home/home_screen.dart';
import 'package:project_tutur/screens/add_new/add_screen.dart';

void main() {
  _setSystemUIOverlayStyle();
  runApp(const MyApp());
}

// Setup UI Overlay Style (Status Bar)
void _setSystemUIOverlayStyle() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF3F51B5),
      statusBarIconBrightness: Brightness.light,
    ),
  );
}

// Aplikasi Utama
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TUTUR',
      debugShowCheckedModeBanner: false,
      theme: _appTheme(),
      home: const HomeScreen(),
      routes: {
        '/addscreen': (context) => AddScreen(),
      },
    );
  }
}

// Tema Aplikasi
ThemeData _appTheme() {
  return ThemeData(
    primaryColor: const Color(0xFF3F51B5),
    scaffoldBackgroundColor: const Color(0xffEFF6FF),
  );
}

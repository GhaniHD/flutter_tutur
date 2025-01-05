import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_tutur/screens/home/home_screen.dart';
import 'package:project_tutur/screens/add_new/add_screen.dart';
import 'package:project_tutur/screens/cards/cards_screen.dart';
import 'package:project_tutur/screens/add_new/add_new_card.dart'; // Tambahkan import ini
import 'package:project_tutur/data/models/album_item.dart';

void main() {
  _setSystemUIOverlayStyle();
  runApp(const MyApp());
}

void _setSystemUIOverlayStyle() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF3F51B5),
      statusBarIconBrightness: Brightness.light,
    ),
  );
}

// Route Names
class Routes {
  static const String home = '/home';
  static const String addScreen = '/addscreen';
  static const String cardScreen = '/cardscreen';
  static const String addNewCard ='/add-new-card'; 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TUTUR',
      debugShowCheckedModeBanner: false,
      theme: _appTheme(),
      home: const HomeScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.home:
            return MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            );

          case Routes.addScreen:
            return MaterialPageRoute(
              builder: (context) => AddScreen(),
            );

          case Routes.addNewCard: 
            return MaterialPageRoute(
              builder: (context) => const AddNewCardScreen(),
            );

          case Routes.cardScreen:
            if (settings.arguments is! AlbumItem) {
              return MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              );
            }
            final album = settings.arguments as AlbumItem;
            return MaterialPageRoute(
              builder: (context) => CardsScreen(album: album),
            );

          default:
            return MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            );
        }
      },
    );
  }
}

ThemeData _appTheme() {
  return ThemeData(
    primaryColor: const Color(0xFF3F51B5),
    scaffoldBackgroundColor: const Color(0xffEFF6FF),
  );
}

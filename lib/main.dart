import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_tutur/screens/home/home_screen.dart';
import 'package:project_tutur/screens/add_new/add_screen.dart';
import 'package:project_tutur/screens/cards/cards_screen.dart';
import 'package:project_tutur/screens/add_new/add_new_card.dart';
import 'package:project_tutur/data/models/album_item.dart';
import 'auth/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'auth/providers/auth_provider.dart';
import 'core/api/api_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const clientId = '690489905561-hl3gavg51mkm5t946gt8b0gs62fb5pv1.apps.googleusercontent.com';
  GoogleSignIn(clientId: clientId);

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBHgt88IBXpOuQM0T6lqiyBpyOBRpnBK-c",
        authDomain: "tutur-api.firebaseapp.com",
        projectId: "tutur-api",
        storageBucket: "tutur-api.firebasestorage.app",
        messagingSenderId: "690489905561",
        appId: "1:690489905561:web:19a02fde34b6c7594d4308",
        measurementId: "G-FQ0RJHECPN"
    ),
  );

  await ApiProvider().init();
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

class Routes {
  static const String login = '/login';
  static const String home = '/home';
  static const String addScreen = '/addscreen';
  static const String cardScreen = '/cardscreen';
  static const String addNewCard = '/add-new-card';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    _setSystemUIOverlayStyle(); // Menambahkan pemanggilan untuk pengaturan status bar

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'TUTUR',
        debugShowCheckedModeBanner: false,
        theme: _appTheme(),
        home: const LoginScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case Routes.login:
              return MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              );

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
                builder: (context) => const LoginScreen(),
              );
          }
        },
      ),
    );
  }
}

ThemeData _appTheme() {
  return ThemeData(
    primaryColor: const Color(0xFF3F51B5),
    scaffoldBackgroundColor: const Color(0xffEFF6FF),
  );
}

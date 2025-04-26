import 'package:agrarixx/screens/auth/register_screen.dart';
// import 'package:agrarixx/screens/auth/succes_page.dart';
import 'package:agrarixx/screens/landing_page/view/landing_page1.dart';
import 'package:agrarixx/screens/landing_page/view/landing_page2.dart';
import 'package:agrarixx/screens/landing_page/view/landing_page3.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/auth/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'agrarixx',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => landingPage1(),
        '/landingPage2': (context) => const landingPage2(),
        '/landingPage3': (context) => const landingPage3(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterPage(),
        // '/success': (context) => const SuccessPage(),
      },
    );
  }
}

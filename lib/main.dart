import 'package:agrarixx/screens/auth/register_screen.dart';
// import 'package:agrarixx/screens/auth/succes_page.dart';
import 'package:agrarixx/screens/landing_page/view/landing_page1.dart';
import 'package:agrarixx/screens/landing_page/view/landing_page2.dart';
import 'package:agrarixx/screens/landing_page/view/landing_page3.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    // Set a default design size for ScreenUtil. Adjust as needed.
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Contoh ukuran desain umum
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child) {
        return MaterialApp(
          title: 'agrarixx',
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => const LandingPage1(),
            '/landingPage2': (context) => const LandingPage2(), 
            '/landingPage3': (context) => const LandingPage3(), // Asumsi nama kelas adalah LandingPage3
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterPage(),
            // '/success': (context) => const SuccessPage(),
          },
        );
      }
    );
  }
}

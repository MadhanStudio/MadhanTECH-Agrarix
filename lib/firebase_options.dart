// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCqakiPvT97Fc4_anAMBOpC7fDrm50v00Y',
    appId: '1:791442406366:web:51aee70d9f60ce4bd8fb4f',
    messagingSenderId: '791442406366',
    projectId: 'madhantech-675b2',
    authDomain: 'madhantech-675b2.firebaseapp.com',
    storageBucket: 'madhantech-675b2.firebasestorage.app',
    measurementId: 'G-QBKFC9HXES',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAtx5V1O5v-d2fC51By2u9uK00aitudLvQ',
    appId: '1:791442406366:android:a1372f6554222b30d8fb4f',
    messagingSenderId: '791442406366',
    projectId: 'madhantech-675b2',
    storageBucket: 'madhantech-675b2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCxtqiBBGsOnwkRlrx97Nut3A3aJ-AM-r8',
    appId: '1:791442406366:ios:dd001b1793609e79d8fb4f',
    messagingSenderId: '791442406366',
    projectId: 'madhantech-675b2',
    storageBucket: 'madhantech-675b2.firebasestorage.app',
    iosBundleId: 'com.example.agrarixx',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCxtqiBBGsOnwkRlrx97Nut3A3aJ-AM-r8',
    appId: '1:791442406366:ios:dd001b1793609e79d8fb4f',
    messagingSenderId: '791442406366',
    projectId: 'madhantech-675b2',
    storageBucket: 'madhantech-675b2.firebasestorage.app',
    iosBundleId: 'com.example.agrarixx',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCqakiPvT97Fc4_anAMBOpC7fDrm50v00Y',
    appId: '1:791442406366:web:d1695d80a852a715d8fb4f',
    messagingSenderId: '791442406366',
    projectId: 'madhantech-675b2',
    authDomain: 'madhantech-675b2.firebaseapp.com',
    storageBucket: 'madhantech-675b2.firebasestorage.app',
    measurementId: 'G-MXXNXLV6QH',
  );

}
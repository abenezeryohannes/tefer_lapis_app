// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCquBaPsFTf3l242HMpjmsChu-9WKzyuI8',
    appId: '1:715760661666:web:3007e3c47fdfda3dc2d3fb',
    messagingSenderId: '715760661666',
    projectId: 'shera-8c71d',
    authDomain: 'shera-8c71d.firebaseapp.com',
    databaseURL: 'https://shera-8c71d.firebaseio.com',
    storageBucket: 'shera-8c71d.appspot.com',
    measurementId: 'G-WCNT03WJ50',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBwV2Xf5QE2Gp0f2ZOTgPa9O9x4nSnNQ2g',
    appId: '1:715760661666:android:ee239dd042152d02c2d3fb',
    messagingSenderId: '715760661666',
    projectId: 'shera-8c71d',
    databaseURL: 'https://shera-8c71d.firebaseio.com',
    storageBucket: 'shera-8c71d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCGJEfUdRcLHRTQWqN3e0lfi5ktlJS_FGQ',
    appId: '1:715760661666:ios:a1d981b694e3fe42c2d3fb',
    messagingSenderId: '715760661666',
    projectId: 'shera-8c71d',
    databaseURL: 'https://shera-8c71d.firebaseio.com',
    storageBucket: 'shera-8c71d.appspot.com',
    androidClientId: '715760661666-3f2r7u5jnelm0oggmc93rpdf54lfpf52.apps.googleusercontent.com',
    iosClientId: '715760661666-l2lb9gmkq7ijq09jcrfr3a48s52fbtoo.apps.googleusercontent.com',
    iosBundleId: 'com.example.myapp',
  );
}

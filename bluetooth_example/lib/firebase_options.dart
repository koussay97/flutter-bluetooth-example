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
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDpJ5tOv5kNl2tlKNtgi3anEf1FzXJ3nKo',
    appId: '1:154447156151:web:6cbbce654ef14180ff4e32',
    messagingSenderId: '154447156151',
    projectId: 'bluetooth-app-e567f',
    authDomain: 'bluetooth-app-e567f.firebaseapp.com',
    storageBucket: 'bluetooth-app-e567f.appspot.com',
    measurementId: 'G-TNESF4SNSZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAZbgxb2k4t3is8E-NDn94gh750wcq1cfU',
    appId: '1:154447156151:android:0ec1e06b248495a5ff4e32',
    messagingSenderId: '154447156151',
    projectId: 'bluetooth-app-e567f',
    storageBucket: 'bluetooth-app-e567f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAsaHl0nZ_B2dGZWBSS-2NjLFCLMch19LE',
    appId: '1:154447156151:ios:2fd5f1a9d0d912c7ff4e32',
    messagingSenderId: '154447156151',
    projectId: 'bluetooth-app-e567f',
    storageBucket: 'bluetooth-app-e567f.appspot.com',
    iosBundleId: 'com.example.bluetoothExample',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAsaHl0nZ_B2dGZWBSS-2NjLFCLMch19LE',
    appId: '1:154447156151:ios:d206ee7995213308ff4e32',
    messagingSenderId: '154447156151',
    projectId: 'bluetooth-app-e567f',
    storageBucket: 'bluetooth-app-e567f.appspot.com',
    iosBundleId: 'com.example.bluetoothExample.RunnerTests',
  );
}

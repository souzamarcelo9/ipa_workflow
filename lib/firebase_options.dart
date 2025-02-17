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
    apiKey: 'AIzaSyB7lVvqeOhQhXMc0SrE8KydTJzv4VPRRlA',
    appId: '1:308788371795:web:1591b38be6fd2804ad81a6',
    messagingSenderId: '308788371795',
    projectId: 'drywall-9dc6c',
    authDomain: 'drywall-9dc6c.firebaseapp.com',
    storageBucket: 'drywall-9dc6c.appspot.com',
    measurementId: 'G-FJEJH2T4CH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQ5ZicSPUohZW6H4Z7PRRAALr0gcqASTs',
    appId: '1:308788371795:android:f1b3ac8d99661555ad81a6',
    messagingSenderId: '308788371795',
    projectId: 'drywall-9dc6c',
    storageBucket: 'drywall-9dc6c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBdgRNIL40A8Ujdtq635RBa-Z1DZAbgSrQ',
    appId: '1:308788371795:ios:adf5aa35fe516bcbad81a6',
    messagingSenderId: '308788371795',
    projectId: 'drywall-9dc6c',
    storageBucket: 'drywall-9dc6c.appspot.com',
    iosBundleId: 'com.example.viskaErpMobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBdgRNIL40A8Ujdtq635RBa-Z1DZAbgSrQ',
    appId: '1:308788371795:ios:adf5aa35fe516bcbad81a6',
    messagingSenderId: '308788371795',
    projectId: 'drywall-9dc6c',
    storageBucket: 'drywall-9dc6c.appspot.com',
    iosBundleId: 'com.example.viskaErpMobile',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB7lVvqeOhQhXMc0SrE8KydTJzv4VPRRlA',
    appId: '1:308788371795:web:a7ebd37d94b2f848ad81a6',
    messagingSenderId: '308788371795',
    projectId: 'drywall-9dc6c',
    authDomain: 'drywall-9dc6c.firebaseapp.com',
    storageBucket: 'drywall-9dc6c.appspot.com',
    measurementId: 'G-5KW8RZ6VVV',
  );

}
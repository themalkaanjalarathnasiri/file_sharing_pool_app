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
    apiKey: 'AIzaSyB5aMo-fi3fqcMAB5_GAtn-0uOcF8ZTpNc',
    appId: '1:92222260692:web:22b0ccaa0f69e36ec14241',
    messagingSenderId: '92222260692',
    projectId: 'pool-share-817de',
    authDomain: 'pool-share-817de.firebaseapp.com',
    storageBucket: 'pool-share-817de.appspot.com',
    measurementId: 'G-JX5YH1P13G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9qifsOLbxV0Ncoosc_WgGfbSSIk0i67s',
    appId: '1:92222260692:android:bc2d296fe314ef9ec14241',
    messagingSenderId: '92222260692',
    projectId: 'pool-share-817de',
    storageBucket: 'pool-share-817de.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAqJZ7myWOZ_yUTJeQ4sLa_eUyTl0j2q5M',
    appId: '1:92222260692:ios:d2e06bab19bab537c14241',
    messagingSenderId: '92222260692',
    projectId: 'pool-share-817de',
    storageBucket: 'pool-share-817de.appspot.com',
    iosBundleId: 'com.sharepool.sharePool',
  );
}
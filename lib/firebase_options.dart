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
    apiKey: 'AIzaSyCWv8lHX-xPOENXKcv0-k7ivkGQ5mEYL1o',
    appId: '1:929430978792:web:f4b6f348d4c46e053e895d',
    messagingSenderId: '929430978792',
    projectId: 'movie-app-e50e5',
    authDomain: 'movie-app-e50e5.firebaseapp.com',
    storageBucket: 'movie-app-e50e5.appspot.com',
    measurementId: 'G-32HT8N5TKG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCzocjrUHh0PYrhtBgPajtv8faLMfrL0Zw',
    appId: '1:929430978792:android:1d15c433b256f60b3e895d',
    messagingSenderId: '929430978792',
    projectId: 'movie-app-e50e5',
    storageBucket: 'movie-app-e50e5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAyGShnwAO3AxIJAgoIY765Bs-ggwfI-nA',
    appId: '1:929430978792:ios:950952f6483968fb3e895d',
    messagingSenderId: '929430978792',
    projectId: 'movie-app-e50e5',
    storageBucket: 'movie-app-e50e5.appspot.com',
    iosBundleId: 'com.example.appMovie',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAyGShnwAO3AxIJAgoIY765Bs-ggwfI-nA',
    appId: '1:929430978792:ios:a9516c951da62ea03e895d',
    messagingSenderId: '929430978792',
    projectId: 'movie-app-e50e5',
    storageBucket: 'movie-app-e50e5.appspot.com',
    iosBundleId: 'com.example.appMovie.RunnerTests',
  );
}
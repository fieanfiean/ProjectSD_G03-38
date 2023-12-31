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
    apiKey: 'AIzaSyA9RhHRDKJaJVAVtBwDqNIi2v2vsZyyuGs',
    appId: '1:975021124988:web:de2f86dd530fe8012488f9',
    messagingSenderId: '975021124988',
    projectId: 'airasia-online-check-in-system',
    authDomain: 'airasia-online-check-in-system.firebaseapp.com',
    storageBucket: 'airasia-online-check-in-system.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwOf9fjXV5_cc5t6SywbaXwKscyeOmEgE',
    appId: '1:975021124988:android:f1fc1fd0d8c66bb82488f9',
    messagingSenderId: '975021124988',
    projectId: 'airasia-online-check-in-system',
    databaseURL: "https://airasia-online-check-in-system-default-rtdb.asia-southeast1.firebasedatabase.app",
    storageBucket: 'airasia-online-check-in-system.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDOi3ZbqvnHv-5QuRgWGLHnFYepEqkq_y0',
    appId: '1:975021124988:ios:35bf81d3f8f05f0c2488f9',
    messagingSenderId: '975021124988',
    projectId: 'airasia-online-check-in-system',
    storageBucket: 'airasia-online-check-in-system.appspot.com',
    iosClientId: '975021124988-8lbqohje992cvgcj1qjs7ltqje01u3l3.apps.googleusercontent.com',
    iosBundleId: 'com.example.airasiaOnlineCheckInSystem',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDOi3ZbqvnHv-5QuRgWGLHnFYepEqkq_y0',
    appId: '1:975021124988:ios:4069500516f58f4b2488f9',
    messagingSenderId: '975021124988',
    projectId: 'airasia-online-check-in-system',
    storageBucket: 'airasia-online-check-in-system.appspot.com',
    iosClientId: '975021124988-3l328od2ouod7rd07rm2cbqok3pq6q8v.apps.googleusercontent.com',
    iosBundleId: 'com.example.airasiaOnlineCheckInSystem.RunnerTests',
  );
}

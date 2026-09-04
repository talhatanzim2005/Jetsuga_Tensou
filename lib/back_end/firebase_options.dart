import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDrBTezb_33x6lvKRQevyIuTpxa6scFmd4',
    appId: '1:178530774852:web:3a100f65f6d12e44c57111',
    messagingSenderId: '178530774852',
    projectId: 'carnival-hackathon-2026',
    authDomain: 'carnival-hackathon-2026.firebaseapp.com',
    storageBucket: 'carnival-hackathon-2026.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrAtJS6zQWga86iOuCssqd7SEnwQjf7w8',
    appId: '1:178530774852:android:0f9cdb72b75ff2c5c57111',
    messagingSenderId: '178530774852',
    projectId: 'carnival-hackathon-2026',
    storageBucket: 'carnival-hackathon-2026.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD1x6zrXZNQLZMrkE0Qqeo7Fvbur76-gvA',
    appId: '1:178530774852:ios:d29a9aea66341d26c57111',
    messagingSenderId: '178530774852',
    projectId: 'carnival-hackathon-2026',
    storageBucket: 'carnival-hackathon-2026.firebasestorage.app',
    iosBundleId: 'com.example.hackathon',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD1x6zrXZNQLZMrkE0Qqeo7Fvbur76-gvA',
    appId: '1:178530774852:ios:d29a9aea66341d26c57111',
    messagingSenderId: '178530774852',
    projectId: 'carnival-hackathon-2026',
    storageBucket: 'carnival-hackathon-2026.firebasestorage.app',
    iosBundleId: 'com.example.hackathon',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDrBTezb_33x6lvKRQevyIuTpxa6scFmd4',
    appId: '1:178530774852:web:17a81a97d939e260c57111',
    messagingSenderId: '178530774852',
    projectId: 'carnival-hackathon-2026',
    authDomain: 'carnival-hackathon-2026.firebaseapp.com',
    storageBucket: 'carnival-hackathon-2026.firebasestorage.app',
  );
}

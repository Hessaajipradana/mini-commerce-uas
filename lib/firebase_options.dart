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
    apiKey: 'AIzaSyAaCdwBHFtJLeowzcH5Rts5kbLHQHL7AZ0',
    appId: '1:130080821458:web:1506473d6730b3b3b35d0b',
    messagingSenderId: '130080821458',
    projectId: 'mini-ecommerce-ab5ef',
    authDomain: 'mini-ecommerce-ab5ef.firebaseapp.com',
    storageBucket: 'mini-ecommerce-ab5ef.firebasestorage.app',
    measurementId: 'G-BNZTQ7PW60',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8GRcKul6EJfvy6KY6HWuqGoDn4B1kU1k',
    appId: '1:130080821458:android:57f2f2c1f90a51a6b35d0b',
    messagingSenderId: '130080821458',
    projectId: 'mini-ecommerce-ab5ef',
    storageBucket: 'mini-ecommerce-ab5ef.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCSaaq_eZmHJsD7nwNznL8DwEjlK8oySVo',
    appId: '1:130080821458:ios:9b088e9dcc32728eb35d0b',
    messagingSenderId: '130080821458',
    projectId: 'mini-ecommerce-ab5ef',
    storageBucket: 'mini-ecommerce-ab5ef.firebasestorage.app',
    iosBundleId: 'com.example.ecommerceMiniApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR-API-KEY',
    appId: 'YOUR-APP-ID',
    messagingSenderId: 'YOUR-SENDER-ID',
    projectId: 'YOUR-PROJECT-ID',
    storageBucket: 'YOUR-STORAGE-BUCKET',
    iosClientId: 'YOUR-IOS-CLIENT-ID',
    iosBundleId: 'YOUR-IOS-BUNDLE-ID',
  );
}
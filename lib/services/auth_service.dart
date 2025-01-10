// lib/services/auth_service.dart
import 'package:flutter/foundation.dart'; // Pastikan ini ada
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Tambahkan Firebase Firestore

class AuthService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _secureStorage = const FlutterSecureStorage();
  User? _user;

  User? get user => _user;

  AuthService() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners(); // Notifikasi jika ada perubahan pada user
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String role, // Tambahkan role di sini
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    _user = credential.user;

    if (_user != null) {
      // Simpan informasi role di Firestore
      await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
        'email': email,
        'role': role,  // Simpan role di Firestore
      });

      // Simpan UID di secure storage
      await _secureStorage.write(key: 'uid', value: _user!.uid);
    }
    notifyListeners();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    _user = credential.user;
    if (_user != null) {
      await _secureStorage.write(key: 'uid', value: _user!.uid);
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _secureStorage.delete(key: 'uid');
    _user = null;
    notifyListeners();
  }
}

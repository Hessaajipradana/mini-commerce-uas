// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/add_product_screen.dart'; // Impor layar AddProductScreen
import 'services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahkan Firebase Firestore

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>( // Menambahkan tipe generik untuk AuthService
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'Mini E-commerce',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const AuthWrapper(), // Ganti initialRoute dengan AuthWrapper
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/products': (context) => const ProductListScreen(),
          '/cart': (context) => const CartScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/add-product': (context) => const AddProductScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).user;

    // Jika pengguna sudah login, cek role-nya dan arahkan sesuai role
    if (user != null) {
      return FutureBuilder<DocumentSnapshot>(  // Cek data pengguna di Firestore
        future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading screen
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching user data'));
          }

          final userData = snapshot.data?.data() as Map<String, dynamic>?;

          if (userData == null) {
            return const Center(child: Text('User data is empty'));
          }

          final userRole = userData['role']; // Ambil role dari data pengguna

          // Arahkan berdasarkan role pengguna
          if (userRole == 'admin') {
            return const HomeScreen(); // Admin dapat mengakses HomeScreen (admin page)
          } else {
            return const HomeScreen(); // Pengguna biasa juga diarahkan ke HomeScreen
          }
        },
      );
    } else {
      return const LoginScreen(); // Jika belum login, arahkan ke LoginScreen
    }
  }
}

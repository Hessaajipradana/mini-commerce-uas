import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Tambahkan import ini

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).user;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error fetching user data',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }

        final userData = snapshot.data?.data() as Map<String, dynamic>?;
        final userRole = userData?['role'];
        final isAdmin = userRole == 'admin';

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Mini E-commerce',
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(color: Colors.blue[800]),
            actions: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: isAdmin ? Colors.grey : Colors.blue[800]),
                onPressed: isAdmin ? null : () => Navigator.pushNamed(context, '/cart'),
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.blue[800]),
                onPressed: () => Navigator.pushNamed(context, '/profile'),
              ),
              if (isAdmin)
                IconButton(
                  icon: Icon(Icons.add, color: Colors.blue[800]),
                  onPressed: () => Navigator.pushNamed(context, '/add-product'),
                ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildWelcomeSection(userData, isAdmin),
                    const SizedBox(height: 32),
                    _buildQuickActionGrid(context, isAdmin),
                    const SizedBox(height: 32),
                    _buildStatisticsSection(context, isAdmin),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeSection(Map<String, dynamic>? userData, bool isAdmin) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Welcome, ${userData?['email']?.split('@')[0] ?? 'User'}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isAdmin ? 'Admin Dashboard' : 'Customer Portal',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionGrid(BuildContext context, bool isAdmin) {
    final actions = isAdmin
      ? [
          _buildQuickActionCard(
            context: context,
            icon: Icons.add_box_outlined,
            title: 'Add Product',
            onTap: () => Navigator.pushNamed(context, '/add-product'),
          ),
          _buildQuickActionCard(
            context: context,
            icon: Icons.list_alt,
            title: 'Manage Products',
            onTap: () => Navigator.pushNamed(context, '/products'),
          ),
        ]
      : [
          _buildQuickActionCard(
            context: context,
            icon: Icons.shopping_bag_outlined,
            title: 'Products',
            onTap: () => Navigator.pushNamed(context, '/products'),
          ),
          _buildQuickActionCard(
            context: context,
            icon: Icons.shopping_cart_outlined,
            title: 'My Cart',
            onTap: () => Navigator.pushNamed(context, '/cart'),
          ),
        ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: actions,
    );
  }

  Widget _buildQuickActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue[100]!,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.blue[800],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(BuildContext context, bool isAdmin) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAdmin ? 'System Overview' : 'Your Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            // Statistik Produk
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context, snapshot) {
                int productCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
                return _buildStatisticRow(
                  icon: Icons.shopping_bag,
                  label: isAdmin ? 'Total Products' : 'Products Viewed',
                  value: productCount.toString(),
                );
              },
            ),
            // Statistik Keranjang
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cart_items')
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid) // Perbaikan di sini
                  .snapshots(),
              builder: (context, snapshot) {
                int cartItemCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
                return _buildStatisticRow(
                  icon: Icons.shopping_cart,
                  label: 'Items in Cart',
                  value: cartItemCount.toString(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildStatisticRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue[800]),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.blue[800],
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
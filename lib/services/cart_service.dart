import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_ecommerce/models/cart_item.dart';

class CartService {
  // Fungsi untuk menambahkan item ke dalam keranjang
  Future<void> addItemToCart(String userId, CartItem cartItem) async {
    final cartRef = FirebaseFirestore.instance
        .collection('users')  // Koleksi "users"
        .doc(userId)           // Dokumen pengguna berdasarkan userId
        .collection('cartItems')  // Subkoleksi "cartItems" di bawah dokumen pengguna
        .doc(cartItem.id);       // ID item keranjang

    await cartRef.set({
      'userId': userId,
      'productRef': FirebaseFirestore.instance
          .collection('products')
          .doc(cartItem.productId),  // Menyimpan referensi produk
      'quantity': cartItem.quantity,
      'createdAt': Timestamp.fromDate(cartItem.createdAt),
    });

    print("Item added to cart successfully");
  }
}

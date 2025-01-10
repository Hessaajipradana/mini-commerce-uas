import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_ecommerce/models/product.dart';

class ProductService {
  // Fungsi untuk menambahkan produk baru ke Firestore
  Future<void> addProduct(Product product) async {
    final productRef = FirebaseFirestore.instance.collection('products').doc();

    await productRef.set({
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'stock': product.stock,
    });

    print("Product added successfully");
  }
}

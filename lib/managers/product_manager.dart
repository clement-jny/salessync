import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salessync/models/product.dart';

class ProductManager {
  ProductManager._privateConstructor();
  static final ProductManager instance = ProductManager._privateConstructor();

  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');

  Future<ProductModel> getProductById(String productId) async {
    final DocumentSnapshot productSnapshot =
        await _productsCollection.doc(productId).get();

    return ProductModel.fromFirestore(productSnapshot);
  }

  Future<List<ProductModel>> getAllProducts() async {
    final QuerySnapshot productsSnapshot = await _productsCollection.get();

    return productsSnapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc))
        .toList();
  }

  // Future<void> createProduct(ProductModel product) async {
  //   await _productsCollection.add({
  //     'name': product.name,
  //     'description': product.description,
  //     'price': product.price,
  //   });
  // }

  // Future<void> updateProduct(ProductModel product) async {
  //   await _productsCollection.doc(product.id).update({
  //     'name': product.name,
  //     'description': product.description,
  //     'price': product.price,
  //   });
  // }

  // Future<void> deleteProduct(String productId) async {
  //   await _productsCollection.doc(productId).delete();
  // }
}

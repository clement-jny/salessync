import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salessync/models/sale.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final int price;

  // Relationship
  List<SaleModel> sales; // associated sales for the product

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    List<SaleModel>? sales,
  }) : sales = sales ?? [];

  ProductModel.empty()
      : id = '',
        name = '',
        description = '',
        price = 0,
        sales = [];

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    return ProductModel(
      id: doc.id,
      name: doc['name'],
      description: doc['description'],
      price: doc['price'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
    };
  }
}

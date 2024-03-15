import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salessync/models/product.dart';
import 'package:salessync/models/sale.dart';

class ProductSaleModel {
  final String id;
  final String productId;
  final String saleId;

  // Relationship
  ProductModel product; // associated product for the sale
  SaleModel sale; // associated sale for the product

  ProductSaleModel({
    required this.id,
    required this.productId,
    required this.saleId,
    ProductModel? product,
    SaleModel? sale,
  })  : product = product ?? ProductModel.empty(),
        sale = sale ?? SaleModel.empty();

  ProductSaleModel.empty()
      : id = '',
        productId = '',
        saleId = '',
        product = ProductModel.empty(),
        sale = SaleModel.empty();

  factory ProductSaleModel.fromFirestore(DocumentSnapshot doc) {
    return ProductSaleModel(
      id: doc.id,
      productId: doc['productId'],
      saleId: doc['saleId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'productId': productId,
      'saleId': saleId,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salessync/managers/product_manager.dart';
import 'package:salessync/managers/sale_manager.dart';
import 'package:salessync/models/product.dart';
import 'package:salessync/models/sale.dart';

class ProductSaleManager {
  ProductSaleManager._privateConstructor();
  static final ProductSaleManager instance =
      ProductSaleManager._privateConstructor();

  final CollectionReference _productsSalesCollection =
      FirebaseFirestore.instance.collection('productsSales');

  Future<List<SaleModel>> getSalesForProduct(String productId) async {
    final QuerySnapshot productsSalesSnapshot = await _productsSalesCollection
        .where('productId', isEqualTo: productId)
        .get();

    final List<SaleModel> sales = [];

    await Future.wait(productsSalesSnapshot.docs.map((productSale) async {
      final String saleId = productSale['saleId'];
      final SaleModel sale = await SaleManager.instance.getSaleById(saleId);

      sales.add(sale);
    }).toList());

    return sales;
  }

  Future<List<ProductModel>> getProductsForSale(String saleId) async {
    final QuerySnapshot productsSalesSnapshot =
        await _productsSalesCollection.where('saleId', isEqualTo: saleId).get();

    final List<ProductModel> products = [];

    await Future.wait(productsSalesSnapshot.docs.map(
      (productSale) async {
        final String productId = productSale['productId'];
        final ProductModel product =
            await ProductManager.instance.getProductById(productId);

        products.add(product);
      },
    ).toList());

    return products;
  }

  Future<Map<String, dynamic>> createProductSale(
      String productId, String saleId) async {
    try {
      await _productsSalesCollection.add(
        {
          'productId': productId,
          'saleId': saleId,
        },
      );

      return {'success': true, 'message': 'Correctly added'};
    } catch (e) {
      print('Error adding product sale: $e');
      return {'success': false, 'message': 'Failed to create product sale'};
    }
  }
}

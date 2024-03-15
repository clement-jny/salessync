import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salessync/managers/product_manager.dart';
import 'package:salessync/managers/product_sale_manager.dart';
import 'package:salessync/managers/sale_manager.dart';
import 'package:salessync/models/product.dart';
import 'package:salessync/services/message_service.dart';

class AddSaleScreen extends StatefulWidget {
  const AddSaleScreen({super.key});

  @override
  State<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  List<ProductModel> selectedProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    allProducts = await ProductManager.instance.getAllProducts();
    setState(
      () {
        filteredProducts = allProducts;
      },
    );
  }

  void _filterProducts(String searchText) {
    setState(
      () {
        filteredProducts = allProducts.where(
          (product) {
            return product.name
                .toLowerCase()
                .contains(searchText.toLowerCase());
          },
        ).toList();
      },
    );
  }

  Future<void> _addSale() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final newSaleResult =
          await SaleManager.instance.createSaleForUser(firebaseUser.uid);

      if (newSaleResult['success']) {
        final String saleId = newSaleResult['saleId'];

        final List<ProductModel> copiedSelectedProducts =
            List.from(selectedProducts);

        for (final ProductModel product in copiedSelectedProducts) {
          await ProductSaleManager.instance
              .createProductSale(product.id, saleId);

          setState(
            () {
              selectedProducts.clear();
            },
          );

          MessageService.instance
              .showMessage(context, newSaleResult['message']);

          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        MessageService.instance.showMessage(context, newSaleResult['message']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sale'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _searchController,
              onChanged: _filterProducts,
              decoration: const InputDecoration(
                labelText: 'Search...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Products:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return CheckboxListTile(
                    title: Text(
                        '${product.name} - \$${product.price.toStringAsFixed(2)}'),
                    subtitle: Text(product.description),
                    value: selectedProducts.contains(product),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value != null && value) {
                          selectedProducts.add(product);
                        } else {
                          selectedProducts.remove(product);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _addSale();
                },
                child: const Text('Add Sale'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

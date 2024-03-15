import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salessync/managers/product_sale_manager.dart';
import 'package:salessync/managers/sale_manager.dart';
import 'package:salessync/models/product.dart';
import 'package:salessync/models/sale.dart';
import 'package:salessync/models/sale_detail_screen_argument.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final User? firebaseUser = FirebaseAuth.instance.currentUser;
  List<SaleModel> sales = [];

  @override
  void initState() {
    super.initState();
    _fetchSales();
  }

  Future<void> _fetchSales() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      final fetchedSales =
          await SaleManager.instance.getSalesForUser(firebaseUser.uid);

      setState(() {
        sales = fetchedSales;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Here are your last sales',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: sales.length,
                itemBuilder: (context, index) {
                  final SaleModel sale = sales[index];
                  return ListTile(
                    title: Text(sale.date.toString()),
                    subtitle: FutureBuilder<List<ProductModel>>(
                      future: ProductSaleManager.instance
                          .getProductsForSale(sale.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        sale.products = snapshot.data!;
                        final total = snapshot.data!.fold<double>(
                          0,
                          (previousValue, element) =>
                              previousValue + element.price,
                        );

                        return Text(
                          'Total: \$${total.toStringAsFixed(2)}',
                        );
                      },
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/sale',
                        arguments: SaleDetailScreenArgumentModel(
                          sale: sale,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

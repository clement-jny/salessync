import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:salessync/models/product.dart';
import 'package:salessync/models/sale.dart';
import 'package:salessync/models/sale_detail_screen_argument.dart';

class SaleDetailScreen extends StatelessWidget {
  const SaleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)!.settings.arguments
        as SaleDetailScreenArgumentModel;

    final SaleModel sale = argument.sale;

    return Scaffold(
      appBar: AppBar(
        title: Text(argument.sale.date.toString()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Products:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: sale.products.length,
                itemBuilder: (context, index) {
                  final ProductModel product = sale.products[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text(product.description),
                      trailing: Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salessync/models/enums/sale_status.dart';
import 'package:salessync/models/sale.dart';

class SaleManager {
  SaleManager._privateConstructor();
  static final SaleManager instance = SaleManager._privateConstructor();

  final CollectionReference _salesCollection =
      FirebaseFirestore.instance.collection('sales');

  Future<SaleModel> getSaleById(String saleId) async {
    final DocumentSnapshot saleSnapshot =
        await _salesCollection.doc(saleId).get();

    return SaleModel.fromFirestore(saleSnapshot);
  }

  Future<List<SaleModel>> getSalesForUser(String userId) async {
    final QuerySnapshot salesSnapshot =
        await _salesCollection.where('userId', isEqualTo: userId).get();

    return salesSnapshot.docs
        .map((doc) => SaleModel.fromFirestore(doc))
        .toList();
  }

  Future<Map<String, dynamic>> createSaleForUser(String userId) async {
    try {
      final DocumentReference saleDocRef = await _salesCollection.add(
        {
          'status': SaleStatus.newSale.name,
          'date': DateTime.now(),
          'userId': userId,
        },
      );

      return {
        'success': true,
        'message': 'Correctly added',
        'saleId': saleDocRef.id
      };
    } catch (e) {
      print('Error creating sale: $e');
      return {'success': false, 'message': 'Failed to create sale'};
    }
  }
}

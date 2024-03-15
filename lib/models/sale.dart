import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salessync/models/enums/sale_status.dart';
import 'package:salessync/models/product.dart';
import 'package:salessync/models/user.dart';

class SaleModel {
  final String id;
  final SaleStatus status;
  final DateTime date;
  final String userId;

  // Relationship
  UserModel user; // associated user for the sale
  List<ProductModel> products; // associated products for the sale

  SaleModel({
    required this.id,
    required this.status,
    required this.date,
    required this.userId,
    UserModel? user,
    List<ProductModel>? products,
  })  : user = user ?? UserModel.empty(),
        products = products ?? [];

  SaleModel.empty()
      : id = '',
        status = SaleStatus.newSale,
        date = DateTime.now(),
        userId = '',
        user = UserModel.empty(),
        products = [];

  factory SaleModel.fromFirestore(DocumentSnapshot doc) {
    return SaleModel(
      id: doc.id,
      status: _parseSaleStatus(doc['status']),
      date: doc['date'].toDate(),
      userId: doc['userId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'status': status.name,
      'date': date,
      'userId': userId,
    };
  }

  static SaleStatus _parseSaleStatus(String status) {
    switch (status) {
      case 'sold':
        return SaleStatus.sold;
      case 'technicalVisitValid':
        return SaleStatus.technicalVisitValid;
      case 'financingValid':
        return SaleStatus.financingValid;
      case 'canceled':
        return SaleStatus.canceled;
      default:
        return SaleStatus.newSale;
    }
  }
}

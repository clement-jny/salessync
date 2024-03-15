import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salessync/models/enums/user_role.dart';
import 'package:salessync/models/sale.dart';

class UserModel {
  final String id;
  final String lastname;
  final String firstname;
  final UserRole role;

  // Relationship
  List<SaleModel> sales; // associated sales for the user

  UserModel({
    required this.id,
    required this.lastname,
    required this.firstname,
    required this.role,
    List<SaleModel>? sales,
  }) : sales = sales ?? [];

  UserModel.empty()
      : id = '',
        lastname = '',
        firstname = '',
        role = UserRole.commercial,
        sales = [];

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      lastname: doc['lastname'],
      firstname: doc['firstname'],
      role: _parseUserRole(doc['role']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'lastname': lastname,
      'firstname': firstname,
      'role': role.name,
    };
  }

  bool isEmpty() {
    return id.isEmpty;
  }

  static UserRole _parseUserRole(String role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'commercial':
        return UserRole.commercial;
      case 'technician':
        return UserRole.technician;
      default:
        return UserRole.commercial;
    }
  }
}

// UserModel currentUser : UserModel(
//   id: firestore.instance.collection('users').doc().get('uuid'),
//   lastname: firestore.instance.collection('users').doc().get('lastname'),
//   firstname: firestore.instance.collection('users').doc().get('firstname'),
//   role: firestore.instance.collection('users').doc().get('role')
//   sales: firestore.instance.collection('sales').doc().get('sales_for_user'),
// );
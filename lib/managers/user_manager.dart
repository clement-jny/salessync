import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salessync/models/user.dart';

class UserManager {
  UserManager._privateConstructor();
  static final UserManager instance = UserManager._privateConstructor();

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<UserModel> getUserById(String userId) async {
    try {
      final DocumentSnapshot userSnapshot =
          await _usersCollection.doc(userId).get();
      return UserModel.fromFirestore(userSnapshot);
    } catch (e) {
      print('Erreur lors de la récupération de l\'utilisateur: $e');

      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).update(user.toFirestore());
      return {'success': true, 'message': 'Correctly modified'};
    } catch (e) {
      print('Error updating user: $e');
      return {'success': false, 'message': 'Failed to update user'};
    }
  }
}

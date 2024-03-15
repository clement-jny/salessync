import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salessync/managers/user_manager.dart';
import 'package:salessync/models/user.dart';
import 'package:salessync/services/auth_service.dart';
import 'package:salessync/services/message_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Stream<DocumentSnapshot> _userStream;
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserModel user = UserModel.empty();
  bool _isEditMode = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      user = await UserManager.instance.getUserById(firebaseUser.uid);

      _userStream = FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .snapshots();
    }

    setState(() {});
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  Future<void> _updateData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      UserModel newUser = UserModel(
          id: user.id,
          lastname: _lastnameController.text,
          firstname: _firstnameController.text,
          role: user.role);

      UserManager.instance.updateUser(newUser).then(
        (result) {
          setState(() {
            _isLoading = false;
          });

          if (result['success']) {
            MessageService.instance.showMessage(context, result['message']);
          } else {
            MessageService.instance.showMessage(context, result['message']);
          }
        },
      );
    }
  }

  void _logout() {
    AuthService.instance.logoutUser().then(
      (result) {
        if (result['success']) {
          MessageService.instance.showMessage(context, result['message']);
        } else {
          MessageService.instance.showMessage(context, result['message']);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Welcome ${snapshot.data!['firstname']} ${snapshot.data!['lastname']}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.edit,
                ),
                tooltip: 'Edit infos',
                onPressed: _toggleEditMode,
              ),
              IconButton(
                icon: const Icon(
                  Icons.logout,
                ),
                tooltip: 'Logout',
                onPressed: _logout,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Update your informations',
                      style: TextStyle(
                        fontSize: 24,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _lastnameController,
                    enabled: _isEditMode,
                    decoration: const InputDecoration(
                      labelText: 'Lastname',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your lastname';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _firstnameController,
                    enabled: _isEditMode,
                    decoration: const InputDecoration(
                      labelText: 'Firstname',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your firstname';
                      }
                      return null;
                    },
                  ),
                  if (_isEditMode) ...[
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateData,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Validate'),
                    ),
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

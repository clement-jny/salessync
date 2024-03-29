import 'package:flutter/material.dart';

class MessageService {
  MessageService._privateConstructor();
  static final MessageService instance = MessageService._privateConstructor();

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

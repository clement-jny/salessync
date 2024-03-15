import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:salessync/firebase_options.dart';
import 'package:salessync/screens/add_sale_screen.dart';
import 'package:salessync/screens/sale_detail_screen.dart';
import 'package:salessync/widgets/auth_gate.dart';
import 'package:salessync/widgets/home_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SalesSync',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
      routes: {
        '/home': (context) => const HomeLayout(),
        '/sale': (context) => const SaleDetailScreen(),
        '/add-sale': (context) => const AddSaleScreen(),
      },
    );
  }
}

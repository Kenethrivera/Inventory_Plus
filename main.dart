import 'package:flutter/material.dart';
import 'login_page.dart';
import 'admin_page.dart';
import 'staff_page.dart';
import 'checkout_page.dart';

void main() {
  runApp(const InventoryPlusApp());
}

class InventoryPlusApp extends StatelessWidget {
  const InventoryPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Plus',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/admin': (context) => const AdminPage(),
        '/staff': (context) => const StaffPage(),
        '/checkout': (context) => const CheckoutPage(),
      },
    );
  }
}
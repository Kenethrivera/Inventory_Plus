import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Your specific import paths based on your folder structure
import 'desktop_workspace/view/pages/login_page.dart';
import 'desktop_workspace/view/pages/admin_page.dart';
import 'desktop_workspace/view/pages/staff_page.dart';
import 'desktop_workspace/checkout_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file from your specific path!
  await dotenv.load(fileName: "lib/desktop_workspace/.env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const InventoryPlusApp());
}

class InventoryPlusApp extends StatelessWidget {
  const InventoryPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Plus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
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

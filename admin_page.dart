import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;

  final List<Widget> _panels = [
    const Center(child: Text('Products Management: View, Search, Add, Edit, Delete, QR Gen')),
    const Center(child: Text('Staff Management: Add, Edit, Delete')),
    const Center(child: Text('Checkout History & Revert')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/checkout'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.inventory), label: Text('Products')),
              NavigationRailDestination(icon: Icon(Icons.people), label: Text('Staff')),
              NavigationRailDestination(icon: Icon(Icons.history), label: Text('History')),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _panels[_selectedIndex],
          ),
        ],
      ),
    );
  }
}

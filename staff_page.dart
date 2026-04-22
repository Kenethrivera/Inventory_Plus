import 'package:flutter/material.dart';
import 'models.dart'; // Ensures we are using the Product model we created

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  // Mock data for products to populate the UI
  final List<Product> _allProducts = [
    Product(id: '1', name: 'Beaker 500ml', size: '500ml', location: 'Lab A', quantity: 50, price: 15.0),
    Product(id: '2', name: 'Safety Goggles', size: 'Universal', location: 'Cabinet B', quantity: 20, price: 8.50),
    Product(id: '3', name: 'Bunsen Burner', size: 'Standard', location: 'Lab C', quantity: 15, price: 45.0),
    Product(id: '4', name: 'Petri Dish', size: '100mm', location: 'Storage 1', quantity: 200, price: 1.20),
  ];

  List<Product> _displayedProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initially display all products
    _displayedProducts = _allProducts;
  }

  // Function to handle typed search
  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _displayedProducts = _allProducts;
      } else {
        _displayedProducts = _allProducts
            .where((product) => 
                product.name.toLowerCase().contains(query.toLowerCase()) || 
                product.id.contains(query)) // Checking ID simulates searching by QR text
            .toList();
      }
    });
  }

  // Placeholder for QR Code Scanner
  void _scanQR() {
    // In a full build, this would launch a package like 'mobile_scanner'
    // For now, we mock the interaction.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('QR Scanner camera would open here.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Dashboard - Inventory Plus'),
        actions: [
          // Navigates to the Checkout Page we built earlier
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Go to Checkout',
            onPressed: () => Navigator.pushNamed(context, '/checkout'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // --- Search Bar and QR Button Area ---
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterProducts,
                    decoration: InputDecoration(
                      hintText: 'Search products by name or scan QR text...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _scanQR,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Scan QR'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // --- Product Display Grid ---
            Expanded(
              child: _displayedProducts.isEmpty
                  ? const Center(child: Text('No products found matching your search.'))
                  : GridView.builder(
                      // Responsive grid that adjusts columns based on web browser width
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300, // Max width of a single product card
                        childAspectRatio: 0.75, // Ratio of width to height
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _displayedProducts.length,
                      itemBuilder: (context, index) {
                        final product = _displayedProducts[index];
                        return Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Placeholder for an optional Product Image
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8.0)
                                    ),
                                    width: double.infinity,
                                    child: const Icon(Icons.image, size: 50, color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Product Details
                                Text(
                                  product.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text('Size: ${product.size}', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                                Text('Loc: ${product.location}', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Stock: ${product.quantity}', style: const TextStyle(fontWeight: FontWeight.w500)),
                                    Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                                  ],
                                ),
                                const Spacer(),
                                // Add to Checkout Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // In a full app, this would add the item to a global state cart provider
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${product.name} queued for checkout!')),
                                      );
                                    },
                                    child: const Text('Check Out Item'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
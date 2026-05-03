// lib/desktop_workspace/inventory_view.dart
import 'package:flutter/material.dart';
import '../../controllers/inventory_controller.dart';

class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {

  // --- ADD PRODUCT MODAL ---
  void _showAddProductDialog() {
    final nameCtrl = TextEditingController();
    final skuCtrl = TextEditingController();
    final categoryCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final locCtrl = TextEditingController();
    final imgCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Product',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _darkText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter the details for the new inventory item.',
                    style: TextStyle(color: _greyText, fontSize: 14),
                  ),
                  const SizedBox(height: 32),

                  _buildModalTextField(
                    controller: nameCtrl,
                    label: 'Product Name',
                    hint: 'e.g. 20V Max Drill',
                    icon: Icons.build_circle_outlined,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildModalTextField(
                          controller: skuCtrl,
                          label: 'SKU',
                          hint: 'e.g. DCD771C2',
                          icon: Icons.qr_code,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildModalTextField(
                          controller: categoryCtrl,
                          label: 'Category',
                          hint: 'e.g. Power Tools',
                          icon: Icons.category_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildModalTextField(
                          controller: priceCtrl,
                          label: 'Price (\₱)',
                          hint: '0.00',
                          icon: Icons.payments_outlined,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildModalTextField(
                          controller: qtyCtrl,
                          label: 'Quantity',
                          hint: '0',
                          icon: Icons.numbers,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildModalTextField(
                    controller: locCtrl,
                    label: 'Location in Store',
                    hint: 'e.g. A1-3',
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildModalTextField(
                    controller: imgCtrl,
                    label: 'Image URL (Optional)',
                    hint: 'https://...',
                    icon: Icons.image_outlined,
                  ),

                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: _greyText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          final success = await _inventoryController
                              .addProduct({
                                'product_name': nameCtrl.text.trim(),
                                'sku': skuCtrl.text.trim(),
                                'category': categoryCtrl.text.trim(),
                                'product_price': priceCtrl.text.trim(),
                                'product_quantity': qtyCtrl.text.trim(),
                                'product_location': locCtrl.text.trim(),
                                'image_url': imgCtrl.text.trim(),
                              });

                          if (success && context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Product Added!')),
                            );
                          }
                        },
                        child: const Text(
                          'Save Product',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: _darkText),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _greyText),
        hintText: hint,
        hintStyle: TextStyle(color: _greyText.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: _primaryOrange, size: 20),
        filled: true,
        fillColor: _mainBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryOrange, width: 2),
        ),
      ),
    );
  }
  final _inventoryController = InventoryController();

  // Colors mapped from your admin page
  static const Color _primaryOrange = Color(0xFFEA580C);
  static const Color _cardBg = Colors.white;
  static const Color _mainBg = Color(0xFFF1F5F9);
  static const Color _darkText = Color(0xFF1E293B);
  static const Color _greyText = Color(0xFF64748B);
  static const Color _activeChipBg = Color(0xFF1E293B);
  static const Color _redAlert = Color(0xFFEF4444);

  @override
  void initState() {
    super.initState();
    _inventoryController.fetchProducts(); // Load data on start
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Inventory List',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _darkText,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddProductDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text(
                  'Add Item',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Search Bar
          TextField(
            onChanged: _inventoryController.updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search by name or SKU...',
              hintStyle: const TextStyle(color: _greyText),
              prefixIcon: const Icon(Icons.search, color: _greyText),
              filled: true,
              fillColor: _cardBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 20),

          // Filter Chips
          ListenableBuilder(
            listenable: _inventoryController,
            builder: (context, child) {
              return Row(
                children: [
                  _buildFilterChip('All'),
                  const SizedBox(width: 12),
                  _buildFilterChip('Power Tools'),
                  const SizedBox(width: 12),
                  _buildFilterChip('Hand Tools'),
                  const SizedBox(width: 12),
                  _buildFilterChip('Plumbing'),
                  const SizedBox(width: 12),
                  _buildFilterChip('Electrical'),
                  const SizedBox(width: 12),
                  _buildFilterChip('Fasteners'),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: 16),

          // Dynamic Count & Sort
          ListenableBuilder(
            listenable: _inventoryController,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Items Found (${_inventoryController.displayedProducts.length})',
                    style: const TextStyle(
                      color: _greyText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {}, // Sort logic can go here later
                    icon: const Icon(
                      Icons.swap_vert,
                      color: _greyText,
                      size: 18,
                    ),
                    label: const Text(
                      'Sort',
                      style: TextStyle(color: _greyText),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // Main Data Grid
          Expanded(
            child: ListenableBuilder(
              listenable: _inventoryController,
              builder: (context, child) {
                if (_inventoryController.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: _primaryOrange),
                  );
                }

                if (_inventoryController.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(
                      _inventoryController.errorMessage,
                      style: const TextStyle(color: _redAlert),
                    ),
                  );
                }

                if (_inventoryController.displayedProducts.isEmpty) {
                  return const Center(
                    child: Text(
                      'No products found matching your search.',
                      style: TextStyle(color: _greyText, fontSize: 16),
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 450,
                    mainAxisExtent: 145,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  itemCount: _inventoryController.displayedProducts.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(
                      _inventoryController.displayedProducts[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isActive = _inventoryController.activeCategory == label;
    return GestureDetector(
      onTap: () => _inventoryController.setCategory(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? _activeChipBg : _cardBg,
          borderRadius: BorderRadius.circular(20),
          border: isActive ? null : Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : _greyText,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    // Dynamic variables based on your SQL schema
    final String name = product['product_name'] ?? 'Unknown Item';
    final String sku = product['sku'] ?? 'N/A';
    final double price = (product['product_price'] as num?)?.toDouble() ?? 0.0;
    final int quantity = product['product_quantity'] as int? ?? 0;
    final String location = product['product_location'] ?? 'Unassigned';

    // ADDED: Extract the image URL from your database
    final String? imageUrl = product['image_url'];

    // Set a threshold for what constitutes "low stock"
    final bool isLowStock = quantity < 10;

    return Material(
      color: _cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 100,
              height: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: _mainBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                // ADDED: Forces the image to fill the entire container
                fit: StackFit.expand,
                children: [
                  // --- IMAGE DISPLAY LOGIC ---
                  if (imageUrl != null && imageUrl.isNotEmpty)
                    Image.network(
                      imageUrl,
                      fit: BoxFit
                          .cover, // Crops the image nicely to fit the 100x100 box
                      errorBuilder: (context, error, stackTrace) {
                        // If the link is broken, show the placeholder instead
                        return const Center(
                          child: Icon(
                            Icons.handyman,
                            size: 40,
                            color: Color(0xFFCBD5E1),
                          ),
                        );
                      },
                    )
                  else
                    // If there is no link in the database, show the placeholder
                    const Center(
                      child: Icon(
                        Icons.handyman,
                        size: 40,
                        color: Color(0xFFCBD5E1),
                      ),
                    ),

                  // --- LOW STOCK BADGE ---
                  if (isLowStock)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: _redAlert,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: const Text(
                          'LOW STOCK',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: _darkText,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\₱${price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _primaryOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'SKU: $sku',
                    style: const TextStyle(color: _greyText, fontSize: 13),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _mainBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.inventory_2,
                              size: 14,
                              color: isLowStock ? _redAlert : _greyText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$quantity in stock',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isLowStock ? _redAlert : _greyText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: _greyText,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: _greyText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

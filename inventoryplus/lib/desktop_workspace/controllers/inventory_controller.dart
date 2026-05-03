// lib/desktop_workspace/controllers/inventory_controller.dart
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InventoryController extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  // State variables
  List<Map<String, dynamic>> _allProducts = [];
  List<Map<String, dynamic>> displayedProducts = [];

  bool isLoading = false;
  String errorMessage = '';

  // Active filters
  String searchQuery = '';
  String activeCategory = 'All';

  Future<void> fetchProducts() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      // Fetch all products ordered alphabetically
      final data = await _supabase
          .from('products')
          .select()
          .order('product_name', ascending: true);

      _allProducts = List<Map<String, dynamic>>.from(data);
      _applyFilters(); // Initial filter to populate displayed list
    } catch (e) {
      errorMessage = 'Failed to load inventory: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Called whenever the user types in the search bar
  void updateSearchQuery(String query) {
    searchQuery = query;
    _applyFilters();
  }

  // Called whenever a category chip is clicked
  void setCategory(String category) {
    activeCategory = category;
    _applyFilters();
  }

  // The brains of the search/filter operation
  void _applyFilters() {
    displayedProducts = _allProducts.where((product) {
      // 1. Check Category
      final matchesCategory =
          activeCategory == 'All' || product['category'] == activeCategory;

      // 2. Check Search Query (matching name or SKU)
      final query = searchQuery.toLowerCase();
      final name = (product['product_name'] ?? '').toString().toLowerCase();
      final sku = (product['sku'] ?? '').toString().toLowerCase();
      final matchesSearch = name.contains(query) || sku.contains(query);

      return matchesCategory && matchesSearch;
    }).toList();

    notifyListeners();
  }

  // this code is for automated way of saving images (instead of manually uploading)
  // user will paste links at the add of product then the system will
  // download the image and save it to the bucket in SUPABASE
  // then the fetching will rely on the bucket not on the URL
  Future<String?> _ingestImageToSupabase(String internetUrl, String sku) async {
    try {
      // 1. Download the image from the internet into the app's memory
      final response = await http.get(Uri.parse(internetUrl));

      if (response.statusCode != 200) {
        print('Failed to download image from the web.');
        return null;
      }

      final imageBytes = response.bodyBytes;

      // 2. Create a clean file name using the SKU (e.g., "DCD771C2.jpg")
      final fileName = '$sku.jpg';

      // 3. Upload those bytes directly into your Supabase 'product-images' bucket
      await _supabase.storage
          .from('product-images')
          .uploadBinary(
            fileName,
            imageBytes,
            // Upsert means if you update the product with a new image, it overwrites the old one
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      // 4. Get your permanent, hosted public URL
      final publicUrl = _supabase.storage
          .from('product-images')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      print('Error ingesting image: $e');
      return null;
    }
  }


  Future<bool> addProduct(Map<String, dynamic> productData) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      await _supabase.from('products').insert({
        'sku': productData['sku'],
        'product_name': productData['product_name'],
        'category': productData['category'],
        'product_price':
            double.tryParse(productData['product_price'].toString()) ?? 0.0,
        'product_quantity':
            int.tryParse(productData['product_quantity'].toString()) ?? 0,
        'product_location': productData['product_location'],
        'image_url': productData['image_url'].toString().isEmpty
            ? null
            : productData['image_url'],
      });

      await fetchProducts(); // Refresh the list
      return true;
    } catch (e) {
      errorMessage = 'Failed to add product: ${e.toString()}';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

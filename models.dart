class Product {
  String id;
  String name;
  String size;
  String location;
  int quantity;
  double price;

  Product({required this.id, required this.name, required this.size, required this.location, required this.quantity, required this.price});
}

class CartItem {
  Product product;
  int quantity;
  double customPrice;

  CartItem({required this.product, required this.quantity, required this.customPrice});
  
  double get total => quantity * customPrice;
}
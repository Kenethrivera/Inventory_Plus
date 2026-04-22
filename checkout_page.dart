import 'package:flutter/material.dart';
import 'models.dart'; // Assume models are in this file

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Mock data for the cart
  List<CartItem> cart = [
    CartItem(
      product: Product(id: '1', name: 'Beaker 500ml', size: '500ml', location: 'Lab A', quantity: 50, price: 15.0),
      quantity: 2,
      customPrice: 15.0,
    )
  ];

  double get cartTotal => cart.fold(0, (sum, item) => sum + item.total);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Row(
        children: [
          // Left Side: Cart Items List
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(item.product.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Original Price: \$${item.product.price}'),
                        // Editable Custom Price
                        SizedBox(
                          width: 150,
                          child: TextFormField(
                            initialValue: item.customPrice.toString(),
                            decoration: const InputDecoration(labelText: 'Edit Checkout Price', prefixText: '\$'),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              setState(() => item.customPrice = double.tryParse(val) ?? item.product.price);
                            },
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit Quantity
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (item.quantity > 1) setState(() => item.quantity--);
                          },
                        ),
                        Text('${item.quantity}', style: const TextStyle(fontSize: 18)),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => item.quantity++),
                        ),
                        const SizedBox(width: 20),
                        Text('\$${item.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Right Side: Summary & Actions
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Order Summary', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Divider(),
                  Text('Total Items: ${cart.fold<int>(0, (sum, item) => sum + item.quantity)}'),
                  const SizedBox(height: 16),
                  Text('Total Price: \$${cartTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 28, color: Colors.green)),
                  const Spacer(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add Other Items'),
                    onPressed: () => Navigator.pop(context), // Go back to products page
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.all(20)),
                    onPressed: () {
                      // Process Checkout Logic Here
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checkout Successful!')));
                      setState(() => cart.clear());
                    },
                    child: const Text('Confirm Checkout', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () => setState(() => cart.clear()),
                    child: const Text('Cancel Checkout'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
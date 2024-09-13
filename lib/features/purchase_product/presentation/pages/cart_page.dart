import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lms/features/purchase_product/application/providers/cart_provider.dart';
import 'package:lms/features/purchase_product/domain/entities/product.dart';
import 'package:lms/features/purchase_product/presentation/pages/Check_out_Page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: ListView.builder(
        itemCount: cartProvider.cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = cartProvider.cartItems[index];
          return ListTile(
            title: Text(cartItem.product.name),
            subtitle: Text('Quantity: ${cartItem.quantity}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.update),
                  onPressed: () {
                    _showUpdateDialog(context, cartItem.product,
                        cartItem.quantity, cartProvider);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    cartProvider.removeProduct(cartItem.product);
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CheckoutPage()),
                  );
                },
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, Product product,
      int currentQuantity, CartProvider cartProvider) {
    final TextEditingController controller =
        TextEditingController(text: currentQuantity.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Quantity'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final int? newQuantity = int.tryParse(controller.text);
                if (newQuantity != null && newQuantity > 0) {
                  cartProvider.updateProductQuantity(product, newQuantity);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}

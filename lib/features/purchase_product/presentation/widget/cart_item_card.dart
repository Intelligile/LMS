import 'package:flutter/material.dart';
import '../../domain/entities/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final void Function(int) onQuantityUpdated;
  final VoidCallback onRemove;

  const CartItemCard({
    Key? key,
    required this.cartItem,
    required this.onQuantityUpdated,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(cartItem.product.name),
        subtitle: Row(
          children: [
            Text('Quantity: '),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: '${cartItem.quantity}'),
                onChanged: (value) {
                  final newQuantity = int.tryParse(value) ?? cartItem.quantity;
                  onQuantityUpdated(newQuantity);
                },
              ),
            ),
          ],
        ),
        trailing: Column(
          children: [
            Text(
                'Total: \$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}'),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

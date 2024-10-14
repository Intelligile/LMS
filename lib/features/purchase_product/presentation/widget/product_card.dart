import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lms/features/purchase_product/application/providers/cart_provider.dart';
import '../../domain/entities/product.dart';
import '../pages/cart_page.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _quantity = 1;

  void _showAddedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Product Added'),
          content: Text(
              '${widget.product.name} added to cart!\nQuantity: $_quantity'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to the cart page after adding the product
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => CartPage()));
              },
              child: Text('View Cart'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Continue Shopping'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.product.name),
        subtitle: Text('\$${widget.product.price}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  if (_quantity > 1) {
                    _quantity--;
                  }
                });
              },
            ),
            Text('$_quantity'),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _quantity++;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .addProduct(widget.product, _quantity);
                _showAddedDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

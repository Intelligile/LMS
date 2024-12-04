import 'package:flutter/material.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';
import 'package:lms/features/purchase_product/application/providers/cart_provider.dart';
import 'package:provider/provider.dart';

import '../pages/cart_page.dart';

class ProductCard extends StatefulWidget {
  final RegionProductModel product;

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Product Added'),
          content: Text(
            '${widget.product.name} added to cart!\nQuantity: $_quantity',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to the cart page after adding the product
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => CartPage()));
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    const Color(0xFF017278), // LMS color for button text
              ),
              child: const Text('View Cart'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.grey, // A neutral color for 'Continue Shopping'
              ),
              child: const Text('Continue Shopping'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6, // Shadow effect for card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners for the card
      ),
      shadowColor: Colors.black54, // Subtle shadow color for modern effect
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image placeholder (optional)
            // ClipRRect(
            //   borderRadius:
            //       BorderRadius.circular(12), // Rounded corners for image
            //   child: Image.network(
            //     widget.product.imageUrl,
            //     height: 150,
            //     width: double.infinity,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            const SizedBox(height: 12),
            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF017278), // LMS Color for product title
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '\$${widget.product.price}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey, // Grey color for the price
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Quantity control buttons
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      color: Colors.red, // Red for minus button
                      onPressed: () {
                        setState(() {
                          if (_quantity > 1) {
                            _quantity--;
                          }
                        });
                      },
                    ),
                    Text(
                      '$_quantity',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      color: Colors.green, // Green for add button
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                    ),
                  ],
                ),
                // Add to Cart button
                ElevatedButton.icon(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .addProduct(widget.product, _quantity);
                    _showAddedDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF017278),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

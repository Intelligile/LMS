import 'package:flutter/material.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final RegionProductModel product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      shadowColor: Colors.black26,
      child: SizedBox(
        width: 140, // Fixed width for a compact, rectangular design
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.network(
                product.imageUrl,
                height: 300, // Adjusted height for a compact layout
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
              child: Column(
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: product.name.length > 15
                          ? 12
                          : 14, // Dynamic font size
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF017278), // LMS color
                    ),
                    textAlign: TextAlign.center,
                    overflow:
                        TextOverflow.ellipsis, // Adds ellipsis for overflow
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
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

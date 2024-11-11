import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final RegionProductModel product;

  const ProductCard({
    super.key,
    required this.product,
  });

  // Function to map icon name to FontAwesome icon
  IconData iconFromName(String iconName) {
    switch (iconName) {
      case 'gears':
        return FontAwesomeIcons.gears;
      case 'code-fork':
        return FontAwesomeIcons.codeFork;
      case 'bank':
        return FontAwesomeIcons.buildingColumns;
      case 'cubes':
        return FontAwesomeIcons.cubes;
      case 'cloud':
        return FontAwesomeIcons.cloud;
      case 'street':
        return FontAwesomeIcons.streetView;
      case 'eye':
        return FontAwesomeIcons.eye;
      case 'ravelry':
        return FontAwesomeIcons.ravelry;
      default:
        return FontAwesomeIcons.questionCircle; // Default icon if not found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    iconFromName(product.imageUrl), // Dynamic icon
                    size: 20,
                    color: const Color(0xFF017278), // LMS color
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600, // Increased font weight
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$${product.price.toStringAsFixed(2)} / license',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.description.length > 50
                  ? '${product.description.substring(0, 50)}...'
                  : product.description,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

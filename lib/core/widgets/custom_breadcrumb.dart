import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBreadcrumb extends StatelessWidget {
  final List<String> items;
  final Function(int) onTap;

  const CustomBreadcrumb({super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(items.length, (index) {
          return Row(
            children: [
              InkWell(
                onTap: () => onTap(index),
                child: Text(
                  items[index],
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              if (index < items.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(
                    FontAwesomeIcons.greaterThan,
                    size: 14,
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

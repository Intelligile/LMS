import 'package:flutter/material.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';

class ProductListView extends StatefulWidget {
  final List<RegionProductModel> productList;

  const ProductListView({super.key, required this.productList});

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  void _deleteProduct(int index) {
    setState(() {
      widget.productList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      body: ListView.builder(
        itemCount: widget.productList.length,
        itemBuilder: (context, index) {
          final product = widget.productList[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('Price: \$${product.price.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteProduct(index);
              },
            ),
          );
        },
      ),
    );
  }
}

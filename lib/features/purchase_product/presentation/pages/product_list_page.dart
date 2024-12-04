import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';
import 'package:lms/features/product_region_management/presentation/manager/product_cubit/product_cubit.dart';
import 'package:lms/features/purchase_product/application/providers/cart_provider.dart';
import 'package:lms/features/purchase_product/presentation/widget/product_card.dart';
import 'package:provider/provider.dart';

import 'cart_page.dart'; // Import the CartPage

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<RegionProductModel> products = [];

  @override
  Widget build(BuildContext context) {
    context.read<ProductCubit>().getAllProducts();
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          // Show Cart Icon aligned to the right
          Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: Stack(
              children: [
                IconButton(
                  iconSize: 28,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                ),
                // Display the badge with the cart item count
                if (cartProvider.cartItems.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cartProvider.cartItems.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is GetAllProductsFailureState) {
            showSnackBar(context, state.errorMsg, Colors.red);
          } else if (state is GetAllProductsSuccessState) {
            products = state.products;
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Product List Section
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

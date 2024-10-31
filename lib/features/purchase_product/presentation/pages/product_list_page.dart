import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/widgets/adaptive_layout_widget.dart';
import 'package:lms/core/widgets/custom_breadcrumb.dart';
import 'package:lms/core/widgets/custom_scaffold.dart';
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
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        body: AdaptiveLayout(
      mobileLayout: (context) => const SizedBox(),
      tabletLayout: (context) => const SizedBox(),
      desktopLayout: (context) => const ProductListPageBody(),
    ));
  }
}

class AppBarActions extends StatelessWidget {
  const AppBarActions({
    super.key,
    required this.cartProvider,
  });

  final CartProvider cartProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
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
      ],
    );
  }
}

class ProductListPageBody extends StatelessWidget {
  const ProductListPageBody({
    super.key,
  });
  static List<RegionProductModel> products = [];
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    context.read<ProductCubit>().getAllProducts();
    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is GetAllProductsFailureState) {
          showSnackBar(context, state.errorMsg, Colors.red);
        } else if (state is GetAllProductsSuccessState) {
          products = state.products;
        }
      },
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: CustomBreadcrumb(
                items: const ['Home', 'Purshase proudct'],
                onTap: (index) {
                  // Add navigation logic based on index
                  if (index == 0) {
                    GoRouter.of(context).go(AppRouter.kHomeView);
                  } else if (index == 1) {
                    // Navigate to Active Users
                  }
                },
              ),
            ),
            const Expanded(child: SizedBox()),
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  AppBarActions(
                    cartProvider: cartProvider,
                  ),
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
              ),
            ),
            const Expanded(flex: 3, child: SizedBox()),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/widgets/adaptive_layout_widget.dart';
import 'package:lms/core/widgets/custom_scaffold.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';
import 'package:lms/features/product_region_management/presentation/manager/product_cubit/product_cubit.dart';
import 'package:lms/features/purchase_product/presentation/widget/product_card.dart';

import 'product_detail_page.dart';

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
      ),
    );
  }
}

class ProductListPageBody extends StatelessWidget {
  const ProductListPageBody({super.key});
  static List<RegionProductModel> products = [];

  @override
  Widget build(BuildContext context) {
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
        return Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: 600), // Limits grid width
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Prevents inner scroll in grid
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns in the grid
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8, // More compact aspect ratio
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(product: product),
                        ),
                      );
                    },
                    child: ProductCard(
                      product: product,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

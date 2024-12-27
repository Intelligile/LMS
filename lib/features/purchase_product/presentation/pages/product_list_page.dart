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
        mobileLayout: (context) => const ProductListPageBody(),
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
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0), // Padding around the content
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add the breadcrumb at the top
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: CustomBreadcrumb(
                    items: const ['Home', 'Purchase Product'],
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
                const SizedBox(height: 16), // Add spacing after breadcrumb
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing:
                        MediaQuery.sizeOf(context).width > 600 ? 16 : 8,
                    crossAxisSpacing:
                        MediaQuery.sizeOf(context).width > 600 ? 16 : 8,
                    childAspectRatio:
                        MediaQuery.sizeOf(context).width > 600 ? 2.5 : 1,
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
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';
import 'package:lms/features/product_region_management/data/models/region_model.dart';
import 'package:lms/features/product_region_management/presentation/manager/product_cubit/product_cubit.dart';
import 'package:lms/features/product_region_management/presentation/manager/region_cubit/region_cubit.dart';
import 'package:lms/features/product_region_management/presentation/views/product_form.dart';

class ProductManagementView extends StatefulWidget {
  List<RegionProductModel> productList = [];
  List<RegionModel> regionList = [];

  ProductManagementView(
      {super.key, this.productList = const [], this.regionList = const []});

  @override
  _ProductManagementViewState createState() => _ProductManagementViewState();
}

class _ProductManagementViewState extends State<ProductManagementView> {
  late RegionModel _selectedRegion;
  int? deletingProductId;

  @override
  void initState() {
    super.initState();
    _selectedRegion = RegionModel(id: 0, name: 'All');
    _fetchInitialData();
  }

  void _fetchInitialData() {
    context.read<RegionCubit>().getAllRegions();
    context.read<ProductCubit>().getAllProducts();
  }

  List<RegionProductModel> _getFilteredProducts() {
    if (_selectedRegion.name == "All") {
      return widget.productList;
    }
    return widget.productList
        .where((product) => product.regionId == _selectedRegion.id)
        .toList();
  }

  void _navigateToAddProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductForm(
          productList: widget.productList,
          regionList: widget.regionList,
        ),
      ),
    ).then((_) {
      setState(() {}); // Refresh the view when returning from ProductForm
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Management'),
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context)
                  .push(AppRouter.kRegionManagement, extra: widget.regionList);
            }, // Add region management navigation
            icon: const Row(
              children: [
                Text('Manage regions'),
                Icon(Icons.settings),
              ],
            ),
          ),
        ],
      ),
      body: _buildBody(filteredProducts),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProduct,
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(List<RegionProductModel> filteredProducts) {
    return BlocConsumer<RegionCubit, RegionState>(
      listener: (context, state) {
        if (state is GetAllRegionsFailureState) {
          showSnackBar(context, state.errorMsg, Colors.red);
        } else if (state is GetAllRegionsSuccessState) {
          widget.regionList = state.regions;
        }
      },
      builder: (context, regionState) {
        return BlocConsumer<ProductCubit, ProductState>(
          listener: (context, state) {
            if (state is GetAllProductsFailureState) {
              showSnackBar(context, state.errorMsg, Colors.red);
            } else if (state is GetAllProductsSuccessState) {
              setState(() {
                widget.productList = state.products;
              });
            } else if (state is DeleteProductFailureState) {
              showSnackBar(context, state.errorMsg, Colors.red);
              setState(() => deletingProductId = null);
            } else if (state is DeleteProductSuccessState) {
              showSnackBar(
                  context, 'Product deleted successfully', Colors.blue);
              setState(() {
                widget.productList
                    .removeWhere((product) => product.id == deletingProductId);
                deletingProductId = null;
              });
            }
          },
          builder: (context, productState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildRegionDropdown(),
                  const SizedBox(height: 20),
                  _buildProductHeader(),
                  const SizedBox(height: 20),
                  _buildProductList(filteredProducts, productState),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRegionDropdown() {
    return DropdownButton<String>(
      isExpanded: true,
      value: _selectedRegion.name,
      hint: const Text('Select Region'),
      onChanged: (String? newValue) {
        setState(() {
          _selectedRegion.name = newValue;
        });
      },
      items: [
        const DropdownMenuItem<String>(value: "All", child: Text("All")),
        ...widget.regionList.map<DropdownMenuItem<String>>((region) {
          return DropdownMenuItem<String>(
              value: region.name, child: Text(region.name ?? ''));
        }),
      ],
    );
  }

  Widget _buildProductHeader() {
    return Text(
      _selectedRegion.name == "All"
          ? 'All Products'
          : 'Products in ${_selectedRegion.name}',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildProductList(
      List<RegionProductModel> products, ProductState state) {
    if (state is GetAllProductsLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }
    if (products.isEmpty) {
      return const Center(child: Text('No products available.'));
    }
    return Expanded(
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(RegionProductModel product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Price: \$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                GoRouter.of(context)
                    .push(AppRouter.kManageProductView, extra: product);
              },
            ),
            IconButton(
              icon: deletingProductId == product.id
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() => deletingProductId = product.id);
                context
                    .read<ProductCubit>()
                    .deleteProduct(productId: product.id!);
              },
            ),
          ],
        ),
      ),
    );
  }
}

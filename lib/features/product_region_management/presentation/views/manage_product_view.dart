import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/form_validators.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';
import 'package:lms/features/product_region_management/presentation/manager/product_cubit/product_cubit.dart';

class ManageProductView extends StatelessWidget {
  final RegionProductModel product;

  const ManageProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Product'),
      ),
      body: ManageProductViewBody(product: product),
    );
  }
}

class ManageProductViewBody extends StatefulWidget {
  final RegionProductModel product;

  const ManageProductViewBody({super.key, required this.product});

  @override
  _ManageProductViewBodyState createState() => _ManageProductViewBodyState();
}

class _ManageProductViewBodyState extends State<ManageProductViewBody> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController imageController;

  final List<String> regionList = ['a', 'b']; // Example region data
  String? _selectedRegion;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    descriptionController =
        TextEditingController(text: widget.product.description);
    priceController =
        TextEditingController(text: widget.product.price.toString());
    imageController = TextEditingController(text: widget.product.imageUrl);
    _selectedRegion = regionList[widget.product.regionId]; // Initialize region
  }

  void _updateProduct() {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = RegionProductModel(
        id: widget.product.id,
        name: nameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        imageUrl: imageController.text,
        regionId: regionList.indexOf(_selectedRegion!),
      );

      context.read<ProductCubit>().updateProduct(product: updatedProduct);
      _clearForm();
    }
  }

  void _clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    imageController.clear();
    setState(() {
      _selectedRegion = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is UpdateProductFailureState) {
          showSnackBar(context, state.errorMsg, Colors.red);
        } else if (state is UpdateProductSuccessState) {
          showSnackBar(context, 'Product updated successfully', Colors.green);
          GoRouter.of(context).pop();
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextFormField(
                  controller: nameController,
                  label: 'Product Name',
                  validator: (value) =>
                      FormValidators.validateString(value, 'Product Name'),
                ),
                _buildTextFormField(
                  controller: descriptionController,
                  label: 'Description',
                  validator: (value) =>
                      FormValidators.validateString(value, 'Description'),
                ),
                _buildTextFormField(
                  controller: priceController,
                  label: 'Price',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) =>
                      FormValidators.validateDouble(value, 'Price'),
                ),
                _buildTextFormField(
                  controller: imageController,
                  label: 'Image URL',
                  validator: (value) =>
                      FormValidators.validateString(value, 'Image URL'),
                ),
                _buildRegionDropdown(),
                const SizedBox(height: 20),
                _buildSubmitButton(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildRegionDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedRegion,
      decoration: const InputDecoration(labelText: 'Select Region'),
      items: regionList.map((region) {
        return DropdownMenuItem<String>(
          value: region,
          child: Text(region),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedRegion = value;
        });
      },
      validator: (value) => FormValidators.validateDropdown(value, 'region'),
    );
  }

  Widget _buildSubmitButton(ProductState state) {
    return ElevatedButton(
      onPressed: _updateProduct,
      child: state is AddProductLoadingState
          ? const Center(child: CircularProgressIndicator())
          : const Text('Update Product'),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    imageController.dispose();
    super.dispose();
  }
}

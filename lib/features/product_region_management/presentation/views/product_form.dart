import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/form_validators.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';
import 'package:lms/features/product_region_management/data/models/region_model.dart';
import 'package:lms/features/product_region_management/presentation/manager/product_cubit/product_cubit.dart';

import 'product_list_view.dart';

class ProductForm extends StatefulWidget {
  final List<RegionProductModel> productList;
  final List<RegionModel> regionList;

  const ProductForm({
    super.key,
    required this.productList,
    required this.regionList,
  });

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController regionNameController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();

  late RegionModel _selectedRegion;
  bool _showRegionAttributes = false;

  @override
  void initState() {
    super.initState();
    _selectedRegion = RegionModel(id: null, name: null);
  }

  void _addProduct() {
    if (_formKey.currentState!.validate()) {
      List<RegionProductModel> newProducts = [
        RegionProductModel(
          name: nameController.text,
          description: descriptionController.text,
          price: double.parse(priceController.text),
          imageUrl: imageController.text,
          regionId: _selectedRegion.id!,
        )
      ];

      context.read<ProductCubit>().addProduct(products: newProducts);

      _clearForm();
    }
  }

  void _clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    imageController.clear();
    countryController.clear();
    regionNameController.clear();
    zipCodeController.clear();
    setState(() {
      _selectedRegion = RegionModel(id: null, name: null);
      _showRegionAttributes = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insert Product')),
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is AddProductFailureState) {
            showSnackBar(context, state.errorMsg, Colors.red);
          } else if (state is AddProductSuccessState) {
            showSnackBar(context, 'Product added successfully', Colors.green);
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
                  if (_showRegionAttributes) ...[
                    _buildTextFormField(
                      controller: countryController,
                      label: 'Country',
                      validator: (value) =>
                          FormValidators.validateString(value, 'Country'),
                    ),
                    _buildTextFormField(
                      controller: regionNameController,
                      label: 'Region Name',
                      validator: (value) =>
                          FormValidators.validateString(value, 'Region Name'),
                    ),
                    _buildTextFormField(
                      controller: zipCodeController,
                      label: 'Zip Code',
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          FormValidators.validateInteger(value, 'Zip Code'),
                    ),
                  ],
                  const SizedBox(height: 20),
                  _buildSubmitButton(state),
                  _buildViewProductsButton(),
                ],
              ),
            ),
          );
        },
      ),
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
      decoration: const InputDecoration(labelText: 'Select Region'),
      items: widget.regionList.map((region) {
        return DropdownMenuItem<String>(
          value: region.name,
          child: Text(region.name ?? ''),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _showRegionAttributes = value != null;
          _selectedRegion = widget.regionList.firstWhere(
            (region) => region.name == value,
          );
        });
      },
      validator: (value) => FormValidators.validateDropdown(value, 'region'),
    );
  }

  Widget _buildSubmitButton(ProductState state) {
    return ElevatedButton(
      onPressed: _addProduct,
      child: state is AddProductLoadingState
          ? const Center(child: CircularProgressIndicator())
          : const Text('Insert Product'),
    );
  }

  Widget _buildViewProductsButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductListView(productList: widget.productList),
          ),
        );
      },
      child: const Text('View Products'),
    );
  }
}

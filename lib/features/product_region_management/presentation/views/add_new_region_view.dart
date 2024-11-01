import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/form_validators.dart';
import 'package:lms/features/product_region_management/data/models/region_model.dart';
import 'package:lms/features/product_region_management/presentation/manager/region_cubit/region_cubit.dart';

class AddNewRegionView extends StatelessWidget {
  const AddNewRegionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Product'),
      ),
      body: const AddNewRegionViewBody(),
    );
  }
}

class AddNewRegionViewBody extends StatefulWidget {
  const AddNewRegionViewBody({super.key});

  @override
  State<AddNewRegionViewBody> createState() => _AddNewRegionViewBodyState();
}

class _AddNewRegionViewBodyState extends State<AddNewRegionViewBody> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController countryController = TextEditingController();

  void _addProduct() {
    if (_formKey.currentState!.validate()) {
      List<RegionModel> regions = [
        RegionModel(
          name: nameController.text,
          country: countryController.text,
        )
      ];
      context.read<RegionCubit>().addRegion(regions: regions);
      _clearForm();
    }
  }

  void _clearForm() {
    nameController.clear();
    countryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegionCubit, RegionState>(
      listener: (context, state) {
        if (state is AddRegionFailureState) {
          showSnackBar(context, state.errorMsg, Colors.red);
        } else if (state is AddRegionSuccessState) {
          showSnackBar(context, 'Region added successfully', Colors.green);
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
                  label: 'Region Name',
                  validator: (value) =>
                      FormValidators.validateString(value, 'Name'),
                ),
                _buildTextFormField(
                  controller: countryController,
                  label: 'Country',
                  validator: (value) =>
                      FormValidators.validateString(value, 'Country'),
                ),
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

  Widget _buildSubmitButton(RegionState state) {
    return ElevatedButton(
      onPressed: _addProduct,
      child: state is AddRegionLoadingState
          ? const Center(child: CircularProgressIndicator())
          : const Text('Insert Product'),
    );
  }
}

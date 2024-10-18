import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/form_validators.dart';
import 'package:lms/features/product_region_management/data/models/region_model.dart';
import 'package:lms/features/product_region_management/presentation/manager/region_cubit/region_cubit.dart';

class ManageRegionView extends StatelessWidget {
  ManageRegionView({super.key, required this.region});
  RegionModel region;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage region'),
      ),
      body: ManageRegionViewBody(
        region: region,
      ),
    );
  }
}

class ManageRegionViewBody extends StatefulWidget {
  ManageRegionViewBody({super.key, required this.region});
  RegionModel region;

  @override
  State<ManageRegionViewBody> createState() => _ManageRegionViewBodyState();
}

class _ManageRegionViewBodyState extends State<ManageRegionViewBody> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;

  late TextEditingController countryController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.region.name);
    countryController = TextEditingController(text: widget.region.country);
  }

  void _updateProduct() {
    if (_formKey.currentState!.validate()) {
      final updatedRegion = RegionModel(
        id: widget.region.id,
        name: nameController.text,
        country: countryController.text,
      );

      context.read<RegionCubit>().updateRegion(region: updatedRegion);
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
        if (state is UpdateRegionFailureState) {
          showSnackBar(context, state.errorMsg, Colors.red);
        } else if (state is UpdateRegionSuccessState) {
          showSnackBar(context, 'Region updated successfully', Colors.green);
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
                  controller: countryController,
                  label: 'Description',
                  validator: (value) =>
                      FormValidators.validateString(value, 'Description'),
                ),
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
      onPressed: _updateProduct,
      child: state is UpdateRegionLoadingState
          ? const Center(child: CircularProgressIndicator())
          : const Text('Update Region'),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    countryController.dispose();

    super.dispose();
  }
}

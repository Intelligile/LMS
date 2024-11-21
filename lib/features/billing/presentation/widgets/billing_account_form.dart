import 'package:flutter/material.dart';
import 'package:lms/features/billing/data/models/billing_account_model.dart';

class BillingAccountForm extends StatefulWidget {
  final bool isDesktop;
  final BillingAccountModel? billingAccount;
  final bool isEditing;
  final Function(BillingAccountModel) onSubmit;

  const BillingAccountForm({
    super.key,
    required this.onSubmit,
    this.billingAccount,
    this.isEditing = false,
    this.isDesktop = false,
  });

  @override
  State<BillingAccountForm> createState() => _BillingAccountFormState();
}

class _BillingAccountFormState extends State<BillingAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _businessPhoneController = TextEditingController();
  String? _country;

  final List<String> _countries = [
    "Lebanon",
    "United States",
    "Canada",
    "Australia",
    "United Kingdom"
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.billingAccount != null) {
      final account = widget.billingAccount!;
      _firstNameController.text = account.firstName ?? '';
      _middleNameController.text = account.middleName ?? '';
      _lastNameController.text = account.lastName ?? '';
      _businessNameController.text = account.businessName ?? '';
      _addressLine1Controller.text = account.addressLine1 ?? '';
      _addressLine2Controller.text = account.addressLine2 ?? '';
      _cityController.text = account.city ?? '';
      _postalCodeController.text = account.postalCode ?? '';
      _businessPhoneController.text = account.businessPhoneNumber ?? '';
      _country = account.country;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Bar with Title and Cancel Button
          Container(
            color: const Color(0xFF017278),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.isEditing
                        ? "Edit Billing Account"
                        : "New Billing Account",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the form
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 46.0, vertical: 32.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.isDesktop)
                      const Text(
                        'Fill in the details to create or update the billing account.',
                        style: TextStyle(fontSize: 16),
                      ),
                    const SizedBox(height: 16),
                    _buildForm(),
                    const SizedBox(height: 16),
                    Align(
                      alignment: widget.isDesktop
                          ? Alignment.centerRight
                          : Alignment.center,
                      child: ElevatedButton(
                        onPressed: _onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF017278),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14.0,
                            horizontal: 30.0,
                          ),
                        ),
                        child: Text(widget.isEditing ? "Update" : "Save"),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "By selecting Save, you agree to our terms and conditions.",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: _buildTextInput("First Name *", _firstNameController)),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildTextInput("Middle Name", _middleNameController)),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildTextInput("Last Name *", _lastNameController)),
            ],
          ),
          const SizedBox(height: 10),
          _buildTextInput("Business Name *", _businessNameController),
          const SizedBox(height: 10),
          _buildTextInput("Address Line 1 *", _addressLine1Controller),
          const SizedBox(height: 10),
          _buildTextInput("Address Line 2", _addressLine2Controller),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildTextInput("City *", _cityController)),
              const SizedBox(width: 10),
              Expanded(
                  child:
                      _buildTextInput("Postal Code *", _postalCodeController)),
            ],
          ),
          const SizedBox(height: 10),
          _buildDropdownInput("Country/Region *"),
          const SizedBox(height: 10),
          _buildTextInput("Business Phone Number *", _businessPhoneController),
        ],
      ),
    );
  }

  Widget _buildTextInput(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (label.contains("*") && (value == null || value.isEmpty)) {
          return "$label is required";
        }
        return null;
      },
    );
  }

  Widget _buildDropdownInput(String label) {
    return DropdownButtonFormField<String>(
      value: _country,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: _countries
          .map((country) => DropdownMenuItem(
                value: country,
                child: Text(country),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _country = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label is required";
        }
        return null;
      },
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final billingAccount = BillingAccountModel(
        id: widget.isEditing ? widget.billingAccount?.id ?? 0 : 0,
        firstName: _firstNameController.text,
        middleName: _middleNameController.text,
        lastName: _lastNameController.text,
        businessName: _businessNameController.text,
        addressLine1: _addressLine1Controller.text,
        addressLine2: _addressLine2Controller.text,
        city: _cityController.text,
        postalCode: _postalCodeController.text,
        country: _country ?? '',
        businessPhoneNumber: _businessPhoneController.text,
        organization: widget.billingAccount?.organization,
      );

      widget.onSubmit(billingAccount);
    }
  }
}

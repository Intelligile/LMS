import 'package:flutter/material.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/features/dmz_management/data/models/dmz_model.dart';

class DMZForm extends StatefulWidget {
  final List<DMZModel> dmzAccounts;
  final bool isEditing;
  final Function(List<DMZModel>) onSubmit;

  const DMZForm({
    super.key,
    required this.dmzAccounts,
    required this.isEditing,
    required this.onSubmit,
  });

  @override
  _DMZFormState createState() => _DMZFormState();
}

class _DMZFormState extends State<DMZForm> {
  final _formKey = GlobalKey<FormState>();
  List<DMZModel> _dmzAccounts = [];
  bool _passwordVisible = false; // To control password visibility

  @override
  void initState() {
    super.initState();
    _dmzAccounts = widget.dmzAccounts;

    if (!widget.isEditing) {
      _dmzAccounts.add(DMZModel(
        dmzId: 0,
        uniqueId: _generateUniqueId(),
        dmzOrganization: '',
        dmzCountry: '',
        password: '', // Initialize password field
      ));
    }
  }

  String _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(_dmzAccounts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Set up the DMZ account',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Text(
                        'Fill in the DMZ account details to get started.',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildTextField(
                            label: 'DMZ Organization',
                            initialValue: _dmzAccounts[0].dmzOrganization,
                            onSaved: (value) =>
                                _dmzAccounts[0].dmzOrganization = value!,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an organization';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            label: 'DMZ Country',
                            initialValue: _dmzAccounts[0].dmzCountry,
                            onSaved: (value) =>
                                _dmzAccounts[0].dmzCountry = value!,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a country';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Unique ID: ${_dmzAccounts[0].uniqueId}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Password field with visibility toggle
                          _buildPasswordField(
                            label: 'Password',
                            initialValue: _dmzAccounts[0].password,
                            onSaved: (value) =>
                                _dmzAccounts[0].password = value ?? '',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[300]),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'Cancel',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF017278),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text(
                              'Submit',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
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

// Password field with visibility toggle
  Widget _buildPasswordField({
    required String label,
    required String? initialValue,
    required FormFieldSetter<String>? onSaved,
    required FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 18),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(12),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }

  Widget _buildTextField({
    required String label,
    required String? initialValue,
    required FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 18),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(12),
      ),
      style: const TextStyle(fontSize: 18),
      onSaved: onSaved,
      validator: validator,
    );
  }
}

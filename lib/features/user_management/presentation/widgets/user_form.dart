import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';

class UserForm extends StatefulWidget {
  final List<UserModel> users;
  final bool isEditing;
  final Function(List<UserModel>) onSubmit;

  UserForm({
    required this.users,
    required this.isEditing,
    required this.onSubmit,
  });

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  List<UserModel> _users = [];
  int _currentStep = 0;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _users = widget.users;

    if (!widget.isEditing) {
      _users.add(UserModel(
        id: 0,
        username: '',
        password: '',
        email: '',
        firstname: '',
        lastname: '',
        phone: '',
        enabled: true,
        authorities: [],
        groups: [],
      ));
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(_users);
    }
  }

  void _onStepTapped(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Sidebar for steps with connected dots
          // Container(
          //   width: 200,
          //   color: Colors.grey[100],
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.all(16.0),
          //         child: Text(
          //           'Add a user',
          //           style: TextStyle(
          //             fontSize: 20,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //       Divider(),
          //       _buildStepIndicator('Basics', 0),
          //       _buildStepIndicator('Product licenses', 1),
          //       _buildStepIndicator('Optional settings', 2),
          //       _buildStepIndicator('Finish', 3),
          //     ],
          //   ),
          // ),

          // Main form
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and description
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Set up the basics',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Text(
                        'To get started, fill out some basic information about who you’re adding as a user.',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ),

                    Expanded(
                      child: ListView(
                        children: [
                          // Form fields with padding, spacing, and white background
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: 'First name',
                                  initialValue: _users[0].firstname,
                                  onSaved: (value) =>
                                      _users[0].firstname = value!,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: 'Last name',
                                  initialValue: _users[0].lastname,
                                  onSaved: (value) =>
                                      _users[0].lastname = value!,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          _buildTextField(
                            label: 'Display name',
                            initialValue: _users[0].username,
                            onSaved: (value) => _users[0].username = value!,
                          ),
                          SizedBox(height: 20),
                          _buildTextField(
                            label: 'Username',
                            initialValue: _users[0].username,
                            onSaved: (value) => _users[0].username = value!,
                          ),
                          SizedBox(height: 20),
                          _buildTextField(
                            label: 'Email',
                            initialValue: _users[0].email,
                            validator: (value) {
                              if (!EmailValidator.validate(value ?? '')) {
                                return 'Invalid email format';
                              }
                              return null;
                            },
                            onSaved: (value) => _users[0].email = value!,
                          ),
                          SizedBox(height: 20),

                          // Password field with visibility toggle
                          TextFormField(
                            initialValue: _users[0].password,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.all(12),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            onSaved: (value) => _users[0].password = value!,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 20),

                          _buildTextField(
                            label: 'Phone',
                            initialValue: _users[0].phone,
                            onSaved: (value) => _users[0].phone = value!,
                          ),
                          SizedBox(height: 20),

                          // Enabled toggle switch
                          SwitchListTile(
                            title:
                                Text('Enabled', style: TextStyle(fontSize: 18)),
                            activeColor: Color(0xFF017278), // LMS color
                            value: _users[0].enabled,
                            onChanged: (value) {
                              setState(() {
                                _users[0].enabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[300]),

                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child:
                                Text('Cancel', style: TextStyle(fontSize: 16)),
                          ),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Text('Submit',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF017278),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
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
        labelStyle: TextStyle(fontSize: 18),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.all(12),
      ),
      style: TextStyle(fontSize: 18),
      onSaved: onSaved,
      validator: validator,
    );
  }

  Widget _buildStepIndicator(String step, int index) {
    bool isActive = _currentStep == index;
    return GestureDetector(
      onTap: () => _onStepTapped(index),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            height: 12,
            width: 12,
            decoration: BoxDecoration(
              color: isActive ? Color(0xFF017278) : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                step,
                style: TextStyle(
                  color: isActive ? Color(0xFF017278) : Colors.grey,
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';

class UserForm extends StatefulWidget {
  final List<UserModel> users;
  final bool isEditing;
  final Function(List<UserModel>) onSubmit;

  const UserForm({
    super.key,
    required this.users,
    required this.isEditing,
    required this.onSubmit,
  });

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  List<UserModel> _users = [];
  int _currentStep = 0;
  bool _passwordVisible = false;
  String _initialPassword = '';

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
    } else {
      // Store initial encoded password
      _initialPassword = _users[0].password;
      _passwordController.text = _initialPassword; // Display the password
    }
  }

  bool _isPasswordEncoded(String password) {
    // Check if the password matches the pattern of an encoded BCrypt hash
    return password.startsWith(r'$2a$') && password.length == 60;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Check if the password in the controller is already encoded
      if (!_isPasswordEncoded(_passwordController.text)) {
        // Update password only if it’s not already encoded
        _users[0].password = _passwordController.text;
      } else {
        // Keep the original encoded password
        _users[0].password = _initialPassword;
      }

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
                              const SizedBox(width: 16),
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
                          const SizedBox(height: 20),
                          _buildTextField(
                            label: 'Display name',
                            initialValue: _users[0].username,
                            onSaved: (value) => _users[0].username = value!,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            label: 'Username',
                            initialValue: _users[0].username,
                            onSaved: (value) => _users[0].username = value!,
                          ),
                          const SizedBox(height: 20),
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
                          const SizedBox(height: 20),

                          // Password field with visibility toggle
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(fontSize: 18),
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(12),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 20),

                          _buildTextField(
                            label: 'Phone',
                            initialValue: _users[0].phone,
                            onSaved: (value) => _users[0].phone = value!,
                          ),
                          const SizedBox(height: 20),

                          // Enabled toggle switch
                          SwitchListTile(
                            title: const Text('Enabled',
                                style: TextStyle(fontSize: 18)),
                            activeColor: const Color(0xFF017278),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black)),
                          ),
                          ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF017278),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Submit',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
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

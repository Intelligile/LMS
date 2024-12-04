import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';

class UserForm extends StatefulWidget {
  final List<UserModel> users;
  final bool isEditing;
  final Function(List<UserModel>) onSubmit;

  UserForm(
      {required this.users, required this.isEditing, required this.onSubmit});

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  List<UserModel> _users = [];

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

      final usernames = _users.map((user) => user.username).toSet();
      final emails = _users.map((user) => user.email).toSet();

      if (usernames.length != _users.length) {
        showSnackBar(
            context, 'Duplicate usernames are not allowed', Colors.red);
        return;
      }

      if (emails.length != _users.length) {
        showSnackBar(context, 'Duplicate emails are not allowed', Colors.red);
        return;
      }

      widget.onSubmit(_users);
      Navigator.of(context).pop();
    }
  }

  void _addUser() {
    setState(() {
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
    });
  }

  void _removeUser(int index) {
    setState(() {
      _users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Users' : 'Add Multiple Users'),
        backgroundColor: Color(0xFF017278), // LMS color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  _buildUserForm(index),
                  SizedBox(height: 16.0), // Space between user forms
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _addUser,
            child: Icon(Icons.add),
            backgroundColor: Color(0xFF017278), // LMS color
            tooltip: 'Add Another User',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _submitForm,
            child: Icon(Icons.save),
            backgroundColor: Color(0xFF017278), // LMS color
            tooltip: 'Submit Users',
          ),
        ],
      ),
    );
  }

  Widget _buildUserForm(int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              label: 'Username',
              initialValue: _users[index].username,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter a username';
                if (_users.where((user) => user.username == value).length > 1) {
                  return 'Username already exists';
                }
                return null;
              },
              onSaved: (value) => _users[index].username = value!,
            ),
            SizedBox(height: 12.0), // Space between form fields
            _buildTextField(
              label: 'Password',
              initialValue: _users[index].password,
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter a password';
                return null;
              },
              onSaved: (value) => _users[index].password = value!,
            ),
            SizedBox(height: 12.0), // Space between form fields
            _buildTextField(
              label: 'Email',
              initialValue: _users[index].email,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter an email';
                if (!EmailValidator.validate(value))
                  return 'Invalid email format';
                if (_users.where((user) => user.email == value).length > 1) {
                  return 'Email already exists';
                }
                return null;
              },
              onSaved: (value) => _users[index].email = value!,
            ),
            SizedBox(height: 12.0), // Space between form fields
            _buildTextField(
              label: 'First Name',
              initialValue: _users[index].firstname,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter a first name';
                return null;
              },
              onSaved: (value) => _users[index].firstname = value!,
            ),
            SizedBox(height: 12.0), // Space between form fields
            _buildTextField(
              label: 'Last Name',
              initialValue: _users[index].lastname,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter a last name';
                return null;
              },
              onSaved: (value) => _users[index].lastname = value!,
            ),
            SizedBox(height: 12.0), // Space between form fields
            _buildTextField(
              label: 'Phone',
              initialValue: _users[index].phone,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter a phone number';
                return null;
              },
              onSaved: (value) => _users[index].phone = value!,
            ),
            SizedBox(height: 12.0), // Space between form fields
            SwitchListTile(
              title: Text('Enabled'),
              activeColor: Color(0xFF017278), // LMS color
              value: _users[index].enabled,
              onChanged: (value) {
                setState(() {
                  _users[index].enabled = value;
                });
              },
            ),
            SizedBox(height: 12.0), // Space between Switch and delete button
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  if (_users.length > 1) {
                    _removeUser(index);
                  } else {
                    showSnackBar(
                        context, 'At least one user is required', Colors.red);
                  }
                },
                tooltip: 'Remove User',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String? initialValue,
    required FormFieldValidator<String>? validator,
    required FormFieldSetter<String>? onSaved,
    bool obscureText = false,
  }) {
    return TextFormField(
      initialValue: initialValue,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}

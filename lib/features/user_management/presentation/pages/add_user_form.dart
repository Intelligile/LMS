import 'package:flutter/material.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';
import 'package:lms/features/user_management/domain/use_cases/add_user.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:email_validator/email_validator.dart'; // If you haven't added it yet, add this package to validate emails.

class AddUsersForm extends StatefulWidget {
  final AddUser addUsersUseCase; // Inject the use case

  AddUsersForm({required this.addUsersUseCase});

  @override
  _AddUsersFormState createState() => _AddUsersFormState();
}

class _AddUsersFormState extends State<AddUsersForm> {
  final _formKey = GlobalKey<FormState>();
  List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
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

  // Adjust the _submitForm method to use the use case
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Call the addUsers use case
        String result = await widget.addUsersUseCase.call(_users);

        // Show the result in a snack bar
        showSnackBar(context, result,
            result.contains('successfully') ? Colors.green : Colors.red);
      } catch (e) {
        showSnackBar(context, "Failed to add users: $e", Colors.red);
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF017278), // LMS color
        title: Text('Add Users', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              return _buildUserForm(index);
            },
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Color(0xFF017278), // LMS color
            onPressed: _addUser,
            child: Icon(Icons.add),
            tooltip: 'Add Another User',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: Color(0xFF017278), // LMS color
            onPressed: _submitForm,
            child: Icon(Icons.save),
            tooltip: 'Submit Users',
          ),
        ],
      ),
    );
  }

  Widget _buildUserForm(int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputField(
              label: 'Username',
              initialValue: _users[index].username,
              onSaved: (value) => _users[index].username = value!,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter a username';
                if (_users.where((user) => user.username == value).length > 1) {
                  return 'Username already exists';
                }
                return null;
              },
            ),
            _buildInputField(
              label: 'Password',
              initialValue: _users[index].password,
              obscureText: true,
              onSaved: (value) => _users[index].password = value!,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter a password';
                return null;
              },
            ),
            _buildInputField(
              label: 'Email',
              initialValue: _users[index].email,
              onSaved: (value) => _users[index].email = value!,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter an email';
                if (!EmailValidator.validate(value)) {
                  return 'Invalid email format';
                }
                if (_users.where((user) => user.email == value).length > 1) {
                  return 'Email already exists';
                }
                return null;
              },
            ),
            _buildInputField(
              label: 'First Name',
              initialValue: _users[index].firstname,
              onSaved: (value) => _users[index].firstname = value!,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter a first name';
                return null;
              },
            ),
            _buildInputField(
              label: 'Last Name',
              initialValue: _users[index].lastname,
              onSaved: (value) => _users[index].lastname = value!,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter a last name';
                return null;
              },
            ),
            _buildInputField(
              label: 'Phone',
              initialValue: _users[index].phone,
              onSaved: (value) => _users[index].phone = value!,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter a phone number';
                return null;
              },
            ),
            SwitchListTile(
              activeColor: Color(0xFF017278), // LMS color
              title: Text('Enabled'),
              value: _users[index].enabled,
              onChanged: (value) {
                setState(() {
                  _users[index].enabled = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String initialValue,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFF017278)), // LMS color
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF017278)), // LMS color
          ),
          border: OutlineInputBorder(),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}

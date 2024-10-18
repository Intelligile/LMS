import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';

class UserForm extends StatefulWidget {
  final List<UserModel> users;
  final bool
      isEditing; // Flag to indicate whether the form is for editing or adding
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

    if (widget.isEditing) {
      // If editing, ensure that the existing users are set up correctly
      for (var user in _users) {
        // user.password = ''; // Don't pre-fill password when editing
      }
    } else {
      // If adding, initialize with a blank user
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
        groups: [], // Initialize the groups field with an empty list
      ));
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Check for duplicate usernames and emails
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
        groups: [], // Initialize the groups field with an empty list
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
            onPressed: _addUser,
            child: Icon(Icons.add),
            tooltip: 'Add Another User',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
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
            TextFormField(
              initialValue: _users[index].username,
              decoration: InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value!.isEmpty) return 'Please enter a username';
                if (_users.where((user) => user.username == value).length > 1) {
                  return 'Username already exists';
                }
                return null;
              },
              onSaved: (value) => _users[index].username = value!,
            ),
            if (widget.isEditing)
              TextFormField(
                initialValue: _users[index].password,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a password';
                  return null;
                },
                onSaved: (value) => _users[index].password = value!,
              ),
            TextFormField(
              initialValue: _users[index].email,
              decoration: InputDecoration(labelText: 'Email'),
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
            TextFormField(
              initialValue: _users[index].firstname,
              decoration: InputDecoration(labelText: 'First Name'),
              validator: (value) {
                if (value!.isEmpty) return 'Please enter a first name';
                return null;
              },
              onSaved: (value) => _users[index].firstname = value!,
            ),
            TextFormField(
              initialValue: _users[index].lastname,
              decoration: InputDecoration(labelText: 'Last Name'),
              validator: (value) {
                if (value!.isEmpty) return 'Please enter a last name';
                return null;
              },
              onSaved: (value) => _users[index].lastname = value!,
            ),
            TextFormField(
              initialValue: _users[index].phone,
              decoration: InputDecoration(labelText: 'Phone'),
              validator: (value) {
                if (value!.isEmpty) return 'Please enter a phone number';
                return null;
              },
              onSaved: (value) => _users[index].phone = value!,
            ),
            SwitchListTile(
              title: Text('Enabled'),
              value: _users[index].enabled,
              onChanged: (value) {
                setState(() {
                  _users[index].enabled = value;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
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
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:lms/features/roles_and_premission/data/models/authority.dart';
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
  late Dio _dio;
  late Dio _dioLicense;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  List<UserModel> _users = [];
  bool _passwordVisible = false;
  String _initialPassword = '';
  List<Authority> _roles = [];
  List<int> _selectedRoles = [];
  bool _isDrawerOpen = false;
  String? _selectedLicense;
  List<Map<String, dynamic>> _licenses = [];
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8082'));
    _dioLicense = Dio(BaseOptions(baseUrl: 'http://localhost:8081'));
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
      _initialPassword = _users[0].password;
      _passwordController.text = _initialPassword;
    }
    _fetchUserId();

    _fetchRoles();
  }

  Future<int?> _fetchUserId() async {
    try {
      final response = await _dio.get(
        '/api/auth/user/profile/$usernamePublic',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtTokenPublic',
        }),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        userId = data['id'];
        _fetchLicenses();
        print("USER PROFILE ID : ${data['id']}");
        return data['id']; // Assuming the response contains `id` for the user
      } else {
        throw Exception('Failed to fetch user ID');
      }
    } catch (e) {
      print('Error fetching user ID: $e');
      return null;
    }
  }

  Future<void> _fetchLicenses() async {
    try {
      print("USER ID L $userId");
      final response = await _dioLicense.get(
        '/api/license/user/$userId',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtTokenPublic',
        }),
      );

      if (response.statusCode == 200) {
        final data = List<Map<String, dynamic>>.from(response.data);
        // Filter licenses: must have licenseId, no assignedUserId
        setState(() {
          _licenses = data
              .where((license) =>
                  license['licenseId'] != null &&
                  license['assignedUserId'] == null)
              .toList();
        });
        print("Fetched Licenses: ${response.data}");
        // Reset _selectedLicense if it no longer matches the available licenses
        if (!_licenses.any(
            (license) => license['licenseId'].toString() == _selectedLicense)) {
          _selectedLicense = null;
        }
        // print("LICENSES $data");
      } else {
        print('Error fetching licenses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching licenses: $e');
    }
  }

  Future<void> _assignLicense(String selectedLicenseId) async {
    try {
      // Refresh the licenses list before checking
      await _fetchLicenses();

      // Check if the user already has an assigned license
      Map<String, dynamic>? existingLicense;
      final matchingLicenses = _licenses
          .where((license) => license['assignedUserId'] == _users[0].id);

      if (matchingLicenses.isNotEmpty) {
        existingLicense = matchingLicenses.first;
        return;
      } else {
        existingLicense = null;
      }

      if (existingLicense != null) {
        // Show error dialog if user already has a license
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Assignment Error'),
            content: Text(
                'This user already has an assigned license: License ID: $existingLicense. Please revoke the existing license first.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return; // Exit early if the user already has a license
      } else {
        // Proceed with assigning the license
        print("LICENSE ID TO ASSIGN $selectedLicenseId");
        print("ASSIGNED USER ID TO ASSIGN ${_users[0].id}");

        final response = await _dioLicense.post(
          '/api/license/assign',
          data: {
            "licenseId": selectedLicenseId,
            "assignedUserId": _users[0].id,
          },
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtTokenPublic',
          }),
        );

        if (response.statusCode == 200) {
          // Show success dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Success'),
              content: const Text('License assigned successfully.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );

          // Refresh licenses after assignment
          await _fetchLicenses();

          // Reset the selected license
          setState(() {
            _selectedLicense = null;
          });
        } else {
          throw Exception('Failed to assign license');
        }
      }
    } catch (e) {
      print('Error assigning license: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to assign license: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _revokeLicense() async {
    try {
      final response = await _dioLicense.post(
        '/api/license/revoke',
        data: {
          "assignedUserId": _users[0].id, // Pass assignedUserId only
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtTokenPublic',
        }),
      );

      if (response.statusCode == 200) {
        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('License revoked successfully.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );

        // Refresh licenses
        _fetchLicenses();
      } else {
        throw Exception('Failed to revoke license');
      }
    } catch (e) {
      print('Error revoking license: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to revoke license: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _fetchRoles() async {
    const token = 'your-token-here'; // Replace with your token
    final response = await http.get(
      Uri.parse('http://localhost:8082/api/authorities'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtTokenPublic',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _roles = (json.decode(response.body) as List)
            .map((role) => Authority.fromJson(role))
            .toList();
      });
    } else {
      // Handle error
      print('Error fetching roles: ${response.statusCode}');
    }
  }

  Future<void> _fetchUserRoles() async {
    const token = 'your-token-here'; // Replace with your token
    final response = await http.get(
      Uri.parse('http://localhost:8082/api/users/with-roles/$organizationId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtTokenPublic',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> userRolesData = json.decode(response.body);

      // Find the current user's roles based on user ID
      final currentUserRoles = userRolesData.firstWhere(
        (user) => user['id'] == _users[0].id,
        orElse: () => null,
      );

      if (currentUserRoles != null) {
        setState(() {
          _selectedRoles = (currentUserRoles['roles'] as List<dynamic>)
              .map<int>(
                  (role) => _roles.firstWhere((r) => r.authority == role).id)
              .toList();
        });
      }
    } else {
      // Handle error
      print('Error fetching user roles: ${response.statusCode}');
    }
  }

  Future<void> _assignRoles() async {
    final userId = _users[0].id;

    // Debugging: Print selected roles and user ID
    print('Assigning roles: $_selectedRoles to user ID: $userId');
    print('JWT Token: $jwtTokenPublic');

    final response = await http.post(
      Uri.parse('http://localhost:8082/api/authorities/assign-roles-to-user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtTokenPublic',
      },
      body: json.encode({
        'userId': userId, // Match the expected API parameter name
        'roleIds': _selectedRoles,
      }),
    );

    // Debugging: Log response details
    print('API Response Status Code: ${response.statusCode}');
    print('API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        setState(() {
          _users[0].authorities =
              _roles.where((role) => _selectedRoles.contains(role.id)).toList();
        });

        print('Roles successfully assigned: ${_users[0].authorities}');
        _closeDrawer();
      } catch (e) {
        print('Error updating user authorities: $e');
      }
    } else {
      print('Error assigning roles: HTTP ${response.statusCode}');
      print('Error Response Body: ${response.body}');
    }
  }

  bool _isPasswordEncoded(String password) {
    return password.startsWith(r'$2a$') && password.length == 60;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (!_isPasswordEncoded(_passwordController.text)) {
        _users[0].password = _passwordController.text;
      } else {
        _users[0].password = _initialPassword;
      }

      widget.onSubmit(_users);
    }
  }

  void _openDrawer() {
    _fetchUserRoles(); // Fetch roles for the selected user
    setState(() {
      _isDrawerOpen = true;
    });
  }

  void _closeDrawer() {
    setState(() {
      _isDrawerOpen = false;
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
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: const OutlineInputBorder(),
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
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            label: 'Phone',
                            initialValue: _users[0].phone,
                            onSaved: (value) => _users[0].phone = value!,
                          ),
                          const SizedBox(height: 20),
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
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: TextButton(
                                  onPressed: _openDrawer,
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF017278),
                                    padding: EdgeInsets.zero,
                                  ).copyWith(
                                    textStyle: MaterialStateProperty
                                        .resolveWith<TextStyle>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.hovered)) {
                                          return const TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.bold,
                                          );
                                        }
                                        return const TextStyle(
                                          decoration: TextDecoration.none,
                                        );
                                      },
                                    ),
                                  ),
                                  child: const Text('Manage Roles'),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  'Assign License to User',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              DropdownButtonFormField(
                                value: _selectedLicense,
                                items: _licenses.map((license) {
                                  return DropdownMenuItem(
                                    value: license['licenseId'].toString(),
                                    child: Row(
                                      children: [
                                        Icon(Icons.key, color: Colors.green),
                                        const SizedBox(width: 8),
                                        Text(
                                            'License ID: ${license['licenseId']}'),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedLicense = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Select License',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _selectedLicense != null
                                    ? () => _assignLicense(_selectedLicense!)
                                    : null,
                                child: const Text('Assign License'),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      _revokeLicense();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text(
                                      'Revoke',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
          if (_isDrawerOpen)
            Container(
              width: 300,
              color: Colors.grey[200],
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Manage Roles',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _roles.length,
                      itemBuilder: (context, index) {
                        final role = _roles[index];
                        return CheckboxListTile(
                          title: Text(role.authority ?? ''),
                          value: _selectedRoles.contains(role.id),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                _selectedRoles.add(role.id);
                              } else {
                                _selectedRoles.remove(role.id);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _assignRoles,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF017278),
                    ),
                    child: const Text('Save Roles'),
                  ),
                  TextButton(
                    onPressed: _closeDrawer,
                    child: const Text('Close'),
                  ),
                ],
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
        border: const OutlineInputBorder(),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }
}

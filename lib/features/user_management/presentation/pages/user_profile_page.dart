// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/user_management/domain/entities/user.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';
import 'package:lms/features/user_management/domain/use_cases/get_user_profile_data.dart';
import 'package:lms/features/user_management/domain/use_cases/update_user.dart';

import 'package:flutter/material.dart';
import 'package:lms/features/user_management/domain/entities/user.dart';
import 'package:lms/features/user_management/domain/use_cases/update_user_profile.dart';

class UserProfilePage extends StatefulWidget {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  final String username;

  UserProfilePage({
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.username,
  });

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Controllers for user info form fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController =
      TextEditingController(); // Added controller for password

  late UserModel _user;

  @override
  void initState() {
    super.initState();
    // Fetch user profile and licenses when the page loads
    // print("USERNAME IN initState ${widget.username}");
    _fetchUserProfile(widget.username);
    _fetchUserLicenses();
  }

  void _fetchUserProfile(String username) async {
    try {
      UserModel user = await widget.getUserProfile.call(username);
      print("USER PROFILE FETCHED: ${user.firstname}");
      // Convert UserModel to Map<String, dynamic>
      Map<String, dynamic> userMap = user.toJson();

      // Print the map for debugging
      print("USER PROFILE AS MAP: $userMap");
      setState(() {
        _user = user;
        _firstNameController.text = user.firstname;
        _lastNameController.text = user.lastname;
        _nameController.text = user.username;
        _emailController.text = user.email;
        _phoneController.text = user.phone;
        _passwordController.text = user.password; // Populate password
      });
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  void _fetchUserLicenses() {
    // Call UseCase to fetch licenses from the License Service
  }

  void _updateUserProfile() async {
    try {
      UserModel updatedUser = UserModel(
        id: _user.id,
        username: _nameController.text,
        password: _passwordController.text,
        email: _emailController.text,
        firstname: _firstNameController.text,
        lastname: _lastNameController.text,
        phone: _phoneController.text,
        authorities: _user.authorities,
        groups: _user.groups,
      );

      // Call the update method, which returns a UserModel
      UserModel result =
          await widget.updateUserProfile.call(updatedUser, jwtToken);

      // Optionally show success message
      showSnackBar(context, 'Profile Updated Successfully', Colors.green);
    } catch (e) {
      print("Error updating user profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Form
            Text('Update Profile',
                style: Theme.of(context).textTheme.headlineLarge),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'Firstname'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Lastname'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _passwordController, // Added password field
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserProfile,
              child: Text('Update Profile'),
            ),
            SizedBox(height: 40),

            // License Information Section
            Text('Your Licenses',
                style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 20),
            Row(
              children: [
                // Spacer for floating the list to the right
                Spacer(),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: _buildLicensesList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Method to build the licenses list
  Widget _buildLicensesList() {
    // Placeholder data, replace with actual licenses from License Service
    final licenses = [
      {
        'deviceName': 'Device 1',
        'endDate': '2024-12-31',
        'serverCode': 'ABC123'
      },
      {
        'deviceName': 'Device 2',
        'endDate': '2024-06-30',
        'serverCode': 'XYZ789'
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: licenses.length,
      itemBuilder: (context, index) {
        final license = licenses[index];
        return ListTile(
          title: Text(license['deviceName']!),
          subtitle: Text(
              'Expires on: ${license['endDate']}\nServer Code: ${license['serverCode']}'),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/auth_code/data/repositories/authorization_code_repository_impl.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';
import 'package:lms/features/user_management/domain/entities/license.dart';
import 'package:lms/features/user_management/domain/use_cases/get_user_licenses.dart';
import 'package:lms/features/user_management/domain/use_cases/get_user_profile_data.dart';
import 'package:lms/features/user_management/domain/use_cases/update_user_profile.dart';

class UserProfilePage extends StatefulWidget {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  final String username;
  final GetUserLicenses getUserLicenses;
  const UserProfilePage({
    super.key,
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.username,
    required this.getUserLicenses,
  });

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  late UserModel _user;
  List<License> _licenses = [];
  final authorizationCodeRepo = AuthorizationCodeRepositoryImpl();
  dynamic _authorizationCode; // Store authorization code info

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(widget.username);
    _fetchUserLicenses(widget.username);
  }

  Future<void> _fetchAuthorizationCode(int userId) async {
    try {
      // Call your API here using the user ID
      final response =
          await authorizationCodeRepo.getAuthorizationCodeByLicenseeId(userId);

      if (response != null) {
        setState(() {
          _authorizationCode = response;
        });
      } else {
        // If no authorization code exists
        setState(() {
          _authorizationCode = null;
        });
      }
    } catch (e) {
      print("Error fetching authorization code: $e");
    }
  }

  Future<void> _fetchUserProfile(String username) async {
    try {
      UserModel user = await widget.getUserProfile.call(username);
      setState(() {
        _user = user;
        _firstNameController.text = user.firstname;
        _lastNameController.text = user.lastname;
        _nameController.text = user.username;
        _emailController.text = user.email;
        _phoneController.text = user.phone;
        _passwordController.text = user.password;
      });
      _fetchAuthorizationCode(_user.id); // Fetch authorization code
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  void _fetchUserLicenses(String username) async {
    try {
      UserModel user = await widget.getUserProfile.call(username);
      setState(() {
        _user = user;
      });
      List<License> licenses =
          (await widget.getUserLicenses.call(_user.id, jwtToken));
      setState(() {
        _licenses = licenses;
        print("User licenses fetched: $licenses");
      });
    } catch (e) {
      print("Error fetching user licenses: $e");
    }
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
      await widget.updateUserProfile.call(updatedUser, jwtToken);
      showSnackBar(context, 'Profile Updated Successfully', Colors.green);
    } catch (e) {
      print("Error updating user profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: const Color(0xFF017278), // LMS Primary color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(context),
            const SizedBox(height: 40),
            _buildLicenseSection(),
            const SizedBox(height: 40),
            _buildAuthorizationCodeSection(), // Add authorization code section
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Profile',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: const Color(0xFF017278), // LMS Primary color
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            _buildTextField(_firstNameController, 'Firstname'),
            _buildTextField(_lastNameController, 'Lastname'),
            _buildTextField(_nameController, 'Username'),
            _buildTextField(_emailController, 'Email'),
            _buildTextField(_phoneController, 'Phone'),
            _buildPasswordField(_passwordController, 'Password'),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF017278), // LMS Primary color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _updateUserProfile,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text('Update Profile'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        obscureText: true,
      ),
    );
  }

  Widget _buildLicenseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Licenses',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: const Color(0xFF017278), // LMS Primary color
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 20),
        _licenses.isEmpty
            ? const Center(
                child: Text('No licenses available'),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _licenses.length,
                itemBuilder: (context, index) {
                  final license = _licenses[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.computer, color: Colors.blue),
                      title: Text(license.deviceName),
                      subtitle: Text(
                        'Expires on: ${license.endDate}\nServer Code: ${license.serverCode}',
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildAuthorizationCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Authorization Code',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: const Color(0xFF017278), // LMS Primary color
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        _authorizationCode == null
            ? const Center(
                child: Text('No Authorization Code available'),
              )
            : Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.vpn_key, color: Colors.green),
                  title: GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: _authorizationCode.code));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Authorization Code copied!')),
                      );
                    },
                    child: Text('Code: ${_authorizationCode.code}'),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text: _authorizationCode.amount.toString()));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Amount copied!')),
                          );
                        },
                        child: Text('Amount: \$${_authorizationCode.amount}'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text:
                                  _authorizationCode.periodMonths.toString()));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Period copied!')),
                          );
                        },
                        child: Text(
                            'Period: ${_authorizationCode.periodMonths} months'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text: _authorizationCode.createdAt));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Created At copied!')),
                          );
                        },
                        child:
                            Text('Created At: ${_authorizationCode.createdAt}'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text: _authorizationCode.periodEndDate));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Period End Date copied!')),
                          );
                        },
                        child: Text(
                            'Period End Date: ${_authorizationCode.periodEndDate}'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: _authorizationCode.product));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Product copied!')),
                          );
                        },
                        child: Text('Product: ${_authorizationCode.product}'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text: _authorizationCode.discount.toString()));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Discount copied!')),
                          );
                        },
                        child: Text('Discount: ${_authorizationCode.discount}'),
                      ),
                    ],
                  ),
                ),
              )
      ],
    );
  }
}

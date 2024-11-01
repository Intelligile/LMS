import 'package:flutter/material.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/home/presentation/views/widgets/user_name_icon.dart';

class UserOptionsIcons extends StatelessWidget {
  final String username;

  const UserOptionsIcons({
    super.key,
    required this.username, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    return UserNameIcon(
      username: usernamePublic, // Pass the username here
    );
  }
}

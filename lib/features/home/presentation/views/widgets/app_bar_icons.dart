import 'package:flutter/material.dart';
import 'package:lms/features/home/presentation/views/widgets/user_name_icon.dart';

class UserOptionsIcons extends StatelessWidget {
  final String username;

  const UserOptionsIcons({
    Key? key,
    required this.username, // Add this parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.terminal, color: Colors.white),
        ),
        const SizedBox(
          width: 7,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.phone_android, color: Colors.white),
        ),
        const SizedBox(
          width: 7,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, color: Colors.white),
        ),
        const SizedBox(
          width: 7,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings, color: Colors.white),
        ),
        const SizedBox(
          width: 7,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.question_mark_outlined,
            color: Colors.white,
          ),
        ),
        UserNameIcon(
          username: username, // Pass the username here
        ),
      ],
    );
  }
}

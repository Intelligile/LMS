import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/styles.dart';

class UserNameIcon extends StatelessWidget {
  final String username;

  UserNameIcon({required this.username});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate the size of the container as a percentage of the screen size
    double containerSize = screenWidth * 0.04; // 4% of the screen width

    return GestureDetector(
      onTap: () {
        // Show popup menu when the circle is tapped
        _showPopupMenu(context);
      },
      child: Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: Colors.white),
        ),
        child: Center(
          child: Text(
            // USERNAME FROM SHARED PREFERENCE
            username,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _showPopupMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          100, 80, 100, 0), // Adjust the position of the popup
      items: [
        PopupMenuItem(
          child: Text("Manage Profile"),
          value: "manage_profile",
        ),
        PopupMenuItem(
          child: Text("Logout"),
          value: "logout",
        ),
      ],
    ).then((value) {
      if (value == "manage_profile") {
        _navigateToManageProfile(context, username);
      } else if (value == "logout") {
        _performLogout(context);
      }
    });
  }

  void _navigateToManageProfile(BuildContext context, String username) {
    print("IM IN the username is $username");

    GoRouter.of(context).go('${AppRouter.kUserProfile}/$username');
  }

  void _performLogout(BuildContext context) {
    // Handle logout functionality here
    print("User logged out");
  }
}

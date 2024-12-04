import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            username, // Display username initial
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _showPopupMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        overlay.size.width - 40, // Align popup menu to the right of the screen
        80,
        10,
        0,
      ),
      items: [
        const PopupMenuItem(
          value: "manage_profile",
          child: Text("Manage Profile"),
        ),
        const PopupMenuItem(
          value: "logout",
          child: Text("Logout"),
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
    // Navigate to the user profile page
    GoRouter.of(context).go('${AppRouter.kUserProfile}/$username');
  }

  void _performLogout(BuildContext context) async {
    // Handle logout by clearing user session (e.g., shared preferences)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved data (like session or token)

    // Navigate to the login page or another appropriate page
    GoRouter.of(context).go(AppRouter.kSignIn);

    // Optional: Show a message to confirm logout
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );
  }
}

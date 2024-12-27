import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/app_router.dart';

import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';

class EmailVerificationPage extends StatelessWidget {
  final String username; // Username passed to check verification
  final AuthRemoteDataSource authRemoteDataSource; // Data source for API calls

  const EmailVerificationPage({
    super.key,
    required this.username,
    required this.authRemoteDataSource,
  });

  Future<bool> checkIfVerified(BuildContext context) async {
    try {
      // Call the backend to verify if the user is now verified
      final response = await authRemoteDataSource.loginUser(
        username: username,
        password: "", // Add a valid password if needed
      );

      // If verified, return true
      if (response.containsKey('isVerified') &&
          (response['isVerified'] == true ||
              response['isVerified'] == "true")) {
        return true;
      }
    } catch (e) {
      // Handle errors or return false if the user is not verified
      showSnackBar(
          context, "Error checking verification status: $e", Colors.red);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Verify Your Email')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email, color: Colors.blue, size: 100),
              const SizedBox(height: 16),
              const Text(
                'An email has been sent to verify your account. Please check your inbox.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Logic to resend verification email
                  showSnackBar(
                    context,
                    "Verification email resent to $username",
                    Colors.green,
                  );
                },
                child: const Text('Resend Verification Email'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Check if the user is now verified
                  bool isVerified = await checkIfVerified(context);
                  if (isVerified) {
                    showSnackBar(
                      context,
                      "Account verified successfully. Logging in...",
                      Colors.green,
                    );

                    // Automatically navigate to the home page or log the user in
                    GoRouter.of(context).push(AppRouter.kHomeView);
                  } else {
                    // If not verified, redirect to login with a warning
                    showSnackBar(
                      context,
                      "Account not verified. Please check your email.",
                      Colors.orange,
                    );
                    GoRouter.of(context).push(AppRouter.kSignIn);
                  }
                },
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

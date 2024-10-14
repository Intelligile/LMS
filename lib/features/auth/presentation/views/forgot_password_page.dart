import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/features/auth/presentation/views/widgets/verification_code_dialog.dart';
import 'package:lms/features/auth/presentation/views/widgets/forgot_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordPage({super.key});

  Future<void> _submitEmail(BuildContext context) async {
    final email = emailController.text.trim();
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }

    // Placeholder for actual email submission logic
    // For now, assume success and show verification dialog
    _showVerificationDialog(context);
  }

  void _showVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return VerificationCodeDialog(
          onSubmit: (code) {
            // Handle the verification code submission
            context.go('/reset_password'); // Navigate to reset password page
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/'); // Navigate back to the sign-in page
          },
        ),
        title: const Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ForgotPasswordForm(
          emailController: emailController,
          onSubmitEmail: () => _submitEmail(context),
        ),
      ),
    );
  }
}

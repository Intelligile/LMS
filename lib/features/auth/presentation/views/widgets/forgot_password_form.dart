import 'package:flutter/material.dart';

class ForgotPasswordForm extends StatelessWidget {
  final TextEditingController emailController;
  final VoidCallback onSubmitEmail;

  const ForgotPasswordForm({
    super.key,
    required this.emailController,
    required this.onSubmitEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Enter your email",
              hintText: "example@domain.com",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: Icon(Icons.email, color: Colors.blue.shade700),
            ),
            onChanged: (value) {
              // Validate that the input contains an @ symbol
              if (!value.contains('@')) {
                // Optionally, show a message or change the input decoration if needed
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Trim the email and validate it's not empty and has an '@'
              String trimmedEmail = emailController.text.trim();
              if (trimmedEmail.isEmpty || !trimmedEmail.contains('@')) {
                // Show an error message if the email is invalid
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please enter a valid email address')),
                );
              } else {
                onSubmitEmail();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Reset Password"),
          ),
        ],
      ),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/features/auth/presentation/views/widgets/forgot_password_form.dart';
import 'package:lms/features/auth/presentation/views/widgets/verification_code_dialog.dart';
import 'package:lms/core/utils/api.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final Api api = Api(Dio()); // Create an instance of the Api class

  ForgotPasswordPage({super.key});

  Future<void> _submitEmail(BuildContext context) async {
    final email = emailController.text.trim();
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }

    try {
      // Call API to send reset email
      final response = await api.post(
        endPoint: 'api/auth/forgot-password',
        body: {'email': email},
      );

      if (response['message'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        _showVerificationDialog(
            context, email); // Pass the email for verification
      } else {
        throw Exception('Failed to send email.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _showVerificationDialog(BuildContext context, String email) {
    final List<TextEditingController> codeControllers = List.generate(6,
        (index) => TextEditingController()); // Controllers for each digit box
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    bool isCodeVerified = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                isCodeVerified
                    ? "Enter New Password"
                    : "Enter Verification Code",
              ),
              content: isCodeVerified
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: newPasswordController,
                          decoration: const InputDecoration(
                            labelText: "New Password",
                            hintText: "Enter your new password",
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: confirmPasswordController,
                          decoration: const InputDecoration(
                            labelText: "Confirm Password",
                            hintText: "Confirm your new password",
                          ),
                          obscureText: true,
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) => SizedBox(
                          width: 40,
                          child: TextField(
                            controller: codeControllers[index],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            buildCounter: (context,
                                    {required currentLength,
                                    required isFocused,
                                    maxLength}) =>
                                null,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                if (value.length > 1) {
                                  // Handle pasted text
                                  for (int i = 0;
                                      i < value.length && index + i < 6;
                                      i++) {
                                    codeControllers[index + i].text = value[i];
                                  }
                                  FocusScope.of(context)
                                      .unfocus(); // Close the keyboard
                                } else if (index < 5) {
                                  // Move focus to the next box
                                  FocusScope.of(context).nextFocus();
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!isCodeVerified) {
                      // Verification step
                      final code = codeControllers
                          .map((controller) => controller.text.trim())
                          .join();
                      if (code.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter a valid code.')),
                        );
                        return;
                      }

                      try {
                        final response = await api.post(
                          endPoint: 'api/auth/verify-reset-code',
                          body: {'verificationCode': code},
                        );

                        if (response['status'] == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response['message'])),
                          );
                          setState(() {
                            isCodeVerified = true; // Move to password step
                          });
                        } else {
                          throw Exception(
                              response['message'] ?? 'Verification failed.');
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    } else {
                      // Password reset step
                      final newPassword = newPasswordController.text.trim();
                      final confirmPassword =
                          confirmPasswordController.text.trim();

                      if (newPassword.isEmpty || confirmPassword.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('All fields are required.')),
                        );
                        return;
                      }

                      if (newPassword != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Passwords do not match.')),
                        );
                        return;
                      }

                      try {
                        final response = await api.post(
                          endPoint: 'api/auth/reset-password',
                          body: {
                            'verificationCode': codeControllers
                                .map((controller) => controller.text.trim())
                                .join(),
                            'newPassword': newPassword,
                          },
                        );

                        if (response['status'] == true) {
                          Navigator.of(context).pop(); // Close the dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Password reset successfully.')),
                          );
                          context.go('/'); // Navigate back to the login page
                        } else {
                          throw Exception(
                              response['message'] ?? 'Password reset failed.');
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    }
                  },
                  child: Text(isCodeVerified ? "Submit" : "Verify"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
      ),
    );
  }
}

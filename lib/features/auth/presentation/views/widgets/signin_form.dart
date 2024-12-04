import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';

class SignInForm extends StatefulWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const SignInForm({
    super.key,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  bool? isLicensor = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          showSnackBar(context, 'Sign-in successful', Colors.green);
          GoRouter.of(context).push(AppRouter.kHomeView);
        } else if (state is SignInFailure) {
          showSnackBar(context, state.error, Colors.red);
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40), // Add spacing at the top
              const Text(
                'Select Role',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF017278), // LMS teal color
                ),
              ),
              const SizedBox(height: 20),
              RadioListTile<bool>(
                title: const Text('Licensee'),
                value: false,
                groupValue: isLicensor,
                activeColor: const Color(0xFF017278), // LMS color for selected
                onChanged: (bool? value) {
                  setState(() {
                    isLicensor = value;
                  });
                },
              ),
              RadioListTile<bool>(
                title: const Text('Licensor'),
                value: true,
                groupValue: isLicensor,
                activeColor: const Color(0xFF017278),
                onChanged: (bool? value) {
                  setState(() {
                    isLicensor = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: widget.usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: widget.passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    BlocBuilder<SignInCubit, SignInState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<SignInCubit>().signIn(
                                  username: widget.usernameController.text,
                                  password: widget.passwordController.text,
                                  isLicensor: isLicensor!);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF017278),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: state is SignInLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Sign In',
                                  style: TextStyle(fontSize: 16),
                                ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        context.go('/forgot-password');
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Color(0xFF017278)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SignInAlternative(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignInAlternative extends StatelessWidget {
  const SignInAlternative({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("Don't have an account?"),
        TextButton(
          onPressed: () {
            GoRouter.of(context).push(AppRouter.kRegister);
          },
          child: const Text(
            "Register",
            style: TextStyle(
              color: Color(0xFF017278), // LMS color for links
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

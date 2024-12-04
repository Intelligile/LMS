import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/auth/presentation/manager/registration_cubit/registration_cubit.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool? isLicensor = false;

  @override
  Widget build(BuildContext context) {
    // Define LMS theme color
    const lmsPrimaryColor = Color(0xFF017278);

    return BlocListener<RegistrationCubit, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationSuccess) {
          showSnackBar(context, 'Sign-up successful', Colors.green);
          GoRouter.of(context).push(AppRouter.kHomeView);
        } else if (state is RegistrationFailure) {
          showSnackBar(context, state.errorMessage, Colors.red);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Text(
                'Register',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: lmsPrimaryColor,
                ),
              ),
              const SizedBox(height: 30),
              RadioListTile<bool>(
                title: const Text('Licensee'),
                value: false, // Licensee corresponds to false
                groupValue: isLicensor,
                onChanged: (bool? value) {
                  setState(() {
                    isLicensor = value;
                  });
                },
                activeColor: lmsPrimaryColor,
              ),
              RadioListTile<bool>(
                title: const Text('Licensor'),
                value: true, // Licensor corresponds to true
                groupValue: isLicensor,
                onChanged: (bool? value) {
                  setState(() {
                    isLicensor = value;
                  });
                },
                activeColor: lmsPrimaryColor,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                controller: _usernameController,
                labelText: 'Username',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                lmsPrimaryColor: lmsPrimaryColor,
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                lmsPrimaryColor: lmsPrimaryColor,
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                controller: _firstNameController,
                labelText: 'First Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                lmsPrimaryColor: lmsPrimaryColor,
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                controller: _lastNameController,
                labelText: 'Last Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
                lmsPrimaryColor: lmsPrimaryColor,
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                controller: _phoneController,
                labelText: 'Phone',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                lmsPrimaryColor: lmsPrimaryColor,
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                controller: _emailController,
                labelText: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                lmsPrimaryColor: lmsPrimaryColor,
              ),
              const SizedBox(height: 25),
              BlocBuilder<RegistrationCubit, RegistrationState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lmsPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await context.read<RegistrationCubit>().register(
                                username: _usernameController.text,
                                password: _passwordController.text,
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                phone: _phoneController.text,
                                email: _emailController.text,
                                isLicensor: isLicensor!,
                              );
                        }
                      },
                      child: state is RegistrationLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Register',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              const RegisterAlternative(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
    bool obscureText = false,
    required Color lmsPrimaryColor,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: lmsPrimaryColor),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lmsPrimaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lmsPrimaryColor.withOpacity(0.6)),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: validator,
    );
  }
}

class RegisterAlternative extends StatelessWidget {
  const RegisterAlternative({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("Already have an account?"),
        TextButton(
          onPressed: () {
            GoRouter.of(context).push(AppRouter.kSignIn);
          },
          child:
              const Text("Sign in", style: TextStyle(color: Color(0xFF017278))),
        ),
      ],
    );
  }
}

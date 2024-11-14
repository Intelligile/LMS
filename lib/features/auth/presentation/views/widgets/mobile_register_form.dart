import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/widgets/build_text_field.dart';
import 'package:lms/features/auth/presentation/manager/registration_cubit/registration_cubit.dart';
import 'package:lms/features/auth/presentation/views/widgets/desktop_register_form.dart';

class MobileRegisterForm extends StatefulWidget {
  const MobileRegisterForm({super.key});

  @override
  _MobileRegisterFormState createState() => _MobileRegisterFormState();
}

class _MobileRegisterFormState extends State<MobileRegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationCubit, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationSuccess) {
          showSnackBar(context, 'Sign-up successful', Colors.green);
          GoRouter.of(context).push(AppRouter.kHomeView);
        } else if (state is RegistrationFailure) {
          showSnackBar(context, state.errorMessage, Colors.red);
        }
      },
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LMS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 24),
                      buildAuthTextField(
                          controller: _usernameController, label: 'Username'),
                      const SizedBox(height: 16),
                      buildAuthTextField(
                          controller: _passwordController,
                          label: 'Password',
                          obscureText: true),
                      const SizedBox(height: 16),
                      buildAuthTextField(
                          controller: _firstNameController,
                          label: 'First Name'),
                      const SizedBox(height: 16),
                      buildAuthTextField(
                          controller: _lastNameController, label: 'Last Name'),
                      const SizedBox(height: 16),
                      buildAuthTextField(
                          controller: _phoneController, label: 'Phone'),
                      const SizedBox(height: 16),
                      buildAuthTextField(
                          controller: _emailController, label: 'Email'),
                      const SizedBox(height: 24),
                      BlocBuilder<RegistrationCubit, RegistrationState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await context
                                    .read<RegistrationCubit>()
                                    .register(
                                      username: _usernameController.text,
                                      password: _passwordController.text,
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      phone: _phoneController.text,
                                      email: _emailController.text,
                                    );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: state is RegistrationLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Next',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      const RegisterAlternative(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

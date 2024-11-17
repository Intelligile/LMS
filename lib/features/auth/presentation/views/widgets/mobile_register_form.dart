import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/widgets/build_text_field.dart';
import 'package:lms/features/auth/presentation/manager/registration_cubit/registration_cubit.dart';

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

  // Organization fields
  final _organizationNameController = TextEditingController();
  final _organizationCountryController = TextEditingController();
  final _organizationAddressController = TextEditingController();
  final _organizationContactEmailController = TextEditingController();
  final _organizationContactPhoneController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _usernameController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _organizationNameController.dispose();
    _organizationCountryController.dispose();
    _organizationAddressController.dispose();
    _organizationContactEmailController.dispose();
    _organizationContactPhoneController.dispose();
    super.dispose();
  }

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
              elevation: 2,
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

                      // User Fields
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

                      // Organization Fields
                      const Text(
                        'Organization Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildAuthTextField(
                          controller: _organizationNameController,
                          label: 'Organization Name'),
                      const SizedBox(height: 16),
                      buildAuthTextField(
                          controller: _organizationCountryController,
                          label: 'Country'),
                      const SizedBox(height: 16),
                      buildAuthTextField(
                          controller: _organizationAddressController,
                          label: 'Address'),
                      const SizedBox(height: 16),
                      buildAuthTextField(
                          controller: _organizationContactEmailController,
                          label: 'Contact Email'),
                      const SizedBox(height: 16),
                      buildAuthTextField(
                          controller: _organizationContactPhoneController,
                          label: 'Contact Phone'),
                      const SizedBox(height: 24),

                      // Submit Button
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
                                      organizationName:
                                          _organizationNameController.text,
                                      organizationCountry:
                                          _organizationCountryController.text,
                                      organizationAddress:
                                          _organizationAddressController.text,
                                      organizationContactEmail:
                                          _organizationContactEmailController
                                              .text,
                                      organizationContactPhone:
                                          _organizationContactPhoneController
                                              .text,
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

                      // Navigation to Sign In
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              GoRouter.of(context).push(AppRouter.kSignIn);
                            },
                            child: const Text(
                              "Sign in",
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        ],
                      ),
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

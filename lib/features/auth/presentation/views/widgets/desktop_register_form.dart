import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/constants.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/widgets/build_text_field.dart';
import 'package:lms/features/auth/presentation/manager/registration_cubit/registration_cubit.dart';

class DesktopRegisterForm extends StatefulWidget {
  const DesktopRegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<DesktopRegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // Organization fields
  final _accountNameController = TextEditingController();
  final _departmentNameController = TextEditingController();
  final _legalEntityNameController = TextEditingController();
  final _globalEntityNameController = TextEditingController();
  final _websiteController = TextEditingController();
  final _legalContactNameController = TextEditingController();
  final _legalContactEmailController = TextEditingController();
  final _legalContactNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationCubit, RegistrationState>(
      listener: (context, state) {
        // Debug state
        print("Current State: $state");

        if (state is RegistrationSuccess) {
          // Navigate to home view for verified users
          showSnackBar(
            context,
            'Sign-up successful! You are verified.',
            Colors.green,
          );
          GoRouter.of(context).push(AppRouter.kHomeView);
        } else if (state is RegistrationFailure) {
          // Navigate to verification page for unverified users
          showSnackBar(context, state.errorMessage, Colors.red);
          GoRouter.of(context).push(AppRouter.kVerifyAccount);
        } else if (state is RegistrationFailure) {
          // Handle general errors
          showSnackBar(context, state.errorMessage, Colors.red);
        }
      },
      child: Center(
        child: SingleChildScrollView(
          child: Row(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(
                flex: 2,
                child: Card(
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
                              controller: _usernameController,
                              label: 'Username'),
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
                              controller: _lastNameController,
                              label: 'Last Name'),
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
                              controller: _accountNameController,
                              label: 'Account Name'),
                          const SizedBox(height: 16),
                          buildAuthTextField(
                              controller: _departmentNameController,
                              label: 'Department Name'),
                          const SizedBox(height: 16),
                          buildAuthTextField(
                              controller: _legalEntityNameController,
                              label: 'Legal Entity Name'),
                          const SizedBox(height: 16),
                          buildAuthTextField(
                              controller: _globalEntityNameController,
                              label: 'Global Entity Name'),
                          const SizedBox(height: 16),
                          buildAuthTextField(
                              controller: _websiteController, label: 'Website'),
                          const SizedBox(height: 16),
                          buildAuthTextField(
                              controller: _legalContactNameController,
                              label: 'Legal Contact Name'),
                          const SizedBox(height: 16),
                          buildAuthTextField(
                              controller: _legalContactEmailController,
                              label: 'Legal Contact Email'),
                          const SizedBox(height: 16),
                          buildAuthTextField(
                              controller: _legalContactNumberController,
                              label: 'Legal Contact Number'),
                          const SizedBox(height: 24),

                          // Submit Button
                          Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              Expanded(
                                flex: 2,
                                child: BlocBuilder<RegistrationCubit,
                                    RegistrationState>(
                                  builder: (context, state) {
                                    return ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          await context
                                              .read<RegistrationCubit>()
                                              .register(
                                                username:
                                                    _usernameController.text,
                                                password:
                                                    _passwordController.text,
                                                firstName:
                                                    _firstNameController.text,
                                                lastName:
                                                    _lastNameController.text,
                                                phone: _phoneController.text,
                                                email: _emailController.text,
                                                accountName:
                                                    _accountNameController.text,
                                                departmentName:
                                                    _departmentNameController
                                                        .text,
                                                legalEntityName:
                                                    _legalEntityNameController
                                                        .text,
                                                globalEntityName:
                                                    _globalEntityNameController
                                                        .text,
                                                website:
                                                    _websiteController.text,
                                                legalContactName:
                                                    _legalContactNameController
                                                        .text,
                                                legalContactEmail:
                                                    _legalContactEmailController
                                                        .text,
                                                legalContactNumber:
                                                    _legalContactNumberController
                                                        .text,
                                              );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
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
                              ),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const RegisterAlternative(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Expanded(child: SizedBox())
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterAlternative extends StatelessWidget {
  const RegisterAlternative({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const Text("Already have an account?"),
        TextButton(
          onPressed: () {
            GoRouter.of(context).push(AppRouter.kSignIn);
          },
          child: const Text(
            "Sign in",
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}

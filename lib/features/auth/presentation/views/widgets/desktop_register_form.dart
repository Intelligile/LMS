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
          child: Row(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(
                flex: 2,
                child: Card(
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
                                                color: Colors.white,
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
          child: const Text("Sign in", style: TextStyle(color: kPrimaryColor)),
        ),
      ],
    );
  }
}

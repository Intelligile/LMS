import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/constants.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/widgets/build_text_field.dart';
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildAuthTextField(
                controller: widget.usernameController,
                label: 'Username or Email'),
            const SizedBox(height: 16),
            buildAuthTextField(
                controller: widget.passwordController,
                label: 'Password',
                obscureText: true),
            const SizedBox(height: 16),
            const SignInAlternative(),
            TextButton(
              onPressed: () {
                context.go('/forgot-password');
              },
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
              ),
              child: const Text(
                "Forgot Password?",
                style: TextStyle(color: kPrimaryColor),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(child: SizedBox()),
                Expanded(
                  flex: 2,
                  child: BlocBuilder<SignInCubit, SignInState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<SignInCubit>().signIn(
                                  username: widget.usernameController.text,
                                  password: widget.passwordController.text,
                                );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          //  backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: state is SignInLoading
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
          ],
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const Text("Don't have an account?"),
        TextButton(
          onPressed: () {
            GoRouter.of(context).push(AppRouter.kRegister);
          },
          child: const Text(
            "Register",
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}

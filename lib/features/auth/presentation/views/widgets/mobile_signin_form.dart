import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/auth/data/repositories/auth_repositroy_impl.dart';
import 'package:lms/features/auth/domain/use_case/login_use_case.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:lms/features/auth/presentation/views/widgets/desktop_signin_form.dart';

class LoginMobileLayout extends StatefulWidget {
  const LoginMobileLayout({
    super.key,
  });

  @override
  State<LoginMobileLayout> createState() => _LoginMobileLayoutState();
}

class _LoginMobileLayoutState extends State<LoginMobileLayout> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Microsoft Logo
                const Text(
                  'LMS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 24),
                BlocProvider(
                  create: (_) => SignInCubit(
                    LoginUseCase(
                      AuthRepositoryImpl(
                        authRemoteDataSource: AuthRemoteDataSourceImpl(
                          api: Api(Dio()),
                          context,
                        ),
                      ),
                    ),
                  ),
                  child: SignInForm(
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

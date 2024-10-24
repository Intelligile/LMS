import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/auth/data/repositories/auth_repositroy_impl.dart';
import 'package:lms/features/auth/domain/use_case/login_use_case.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:lms/features/auth/presentation/views/widgets/signin_form.dart';

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({
    super.key,
  });

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 300,
            color: Colors.blue,
            child: const Center(
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: BlocProvider(
              create: (_) => SignInCubit(
                LoginUseCase(
                  AuthRepositoryImpl(
                    authRemoteDataSource: AuthRemoteDataSourceImpl(
                        api: Api(
                          Dio(),
                        ),
                        context),
                  ),
                ),
              ),
              child: SignInForm(
                usernameController: _usernameController,
                passwordController: _passwordController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

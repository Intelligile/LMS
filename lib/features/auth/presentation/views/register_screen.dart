import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/auth/data/repositories/auth_repositroy_impl.dart';
import 'package:lms/features/auth/domain/use_case/register_use_case.dart';
import 'package:lms/features/auth/presentation/manager/registration_cubit/registration_cubit.dart';
import 'package:lms/features/auth/presentation/views/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: BlocProvider(
        create: (context) => RegistrationCubit(
          RegisterUseCase(
            authRepository: AuthRepositoryImpl(
              authRemoteDataSource: AuthRemoteDataSourceImpl(
                api: Api(
                  Dio(),
                ),
              ),
            ),
          ),
        ),
        child: RegisterForm(),
      ),
    );
  }
}

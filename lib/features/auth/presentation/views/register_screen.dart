import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/widgets/adaptive_layout_widget.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/auth/data/repositories/auth_repositroy_impl.dart';
import 'package:lms/features/auth/domain/use_case/register_use_case.dart';
import 'package:lms/features/auth/presentation/manager/registration_cubit/registration_cubit.dart';
import 'package:lms/features/auth/presentation/views/widgets/desktop_register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffdce1e3),
      body: BlocProvider(
        create: (context) => RegistrationCubit(
          RegisterUseCase(
            authRepository: AuthRepositoryImpl(
              authRemoteDataSource: AuthRemoteDataSourceImpl(
                  api: Api(
                    Dio(),
                  ),
                  context),
            ),
          ),
        ),
        child: AdaptiveLayout(
          mobileLayout: (context) => const SizedBox(),
          tabletLayout: (context) => const SizedBox(),
          desktopLayout: (context) => const DesktopRegisterForm(),
        ),
      ),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/widgets/adaptive_layout_widget.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/auth/data/repositories/auth_repositroy_impl.dart';
import 'package:lms/features/auth/domain/use_case/login_use_case.dart';
import 'package:lms/features/auth/domain/use_case/register_use_case.dart';
import 'package:lms/features/auth/presentation/manager/registration_cubit/registration_cubit.dart';
import 'package:lms/features/auth/presentation/views/widgets/desktop_register_form.dart';
import 'package:lms/features/auth/presentation/views/widgets/mobile_register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create necessary dependencies
    final api = Api(Dio());
    final authRemoteDataSource = AuthRemoteDataSourceImpl(api: api, context);
    final authRepository =
        AuthRepositoryImpl(authRemoteDataSource: authRemoteDataSource);

    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) => RegistrationCubit(
            RegisterUseCase(authRepository: authRepository),
            authRemoteDataSource,
            LoginUseCase(authRepository), // Pass authRepository correctly
          ),
          child: AdaptiveLayout(
            mobileLayout: (context) => const MobileRegisterForm(),
            tabletLayout: (context) => const SizedBox(),
            desktopLayout: (context) => const DesktopRegisterForm(),
          ),
        ),
      ),
    );
  }
}

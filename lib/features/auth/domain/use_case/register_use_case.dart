// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository authRepository;
  RegisterUseCase({
    required this.authRepository,
  });
  Future<Either<Failure, Unit>> call(
      {required String fn,
      required String ln,
      required String pw,
      required String un,
      required String phone,
      required String email,
      required bool isLicensor}) async {
    return await authRepository.registerUser(
        firstName: fn,
        lastName: ln,
        username: un,
        password: pw,
        phone: phone,
        email: email,
        isLicensor: isLicensor);
  }
}

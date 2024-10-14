import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<Either<Failure, Unit>> call(
      {required String un,
      required String pw,
      required bool isLicensor}) async {
    return await authRepository.loginUser(
        username: un, password: pw, isLicensor: isLicensor);
  }
}

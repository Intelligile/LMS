import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  // Regular login use case
  Future<Either<Failure, Unit>> call({
    required String un,
    required String pw,
  }) async {
    return await authRepository.loginUser(
      username: un,
      password: pw,
    );
  }

  // DMZ login use case
  Future<Either<Failure, Unit>> dmzLogin({
    required String uniqueId,
    required String password,
  }) async {
    return await authRepository.dmzLogin(
      uniqueId: uniqueId,
      password: password,
    );
  }
}

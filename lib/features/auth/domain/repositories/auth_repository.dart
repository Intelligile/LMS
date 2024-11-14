import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> loginUser({
    required String username,
    required String password,
  });

  Future<Either<Failure, Unit>> dmzLogin({
    required String uniqueId,
    required String password,
  });

  Future<Either<Failure, Unit>> registerUser({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
  });
}

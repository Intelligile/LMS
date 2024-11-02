import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> loginUser({String username, String password});
  Future<Either<Failure, Unit>> registerUser({
    String username,
    String password,
    String firstName,
    String lastName,
    String phone,
    String email,
  });
}

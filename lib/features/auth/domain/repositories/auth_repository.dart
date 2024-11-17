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
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String phone,
    required String email,
    required String organizationName,
    required String organizationCountry,
    required String organizationAddress,
    required String organizationContactEmail,
    required String organizationContactPhone,
  });
}

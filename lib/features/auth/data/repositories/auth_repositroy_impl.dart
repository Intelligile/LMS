// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
  });

  @override
  Future<Either<Failure, Unit>> loginUser({
    String username = '',
    String password = '',
  }) async {
    try {
      await authRemoteDataSource.loginUser(
          password: password, username: username);
      return right(unit); // Return Unit from dartz
    } catch (e) {
      print("Error in loginUser: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> registerUser({
    String username = '',
    String password = '',
    String firstName = '',
    String lastName = '',
    String phone = '',
    String email = '',
  }) async {
    try {
      await authRemoteDataSource.registerUser(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
        password: password,
        username: username,
      );
      return right(unit); // Return Unit from dartz
    } catch (e) {
      print("Error in registerUser: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}

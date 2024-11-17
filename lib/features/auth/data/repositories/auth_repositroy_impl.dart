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
      // Await the result from loginUser in authRemoteDataSource
      await authRemoteDataSource.loginUser(
        password: password,
        username: username,
      );

      return right(unit); // Return Unit from dartz if successful
    } catch (e) {
      print("Error in loginUser: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString())); // Return the error message
    }
  }

  @override
  Future<Either<Failure, Unit>> dmzLogin({
    required String uniqueId,
    required String password,
  }) async {
    try {
      // Await the result from dmzLogin in authRemoteDataSource
      await authRemoteDataSource.dmzLogin(
        uniqueId: uniqueId,
        password: password,
      );

      return right(unit); // Return Unit from dartz if successful
    } catch (e) {
      print("Error in dmzLogin: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString())); // Return the error message
    }
  }

  @override
  Future<Either<Failure, Unit>> registerUser({
    int id = 0,
    String username = '',
    String password = '',
    String firstName = '',
    String lastName = '',
    String phone = '',
    String email = '',
    String organizationName = '',
    String organizationCountry = '',
    String organizationAddress = '',
    String organizationContactEmail = '',
    String organizationContactPhone = '',
  }) async {
    try {
      // Pass all user and organization details to the remote data source
      await authRemoteDataSource.registerUser(
        id: id,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
        password: password,
        username: username,
        organizationName: organizationName,
        organizationCountry: organizationCountry,
        organizationAddress: organizationAddress,
        organizationContactEmail: organizationContactEmail,
        organizationContactPhone: organizationContactPhone,
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

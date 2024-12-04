// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/roles_and_premission/data/models/user_dto.dart';
import 'package:lms/features/roles_and_premission/data/remote_data_source/user_remote_data_source.dart';
import 'package:lms/features/roles_and_premission/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSource userRemoteDataSource;
  UserRepositoryImpl({
    required this.userRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<UserDto>>> getUsers({dynamic roleId}) async {
    try {
      List<UserDto> users = await userRemoteDataSource.getUsers(roleId: roleId);
      return right(users); // Return Unit from dartz
    } catch (e) {
      print("Error in registerUser: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}

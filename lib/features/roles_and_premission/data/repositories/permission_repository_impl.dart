// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/roles_and_premission/data/models/permission.dart';
import 'package:lms/features/roles_and_premission/data/remote_data_source/permission_remote_data_source.dart';
import 'package:lms/features/roles_and_premission/domain/repositories/permission_repository.dart';

class PermissionRepositoryImpl extends PermissionRepository {
  final PermissionRemoteDataSource permissionRemoteDataSource;
  PermissionRepositoryImpl({
    required this.permissionRemoteDataSource,
  });
  @override
  Future<Either<Failure, Unit>> addPermissions(
      List<Permission> permissions) async {
    try {
      await permissionRemoteDataSource.addPermissions(permissions);
      return right(unit); // Return Unit from dartz
    } catch (e) {
      print("Error in registerUser: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Permission>>> getPermissions(
      {String? roleName}) async {
    try {
      List<Permission> permissions =
          await permissionRemoteDataSource.getPermissions(roleName: roleName);
      return right(permissions); // Return Unit from dartz
    } catch (e) {
      print("Error in registerUser: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}

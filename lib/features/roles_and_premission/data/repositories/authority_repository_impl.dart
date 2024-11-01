// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/roles_and_premission/data/models/authority.dart';
import 'package:lms/features/roles_and_premission/data/remote_data_source/authority_remote_data_source.dart';
import 'package:lms/features/roles_and_premission/domain/repositories/authority_repository.dart';

class AuthorityRepositoryImpl extends AuthorityRepository {
  final AuthorityRemoteDataSource authorityRemoteDataSource;

  AuthorityRepositoryImpl({
    required this.authorityRemoteDataSource,
  });

  @override
  Future<Either<Failure, Unit>> addAuthorities(
      List<Authority> authorities) async {
    try {
      await authorityRemoteDataSource.addAuthorities(authorities);
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
  Future<Either<Failure, List<Authority>>> getAuthorities(
      {int? authorityId = 0}) async {
    try {
      List<Authority> authorities = await authorityRemoteDataSource
          .getAuthorities(authorityId: authorityId);
      return right(authorities); // Return Unit from dartz
    } catch (e) {
      print("Error in registerUser: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAuthorityPermissions(
      {required authorityId, required List newAuthorities}) async {
    try {
      await authorityRemoteDataSource.updateAuthorityPermissions(
          authorityId: authorityId, newAuthorities: newAuthorities);
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

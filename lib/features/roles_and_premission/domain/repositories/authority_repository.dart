import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/roles_and_premission/data/models/authority.dart';

abstract class AuthorityRepository {
  Future<Either<Failure, List<Authority>>> getAuthorities(
      {int? authorityId = 0});
  Future<Either<Failure, Unit>> addAuthorities(List<Authority> authorities);
  Future<Either<Failure, Unit>> updateAuthorityPermissions(
      {required dynamic authorityId, required List<dynamic> newAuthorities});
}

import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/roles_and_premission/data/models/permission.dart';

abstract class PermissionRepository {
  Future<Either<Failure, List<Permission>>> getPermissions({String? roleName});
  Future<Either<Failure, Unit>> addPermissions(List<Permission> permissions);
}

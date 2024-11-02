// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/roles_and_premission/data/models/permission.dart';
import 'package:lms/features/roles_and_premission/domain/repositories/permission_repository.dart';

class GetPermissionUseCase {
  final PermissionRepository permissionRepository;
  GetPermissionUseCase({
    required this.permissionRepository,
  });

  Future<Either<Failure, List<Permission>>> call({String? roleName}) async {
    return await permissionRepository.getPermissions(roleName: roleName);
  }
}

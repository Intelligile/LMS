import 'package:dartz/dartz.dart';
import '../repositories/user_group_repository.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/user_groups/domain/entities/user_group_model.dart';

class RemoveUserFromGroup {
  final UserGroupRepository repository;

  RemoveUserFromGroup(this.repository);

  Future<Either<Failure, void>> execute(UserGroup userGroup) {
    return repository.removeUserFromGroup(userGroup);
  }
}

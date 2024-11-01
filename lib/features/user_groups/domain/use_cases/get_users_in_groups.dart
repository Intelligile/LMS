import 'package:dartz/dartz.dart';
import '../repositories/user_group_repository.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/user_groups/domain/entities/user_group_model.dart';

class GetUsersInGroup {
  final UserGroupRepository repository;

  GetUsersInGroup(this.repository);

  Future<Either<Failure, List<UserGroup>>> execute(String groupId) {
    return repository.getUsersInGroup(groupId);
  }
}

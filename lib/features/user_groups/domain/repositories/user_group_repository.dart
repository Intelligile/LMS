import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/user_groups/domain/entities/user_group_model.dart';

abstract class UserGroupRepository {
  /// Assigns a user to a group.
  Future<Either<Failure, void>> assignUserToGroup(UserGroup userGroup);

  /// Removes a user from a group.
  Future<Either<Failure, void>> removeUserFromGroup(UserGroup userGroup);

  /// Fetches all users assigned to a specific group.
  Future<Either<Failure, List<UserGroup>>> getUsersInGroup(String groupId);
}

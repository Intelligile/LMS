import 'package:dartz/dartz.dart';
import 'package:lms/features/user_groups/data/models/user_group_model.dart';
import 'package:lms/features/user_groups/domain/entities/user_group_model.dart';
import '../../domain/repositories/user_group_repository.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/user_groups/data/data_sources/user_group_service.dart';

class UserGroupRepositoryImpl implements UserGroupRepository {
  final ApiService apiService;

  UserGroupRepositoryImpl(this.apiService);

  @override
  Future<void> assignUsersToGroup(int groupId, List<int> userIds) async {
    try {
      await apiService.assignUserToGroup(groupId, userIds);
    } catch (e) {
      throw Exception('Error assigning users to group: $e');
    }
  }

  @override
  Future<Either<Failure, void>> removeUserFromGroup(UserGroup userGroup) async {
    try {
      await apiService.removeUserFromGroup(userGroup.userId, userGroup.groupId);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure("User Not removed from this group $e"));
    }
  }

  @override
  Future<Either<Failure, List<UserGroup>>> getUsersInGroup(
      String groupId) async {
    try {
      final List<dynamic> result = await apiService.getUsersInGroup(groupId);
      final List<UserGroup> users = result
          .map((json) => UserGroupModel.fromJson(json).toEntity())
          .toList();
      return Right(users);
    } catch (e) {
      return Left(ServerFailure("Users cant be fetched $e"));
    }
  }

  @override
  Future<Either<Failure, void>> assignUserToGroup(UserGroup userGroup) {
    // TODO: implement assignUserToGroup
    throw UnimplementedError();
  }
}

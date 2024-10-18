import 'package:lms/features/user_groups/data/data_sources/user_group_service.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';

class GroupRepository {
  final ApiService apiService;

  GroupRepository({required this.apiService});
  Future<List<UserModel>> fetchUsers() async {
    try {
      // Assuming your API returns a list of users
      final response =
          await apiService.getUsers(); // Adjust endpoint accordingly
      return response
          .map<UserModel>((json) => UserModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  Future<List<GroupModel>> getGroups() async {
    return apiService.fetchGroups();
  }

  Future<void> createGroup(GroupModel group) async {
    await apiService.createGroup(group);
  }

  Future<void> updateGroup(GroupModel group) async {
    await apiService.updateGroup(group);
  }

  Future<void> deleteGroup(int groupId) async {
    await apiService.deleteGroup(groupId);
  }

  Future<void> assignUsersToGroup(int groupId, List<int> userIds) async {
    try {
      await apiService.assignUserToGroup(groupId, userIds);
    } catch (e) {
      throw Exception('Error assigning users to group: $e');
    }
  }

  // New method to revoke (remove) users from a group
  Future<void> revokeUsersFromGroup(int groupId, List<int> userIds) async {
    try {
      await apiService.revokeUserFromGroup(groupId, userIds);
    } catch (e) {
      throw Exception('Error revoking users from group: $e');
    }
  }
}

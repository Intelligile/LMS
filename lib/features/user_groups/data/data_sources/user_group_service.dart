import 'dart:convert'; // Import for jsonEncode

import 'package:lms/core/utils/api.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';

class ApiService {
  final Api api;

  ApiService({required this.api});

  Future<List<dynamic>> getUsers() async {
    try {
      final response = await api.get(endPoint: 'api/auth/users');
      // print("RESPONSE FROM GET USERS => $response");
      // Debug print
      print('Fetched GroupModel: $response');

      return response;
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  Future<List<GroupModel>> fetchGroups({dynamic filter}) async {
    List<GroupModel> groupsList = [];
    var result;

    // If you have specific filtering logic, adjust the endpoint accordingly
    result = await api.get(endPoint: 'api/auth/groups', token: '');

    // List<dynamic> data = jsonDecode(result.body);
    // for (var groupData in data) {
    //   groups.add(GroupModel.fromJson(groupData));
    // }

    for (var item in result) {
      print('Items: $item');
      if (item is Map<String, dynamic>) {
        // Process only if the item is a valid user object
        try {
          GroupModel group = GroupModel.fromJson(item);
          groupsList.add(group);
        } catch (e) {
          print('Failed to parse group data: $e');
        }
      } else {
        print('Invalid user data format: $item');
      }
    }

    return groupsList;
  }

  Future<void> createGroup(GroupModel group) async {
    final response = await api.post(
      endPoint: 'api/auth/groups/add-group',
      body: group.toJson(),
      token: '',
    );

    // if (response.statusCode != 201) {
    //   throw Exception('Failed to create group');
    // }
  }

  Future<void> updateGroup(GroupModel group) async {
    final response = await api.put(
      endPoint: 'api/auth/groups/${group.id}',
      body: group.toJson(),
      token: '',
    );
  }

  Future<void> assignUsers(GroupModel group) async {
    final response = await api.put(
      endPoint: 'api/auth/groups/${group.id}/assign-users',
      body: group.toJson(),
      token: '',
    );
  }

  Future<void> deleteGroup(int groupId) async {
    print("ID on DELETE $groupId");
    final response =
        await api.delete2(endPoint: 'api/auth/groups/$groupId', body: '');
    return response;
  }

  Future<void> assignUserToGroup(int groupId, List<int> userIds) async {
    try {
      // Convert the List<String> to a JSON string
      final jsonString = jsonEncode(userIds);
      print("USER IDs $jsonString");
      // Make the POST request with the JSON string as the body
      final response = await api.post(
        endPoint: 'api/auth/groups/$groupId/assign-users',
        body: jsonString, // Pass the JSON string as the body
        token: '', // Add your token if needed
      );
      print("USERS ASSIGNED");
    } catch (e) {
      print('Error assigning users to group: $e');
    }
  }

  // Method to revoke users from a group
  Future<void> revokeUserFromGroup(int groupId, List<int> userIds) async {
    try {
      await api.delete2(
        endPoint: 'api/auth/groups/$groupId/revoke-users',
        body: userIds, // Send userIds directly as a JSON array
      );
      print("USERS UNASSIGNED");
    } catch (e) {
      throw Exception('Failed to revoke users from group: $e');
    }
  }

  Future<void> removeUserFromGroup(String userId, String groupId) async {
    // Implement API call to remove a user from a group
  }

  Future<List<dynamic>> getUsersInGroup(String groupId) async {
    // Implement API call to get users in a group and return as a list
    return [];
  }
}

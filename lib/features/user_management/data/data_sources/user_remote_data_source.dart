import 'dart:convert';

import 'package:lms/core/utils/api.dart';

import '../models/user_model.dart';

class UserRemoteDataSource {
  final Api api;

  UserRemoteDataSource(this.api);

  Future<String> addUsers(List<UserModel> users) async {
    // Prepare the list of user data for the request body
    List<Map<String, dynamic>> userDataList = users.map((user) {
      return {
        "username": user.username,
        "password": user.password,
        "email": user.email,
        "firstname": user.firstname,
        "lastname": user.lastname,
        "phone": user.phone,
        "enabled": user.enabled,
      };
    }).toList();

    // Debugging: Print the JSON data
    print("JSON Request Body: ${jsonEncode(userDataList)}");

    List<String> results = [];

    try {
      // Send a single request with all users
      var response = await api.post(
        endPoint: "api/auth/signup",
        body: userDataList,
      );
      results.add("Users added successfully");
    } catch (e) {
      results.add("Failed to add users: $e");
    }

    return results.join('\n');
  }

  Future<String> updateUser(UserModel user, String token) async {
    try {
      var response = await api.put(
        endPoint:
            "api/auth/update/${user.id}", // Adjust the endpoint as per your API
        body: {
          "username": user.username,
          "password": user.password,
          "email": user.email,
          "firstname": user.firstname,
          "lastname": user.lastname,
          "phone": user.phone,
          "enabled": user.enabled,
        },
        token: token,
      );
      return "User updated successfully";
    } catch (e) {
      return "Failed to update user: $e";
    }
  }

  Future<String> removeUser(int userId) async {
    try {
      var response = await api.delete(
        endPoint: "/api/auth/delete/$userId",
      );

      print("Response data: $response");

      return "User removed successfully";
    } catch (e) {
      print("Failed to remove user: $e");
      rethrow; // Re-throw the exception to handle it in the calling code
    }
  }

  Future<List<UserModel>> getUsers() async {
    try {
      var response = await api.get(endPoint: "api/auth/users");

      // Debugging: Print the response
      print("Response: $response");

      List<UserModel> users = [];

      for (var item in response) {
        if (item is Map<String, dynamic>) {
          // Process only if the item is a valid user object
          try {
            UserModel user = UserModel.fromJson(item);
            users.add(user);
          } catch (e) {
            print('Failed to parse user data: $e');
          }
        } else {
          print('Invalid user data format: $item');
        }
      }

      return users;
    } catch (e) {
      print("Failed to get users: $e");
      return [];
    }
  }
}

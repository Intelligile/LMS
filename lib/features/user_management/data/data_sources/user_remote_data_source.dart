import 'dart:convert';

import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/user_management/data/models/license_model.dart';

import '../models/user_model.dart';

class UserManagementRemoteDataSource {
  final Api api;

  UserManagementRemoteDataSource(this.api);

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
      print(e);
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
      var response =
          await api.delete2(endPoint: "api/auth/delete/$userId", body: '');

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

  Future<Map<String, dynamic>> getUserProfile(String username) async {
    try {
      // Call the API to get the user data as a Map
      var response = await api.getUser(
          endPoint: "api/auth/user/profile/$username", token: jwtToken);

      // Convert the Map to UserModel
      return response;
    } catch (e) {
      print("Failed to get user profile: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> userJson, String token) async {
    try {
      var response = await api.put(
        endPoint: "api/auth/update/${userJson['id']}",
        body: userJson, // Send the JSON data
        token: token,
      );

      return response;
    } catch (e) {
      print("Failed to update user profile: $e");
      throw "Failed to update user profile: $e";
    }
  }

  Future<List<LicenseModel>> getUserLicenses(int userId, String token) async {
    try {
      // Call the API to get licenses data
      var response = await api.getUserLicenses(
          endPoint: "api/license/user/$userId", token: token);

      print("Response from API: $response");

      // Convert the Map response to a list of LicenseModel
      List<LicenseModel> licenses = (response)
          .map((licenseData) =>
              LicenseModel.fromJson(licenseData as Map<String, dynamic>))
          .toList();

      return licenses;
    } catch (e) {
      // print("Failed to get user licenses: $e");
      rethrow;
    }
  }
}

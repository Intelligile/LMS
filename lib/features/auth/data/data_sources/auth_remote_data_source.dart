import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/models/user_model.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';

String jwtToken = '';
String usernamePublic = '';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> loginUser(
      {required String username, required String password});
  Future<Map<String, dynamic>> dmzLogin(
      {required String uniqueId, required String password});
  Future<void> registerUser({
    required int id,
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String phone,
    required String email,
    String? organizationName,
    String? organizationCountry,
    String? organizationAddress,
    String? organizationContactEmail,
    String? organizationContactPhone,
  });
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final Api api;
  final BuildContext context;
  AuthRemoteDataSourceImpl(this.context, {required this.api});
  final _secureStorage = const FlutterSecureStorage();

  @override
  Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    var result = await api.post(
      endPoint: "api/auth/signin",
      body: {
        "username": username,
        "password": password,
      },
    );

    if (result is String) {
      print("Login error: $result");
      throw Exception("Login failed: $result");
    }

    if (result is Map<String, dynamic> &&
        result.containsKey('roles') &&
        result.containsKey('organizationId') &&
        result.containsKey('jwtToken') &&
        result.containsKey('username')) {
      userRole = result['roles'];
      print("User role: $userRole");

      jwtToken = result['jwtToken'];
      usernamePublic = result['username'];

      await _secureStorage.write(key: 'jwtToken', value: result['jwtToken']);
      await _secureStorage.write(
          key: 'usernamePublic', value: result['username']);
      await _secureStorage.write(key: 'userRole', value: result['roles']);

      // Ensure organizationId is converted to String
      await _secureStorage.write(
          key: 'organizationId', value: result['organizationId'].toString());

      if (result.containsKey('exp')) {
        await _secureStorage.write(
            key: 'tokenExpiration', value: result['exp'].toString());
      }

      return result;
    } else {
      throw Exception('Unexpected response format from server');
    }
  }

  @override
  Future<Map<String, dynamic>> dmzLogin({
    required String uniqueId,
    required String password,
  }) async {
    var result = await api.post(
      endPoint: "api/dmz/auth/login",
      body: {
        "uniqueId": uniqueId,
        "password": password,
        "isDMZAccount": true,
      },
    );

    if (result is String) {
      print("DMZ Login error: $result");
      throw Exception("DMZ Login failed: $result");
    }

    if (result is Map<String, dynamic> && result.containsKey('token')) {
      jwtToken = result['token'];

      await _secureStorage.write(key: 'jwtToken', value: result['token']);
      await _secureStorage.write(key: 'usernamePublic', value: "DMZ");
      await _secureStorage.write(key: 'isDMZAccount', value: 'true');

      if (result.containsKey('exp')) {
        await _secureStorage.write(
            key: 'tokenExpiration', value: result['exp'].toString());
      }

      return result;
    } else {
      throw Exception('Unexpected response format from server');
    }
  }

  @override
  @override
  Future<void> registerUser({
    required int id,
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String phone,
    required String email,
    String? organizationName,
    String? organizationCountry,
    String? organizationAddress,
    String? organizationContactEmail,
    String? organizationContactPhone,
  }) async {
    // Construct the request body
    final requestBody = {
      "id": id,
      "username": username,
      "password": password,
      "email": email,
      "firstname": firstName,
      "lastname": lastName,
      "phone": phone,
      "enabled": true,
      "authorityIDs": [1], // Adjust as per requirements
      "organizationName": organizationName ?? "",
      "organizationCountry": organizationCountry ?? "",
      "organizationAddress": organizationAddress ?? "",
      "organizationContactEmail": organizationContactEmail ?? "",
      "organizationContactPhone": organizationContactPhone ?? "",
    };

    // Log the request body for debugging
    print("Register User Request Body: $requestBody");

    // Send the request to the API
    await api.post(
      endPoint: "api/auth/signup",
      body: [requestBody], // Wrap in an array to match the JSON structure
    );
  }
}

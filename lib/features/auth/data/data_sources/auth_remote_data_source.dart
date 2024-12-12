import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/utils/exp_extractor_from_jwt.dart';
import 'package:lms/features/auth/data/models/user_model.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart'; // Import the jwt_decode package

String jwtToken = '';
String usernamePublic = '';
String refreshToken = '';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  });

  Future<Map<String, dynamic>> dmzLogin({
    required String uniqueId,
    required String password,
  });

  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String phone,
    required String email,
    String? accountName,
    String? departmentName,
    String? legalEntityName,
    String? globalEntityName,
    String? website,
    String? legalContactName,
    String? legalContactEmail,
    String? legalContactNumber,
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

    if (result is Map<String, dynamic>) {
      // Check if the required fields are present in the response
      if (!result.containsKey('jwtToken') ||
          !result.containsKey('username') ||
          !result.containsKey('roles')) {
        throw Exception("Missing required fields in the response");
      }

      // Check if the user is verified
      if (result.containsKey('isVerified') && result['isVerified'] == false) {
        return result;
      }

      // Assign values only if they are not null
      jwtToken = result['jwtToken'] ?? '';
      usernamePublic = result['username'] ?? '';
      refreshToken = result['refreshToken'] ?? '';
      userRole = result['roles'] ?? '';

      if (jwtToken.isEmpty || usernamePublic.isEmpty || userRole.isEmpty) {
        throw Exception("Invalid login response, some fields are empty");
      }

      final expiration = extractExpiration(jwtToken);
      if (expiration != null) {
        await _secureStorage.write(
            key: 'tokenExpiration', value: expiration.toString());
        print("Extracted and saved token expiration: $expiration");
      } else {
        print("Failed to extract 'exp' from JWT token.");
      }

      // Clear any existing session data
      await _secureStorage.deleteAll();

      // Save the values in secure storage
      await _secureStorage.write(key: 'jwtToken', value: jwtToken);
      await _secureStorage.write(key: 'usernamePublic', value: usernamePublic);
      await _secureStorage.write(key: 'userRole', value: userRole);
      await _secureStorage.write(key: 'refreshToken', value: refreshToken);

      if (result.containsKey('organizationId')) {
        await _secureStorage.write(
            key: 'organizationId', value: result['organizationId'].toString());
      }

      // After login, refresh access token if needed
      await getAccessToken();

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
        print("Saved DMZ token expiration: ${result['exp']}");
      } else {
        print("Token expiration (exp) not found in DMZ login response.");
      }

      // After DMZ login, refresh access token if needed
      await getAccessToken();

      return result;
    } else {
      throw Exception('Unexpected response format from server');
    }
  }

  @override
  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String phone,
    required String email,
    String? accountName,
    String? departmentName,
    String? legalEntityName,
    String? globalEntityName,
    String? website,
    String? legalContactName,
    String? legalContactEmail,
    String? legalContactNumber,
  }) async {
    final requestBody = {
      "username": username,
      "password": password,
      "email": email,
      "firstname": firstName,
      "lastname": lastName,
      "phone": phone,
      "enabled": true,
      "authorityIDs": [1],
      "accountName": accountName ?? "",
      "departmentName": departmentName ?? "",
      "legalEntityName": legalEntityName ?? "",
      "globalEntityName": globalEntityName ?? "",
      "website": website ?? "",
      "legalContactName": legalContactName ?? "",
      "legalContactEmail": legalContactEmail ?? "",
      "legalContactNumber": legalContactNumber ?? "",
    };

    print("Register User Request Body: $requestBody");

    await api.post(
      endPoint: "api/auth/signup",
      body: [requestBody],
    );
  }

  Future<String> getAccessToken() async {
    const secureStorage = FlutterSecureStorage();
    String? accessToken = await secureStorage.read(key: 'jwtToken');

    if (accessToken == null || await isTokenExpired(accessToken)) {
      accessToken = await refreshAccessToken();
    }

    return accessToken!;
  }

  Future<bool> isTokenExpired(String token) async {
    try {
      final decodedToken =
          Jwt.parseJwt(token); // Correct method usage from jwt_decode
      final expiryDate =
          DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      print("Error decoding token: $e");
      return true; // Return true if decoding fails or token is expired
    }
  }

  Future<String> refreshAccessToken() async {
    const secureStorage = FlutterSecureStorage();
    String? storedRefreshToken = await secureStorage.read(key: 'refreshToken');

    if (storedRefreshToken == null) {
      throw Exception("Refresh token not found");
    }

    try {
      var response = await api.post(
        endPoint: "api/auth/refresh-token",
        body: jsonEncode({"refreshToken": storedRefreshToken}),
      );

      String newAccessToken = response["accessToken"];

      await secureStorage.write(key: 'jwtToken', value: newAccessToken);

      return newAccessToken;
    } catch (e) {
      print("Error refreshing access token: $e");
      throw Exception("Failed to refresh token");
    }
  }

  void autoRefreshToken() {
    Timer.periodic(Duration(minutes: 5), (timer) async {
      String accessToken = await getAccessToken();
      print("Auto-refreshed token: $accessToken");
    });
  }
}

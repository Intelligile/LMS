import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/models/user_model.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

String jwtToken = '';
String usernamePublic = '';

abstract class AuthRemoteDataSource {
  Future<void> loginUser({String username, String password});
  Future<void> registerUser({
    int id,
    String firstName,
    String lastName,
    String username,
    String password,
    String phone,
    String email,
  });
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final Api api;
  final BuildContext context;
  AuthRemoteDataSourceImpl(this.context, {required this.api});
  final _secureStorage = const FlutterSecureStorage();

  @override
  Future<Map<String, dynamic>> loginUser({
    String username = '',
    String password = '',
  }) async {
    var result = await api.post(
      endPoint: "api/auth/signin",
      body: {
        "username": username,
        "password": password,
      },
    );

    // Check if the result is a String, which indicates an error message
    if (result is String) {
      print("Login error: $result"); // Log the error message
      throw Exception("Login failed: $result"); // Provide a clear exception
    }

    // Continue processing if result is a valid Map with expected keys
    if (result is Map<String, dynamic> &&
        result.containsKey('roles') &&
        result.containsKey('jwtToken') &&
        result.containsKey('username')) {
      userRole = result['roles'];
      print("User role: $userRole");

      jwtToken = result['jwtToken'];
      usernamePublic = result['username'];

      // Save JWT token and other data securely
      await _secureStorage.write(key: 'jwtToken', value: result['jwtToken']);
      await _secureStorage.write(
          key: 'usernamePublic', value: result['username']);
      await _secureStorage.write(key: 'userRole', value: result['roles']);

      // Decode the JWT token to check for expiration
      try {
        Map<String, dynamic> payload = Jwt.parseJwt(jwtToken);

        // If an expiration ('exp') is found, save it as well
        if (payload.containsKey('exp')) {
          final expiration = payload['exp'];
          await _secureStorage.write(
              key: 'tokenExpiration', value: expiration.toString());
          print("Token expiration stored: $expiration");
        }
      } catch (e) {
        print("Error decoding JWT token: $e");
        throw Exception("Failed to decode JWT token.");
      }

      return result; // Return the result for further processing
    } else {
      // Handle unexpected response format
      throw Exception('Unexpected response format from server');
    }
  }

  @override
  Future<void> registerUser({
    int id = 0,
    String firstName = '',
    String lastName = '',
    String username = '',
    String password = '',
    String phone = '',
    String email = '',
  }) async {
    User user = User(
        id: id,
        firstName: firstName,
        lastName: lastName,
        username: username,
        password: password,
        phone: phone,
        email: email,
        enabled: true,
        authorityIDs: [1]);
    await api.post(
      endPoint: "api/auth/signup",
      body: [user.toMap()],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/models/user_model.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';

String jwtToken = '';
String usernamePublic = '';

abstract class AuthRemoteDataSource {
  Future<void> loginUser({String username, String password});
  Future<Map<String, dynamic>> dmzLogin(
      {required String uniqueId,
      required String password}); // Update return type
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

    if (result is String) {
      print("Login error: $result");
      throw Exception("Login failed: $result");
    }

    if (result is Map<String, dynamic> &&
        result.containsKey('roles') &&
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

    // Only check for 'token' since 'username' is not included
    if (result is Map<String, dynamic> && result.containsKey('token')) {
      jwtToken = result['token'];

      // Store the token and DMZ-related info in secure storage
      await _secureStorage.write(key: 'jwtToken', value: result['token']);
      await _secureStorage.write(
          key: 'usernamePublic',
          value: "DMZ"); // Save as "DMZ" for DMZ accounts
      await _secureStorage.write(
          key: 'isDMZAccount', value: 'true'); // Flag this as DMZ

      // Optionally store token expiration if available
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
      authorityIDs: [1],
    );
    await api.post(
      endPoint: "api/auth/signup",
      body: [user.toMap()],
    );
  }
}

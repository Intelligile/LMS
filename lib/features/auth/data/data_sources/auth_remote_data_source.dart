import 'package:flutter/material.dart';
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

  @override
  Future<void> loginUser({
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
    userRole = result['roles'];

    print(userRole);
    // Save the JWT token using SharedPreferences
    jwtToken = result['jwtToken'];
    usernamePublic = result['username'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', result['jwtToken']);

    SharedPreferences usernamePrefs = await SharedPreferences.getInstance();
    await usernamePrefs.setString('usernamePublic', result['username']);
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

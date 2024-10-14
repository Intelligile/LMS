import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/models/user_model.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

String jwtToken = '';

abstract class AuthRemoteDataSource {
  Future<void> loginUser(
      {String username, String password, required bool isLicensor});
  Future<void> registerUser(
      {int id,
      String firstName,
      String lastName,
      String username,
      String password,
      String phone,
      String email,
      required bool isLicensor});
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final Api api;

  AuthRemoteDataSourceImpl({required this.api});

  @override
  Future<void> loginUser(
      {String username = '',
      String password = '',
      required bool isLicensor}) async {
    var result = isLicensor
        ? await api.post(
            endPoint: "licensor/api/auth/signin",
            body: {
              "username": username,
              "password": password,
              "isLicensor": true,
            },
          )
        : await api.post(
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
    username = result['username'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', result['jwtToken']);

    SharedPreferences usernamePrefs = await SharedPreferences.getInstance();
    await usernamePrefs.setString('username', result['username']);
  }

  @override
  Future<void> registerUser(
      {int id = 0,
      String firstName = '',
      String lastName = '',
      String username = '',
      String password = '',
      String phone = '',
      String email = '',
      required bool isLicensor}) async {
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
    var result = !isLicensor
        ? await api.post(
            endPoint: "api/auth/signup",
            body: [user.toMap()],
          )
        : await api.post(
            endPoint: "licensor/api/auth/signup",
            body: [user.toMap()],
          );
  }
}

import 'package:lms/features/user_management/data/data_sources/user_remote_data_source.dart';
import 'package:lms/features/user_management/domain/entities/license.dart';
import 'package:lms/features/user_management/domain/repositories/user_repository.dart';

import 'package:lms/features/user_management/data/models/user_model.dart';

class UserRepositoryManagementImpl implements UserRepository {
  final UserManagementRemoteDataSource remoteDataSource;

  UserRepositoryManagementImpl({required this.remoteDataSource});

  @override
  Future<void> addUser(UserModel user) async {
    try {
      await remoteDataSource.addUsers(user.toJson() as List<UserModel>);
    } catch (error) {
      throw Exception('Error adding user: $error');
    }
  }

  @override
  Future<void> updateUser(UserModel user, String token) async {
    try {
      await remoteDataSource.updateUser(user.toJson() as UserModel, token);
    } catch (error) {
      throw Exception('Error updating user: $error');
    }
  }

  @override
  Future<void> removeUser(String username) async {
    try {
      await remoteDataSource.removeUser(username as int);
    } catch (error) {
      throw Exception('Error removing user: $error');
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final List<dynamic> userDataList = await remoteDataSource.getUsers();
      return userDataList
          .map((userData) => UserModel.fromJson(userData))
          .toList();
    } catch (error) {
      throw Exception('Error fetching users: $error');
    }
  }

  @override
  Future<UserModel> getUserProfile(String username) async {
    try {
      final userData = await remoteDataSource.getUserProfile(username);
      return UserModel.fromJson(userData as Map<String, dynamic>);
    } catch (error) {
      throw Exception('Error fetching user profile: $error');
    }
  }

  Future<UserModel> updateUserProfileImpl(UserModel user, String token) async {
    try {
      // Update the user profile through API call
      final response = await remoteDataSource.updateUserProfile(
          user.toJson(), token); // Pass the JSON directly

      // Convert the response Map<String, dynamic> to UserModel using fromJson
      return UserModel.fromJson(response);
    } catch (error) {
      throw Exception('Error updating user profile: $error');
    }
  }

  @override
  Future<String> updateUserProfile(UserModel userModel) {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }

  @override
  Future<List<License>> getUserLicenses(int userId, String token) async {
    return await remoteDataSource.getUserLicenses(userId, token);
  }
}

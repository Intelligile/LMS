import 'package:flutter/material.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';
import 'package:lms/features/user_management/data/repositories/user_repository.dart';

class AddUser with ChangeNotifier {
  final UserRepositoryManagementImpl repository;

  AddUser(this.repository);

  Future<String> call(List<UserModel> users) async {
    // Implement logic to add multiple users
    String result;
    for (var user in users) {
      result = await repository.addUser(user);
      // Handle each result as needed
    }
    return 'All users added successfully'; // or a different result message
  }
}

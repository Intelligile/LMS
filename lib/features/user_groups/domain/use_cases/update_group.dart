import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';
import 'package:lms/features/user_management/data/repositories/user_repository.dart';

class AddUser {
  final UserRepositoryManagementImpl repository;

  AddUser(this.repository);

  Future<void> call(UserModel user) {
    return repository.updateUser(user, jwtToken);
  }
}

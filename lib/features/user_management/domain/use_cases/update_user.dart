import 'package:lms/features/user_management/data/models/user_model.dart';
import 'package:lms/features/user_management/data/repositories/user_repository.dart';

class UpdateUser {
  final UserRepositoryManagementImpl repository;

  UpdateUser(this.repository);

  Future<void> call(UserModel user, String token) {
    return repository.updateUser(user, token);
  }
}

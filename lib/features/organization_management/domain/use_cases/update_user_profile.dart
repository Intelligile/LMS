import 'package:lms/features/user_management/data/models/user_model.dart';
import 'package:lms/features/user_management/data/repositories/user_repository.dart';

class UpdateUserProfile {
  final UserRepositoryManagementImpl repository;

  UpdateUserProfile(this.repository);

  Future<UserModel> call(UserModel user, String token) {
    return repository.updateUserProfileImpl(user, token);
  }
}

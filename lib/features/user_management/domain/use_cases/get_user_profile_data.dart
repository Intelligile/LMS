import 'package:lms/features/user_management/data/models/user_model.dart';
import 'package:lms/features/user_management/data/repositories/user_repository.dart';
import 'package:lms/features/user_management/domain/entities/user.dart';

class GetUserProfile {
  final UserRepositoryManagementImpl userRepository;

  GetUserProfile(this.userRepository);

  Future<UserModel> call(String username) {
    // print("USERNAME IN GET USER PROFILE DATA USECASE: $username");
    return userRepository.getUserProfile(username);
  }
}

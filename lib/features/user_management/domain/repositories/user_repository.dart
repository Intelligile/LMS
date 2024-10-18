import 'package:lms/features/user_management/data/models/user_model.dart';
import 'package:lms/features/user_management/domain/entities/license.dart';

abstract class UserRepository {
  Future<UserModel> getUserProfile(String username);
  Future<String> updateUserProfile(UserModel userModel);
  Future<List<License>> getUserLicenses(int userId, String token);
}

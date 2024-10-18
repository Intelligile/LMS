import 'package:lms/features/user_management/data/repositories/user_repository.dart';
import 'package:lms/features/user_management/domain/entities/license.dart';
import 'package:lms/features/user_management/domain/repositories/user_repository.dart';

class GetUserLicenses {
  final UserRepositoryManagementImpl repositoryManagementImpl;

  GetUserLicenses(this.repositoryManagementImpl);

  Future<List<License>> call(int userId, String token) async {
    return await repositoryManagementImpl.getUserLicenses(userId, token);
  }
}

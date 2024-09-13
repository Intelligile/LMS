import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/roles_and_premission/domain/repositories/user_repository.dart';

class UpdateUserAuthoritiesUseCase {
  final UserRepository userRepository;
  UpdateUserAuthoritiesUseCase({
    required this.userRepository,
  });

  Future<Either<Failure, Unit>> call(
      {required int userId, required List<int> authoritiesId}) async {
    return await userRepository.updateUserRoles(
        authoritiesId: authoritiesId, userId: userId);
  }
}

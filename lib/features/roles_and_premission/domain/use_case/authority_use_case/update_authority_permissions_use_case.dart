import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/roles_and_premission/domain/repositories/authority_repository.dart';

class UpdateAuthorityPermissionsUseCase {
  final AuthorityRepository authorityRepository;

  UpdateAuthorityPermissionsUseCase({required this.authorityRepository});

  Future<Either<Failure, Unit>> call(
      {required dynamic authorityId,
      required List<dynamic> newAuthorities}) async {
    return await authorityRepository.updateAuthorityPermissions(
        authorityId: authorityId, newAuthorities: newAuthorities);
  }
}

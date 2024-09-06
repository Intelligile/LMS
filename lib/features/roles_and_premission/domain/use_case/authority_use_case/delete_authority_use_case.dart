import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/roles_and_premission/domain/repositories/authority_repository.dart';

class DeleteAuthorityUseCase {
  final AuthorityRepository authorityRepository;
  DeleteAuthorityUseCase({
    required this.authorityRepository,
  });

  Future<Either<Failure, Unit>> call({
    required int authorityId,
  }) async {
    return await authorityRepository.deleteAuthority(authorityId: authorityId);
  }
}

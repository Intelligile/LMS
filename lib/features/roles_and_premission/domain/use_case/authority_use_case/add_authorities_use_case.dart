// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/roles_and_premission/data/models/authority.dart';
import 'package:lms/features/roles_and_premission/domain/repositories/authority_repository.dart';

class AddAuthoritiesUseCase {
  final AuthorityRepository authorityRepository;
  AddAuthoritiesUseCase({
    required this.authorityRepository,
  });

  Future<Either<Failure, Unit>> call(
      {required List<Authority> authorities}) async {
    return await authorityRepository.addAuthorities(authorities);
  }
}

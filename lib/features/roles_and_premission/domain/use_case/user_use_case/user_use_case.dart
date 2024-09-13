// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/roles_and_premission/data/models/user_dto.dart';
import 'package:lms/features/roles_and_premission/domain/repositories/user_repository.dart';

class FetchUsersUseCase {
  final UserRepository userRepository;
  FetchUsersUseCase({
    required this.userRepository,
  });
  

  Future<Either<Failure, List<UserDto>>> call({dynamic roleId}) async {
    return await userRepository.getUsers(roleId: roleId);
  }

}

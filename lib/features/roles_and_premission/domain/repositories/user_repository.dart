import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/roles_and_premission/data/models/user_dto.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserDto>>> getUsers({dynamic roleId});
}

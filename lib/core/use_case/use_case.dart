import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';

abstract class UseCase<Type, Parameter> {
  Future<Either<Failure, Type>> call([Parameter param]);
}

class NoParam {}

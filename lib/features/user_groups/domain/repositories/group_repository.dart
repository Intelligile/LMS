import 'package:dartz/dartz.dart';
import '../entities/group.dart';
import 'package:lms/core/errors/failure.dart';

/// Abstract class that defines the contract for managing groups.
abstract class GroupRepository {
  /// Fetches all user groups.
  ///
  /// Returns a [List] of [Group] on success, or a [Failure] on error.
  Future<Either<Failure, List<Group>>> getGroups();

  /// Creates a new group.
  ///
  /// Takes a [Group] entity as input and returns a [Failure] on error.
  Future<Either<Failure, void>> createGroup(Group group);

  /// Updates an existing group.
  ///
  /// Takes a [Group] entity as input and returns a [Failure] on error.
  Future<Either<Failure, void>> updateGroup(Group group);

  /// Deletes a group by its ID.
  ///
  /// Takes a [String] ID as input and returns a [Failure] on error.
  Future<Either<Failure, void>> deleteGroup(String groupId);
}

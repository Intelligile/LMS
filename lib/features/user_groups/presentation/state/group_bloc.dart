import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';

import 'package:lms/features/user_groups/domain/use_cases/get_groups.dart'; // Adjust according to your use case location
// Adjust according to your entity location

// Events
abstract class GroupEvent {
  @override
  List<Object> get props => [];
}

class FetchGroups extends GroupEvent {}

// States
abstract class GroupState {
  @override
  List<Object> get props => [];
}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  final List<GroupModel> groups;

  GroupLoaded(this.groups);

  @override
  List<Object> get props => [groups];
}

class GroupError extends GroupState {
  final String message;

  GroupError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GetGroups getGroups;

  GroupBloc(this.getGroups) : super(GroupInitial());

  // @override
  // Stream<GroupState> mapEventToState(GroupEvent event) async* {
  //   if (event is FetchGroups) {
  //     yield GroupLoading();
  //     final failureOrGroups = await getGroups.execute();
  //     yield failureOrGroups.fold(
  //       (failure) => GroupError(
  //           _mapFailureToMessage(failure)), // Convert failure to a message
  //       (groups) => GroupLoaded(groups),
  //     );
  //   }
  // }

  String _mapFailureToMessage(Failure failure) {
    // Convert failure to a user-friendly message
    // This is a simple example; you might want to handle different failure types
    if (failure is ServerFailure) {
      return 'Server error occurred';
    } else if (failure is CacheFailure) {
      return 'Cache error occurred';
    } else {
      return 'Unexpected error occurred';
    }
  }
}

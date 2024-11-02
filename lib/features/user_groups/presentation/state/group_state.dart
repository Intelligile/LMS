import 'package:lms/features/user_groups/data/models/group_model.dart';

// Adjust according to your entity location

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

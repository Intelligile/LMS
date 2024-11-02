/// Entity representing the assignment of a user to a group.
class UserGroup {
  final String userId;
  final String groupId;

  UserGroup({
    required this.userId,
    required this.groupId,
  });

  @override
  List<Object> get props => [userId, groupId];
}

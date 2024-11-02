import 'package:lms/features/user_groups/domain/entities/user_group_model.dart';

/// Model class for UserGroup, used in the data layer.
class UserGroupModel {
  final String userId;
  final String groupId;

  UserGroupModel({
    required this.userId,
    required this.groupId,
  });

  factory UserGroupModel.fromJson(Map<String, dynamic> json) {
    return UserGroupModel(
      userId: json['userId'],
      groupId: json['groupId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'groupId': groupId,
    };
  }

  UserGroup toEntity() {
    return UserGroup(
      userId: userId,
      groupId: groupId,
    );
  }

  @override
  List<Object> get props => [userId, groupId];
}

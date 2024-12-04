import 'package:lms/features/user_management/data/models/user_model.dart';

class GroupModel {
  final int id;
  late String name;
  late String description;
  late List<UserModel> users;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.users,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    var usersJson = json['users'] as List<dynamic>? ?? [];
    List<UserModel> users = [];

    for (var userJson in usersJson) {
      if (userJson is Map<String, dynamic>) {
        // Full user object
        users.add(UserModel.fromJson(userJson));
      } else if (userJson is int) {
        // User ID (need to handle separately if necessary)
        // For simplicity, creating a dummy user object
        users.add(UserModel(
          id: userJson,
          username: '',
          password: '',
          email: '',
          firstname: '',
          lastname: '',
          phone: '',
          authorities: [],
          groups: [], // Initialize the groups field with an empty list
        ));
      } else {
        throw Exception('Invalid user data format');
      }
    }

    return GroupModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      users: users,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'users': users.map((user) => user.toJson()).toList(),
    };
  }
}

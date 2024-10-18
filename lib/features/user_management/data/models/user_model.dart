import 'package:lms/features/roles_and_premission/data/models/authority.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';

class UserModel {
  final int id;
  late String username;
  late String password;
  late String email;
  late String firstname;
  late String lastname;
  late String phone;
  late bool enabled;
  late List<Authority> authorities;
  final List<GroupModel> groups;

  UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.phone,
    this.enabled = true,
    required this.authorities,
    required this.groups,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // print("Parsing JSON in UserModel.fromJson: $json");

    // Parsing authorities
    var authoritiesJson = json['authorities'];
    List<Authority> authorities = [];
    if (authoritiesJson is List) {
      authorities = authoritiesJson.map((authJson) {
        if (authJson is Map<String, dynamic>) {
          return Authority.fromJson(authJson);
        } else {
          throw Exception('Invalid authority data format');
        }
      }).toList();
    } else {
      print('Authorities field is not a list: $authoritiesJson');
    }

    // Parsing groups
    var groupsJson = json['groups'];
    List<GroupModel> groups = [];
    if (groupsJson is List) {
      groups = groupsJson.map((groupJson) {
        if (groupJson is Map<String, dynamic>) {
          return GroupModel.fromJson(groupJson);
        } else {
          throw Exception('Invalid group data format');
        }
      }).toList();
    } else {
      print('Groups field is not a list: $groupsJson');
    }

    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      phone: json['phone'] ?? '',
      enabled: json['enabled'] ?? true,
      authorities: authorities,
      groups: groups,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'enabled': enabled,
      'authorities':
          authorities.map((authority) => authority.toJson()).toList(),
      'groups': groups.map((group) => group.toJson()).toList(),
    };
  }
}

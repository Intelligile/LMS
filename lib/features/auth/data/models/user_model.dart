// lib/models/user.dart
class User {
  final int id;
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final bool enabled;
  final List<dynamic> authorityIDs;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    this.enabled = true,
    this.authorityIDs = const [1],
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "firstname": firstName,
      "lastname": lastName,
      "phone": phone,
      "email": email,
      "enabled": enabled,
      "authorityIDs": authorityIDs,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      phone: json['phone'],
      email: json['email'],
      enabled: json['enabled'],
      authorityIDs: List<dynamic>.from(json['authorityIDs']),
    );
  }
  // Convert a User object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'password': password,
      'phone': phone,
      'email': email,
      'enabled': true,
      "authorityIDs": [1],
    };
  }

  // Create a User object from a map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      username: map['username'],
      password: map['password'],
      phone: map['phone'],
      email: map['email'],
    );
  }
}

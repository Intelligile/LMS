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

  /// Converts the `User` object to a JSON-friendly map.
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "password": password,
      "firstname": firstName, // camelCase for compatibility with backend
      "lastname": lastName, // camelCase for compatibility with backend
      "phone": phone,
      "email": email,
      "enabled": enabled,
      "authorityIDs": authorityIDs,
    };
  }

  /// Creates a `User` object from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0, // Defaults to 0 if `id` is null
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      firstName: json['firstname'] ?? '', // Map camelCase from backend
      lastName: json['lastname'] ?? '', // Map camelCase from backend
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      enabled: json['enabled'] ?? true,
      authorityIDs: List<dynamic>.from(json['authorityIDs'] ?? []),
    );
  }

  /// Converts a `User` object to a map for storage or database operations.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'enabled': enabled,
      'authorityIDs': authorityIDs,
    };
  }

  /// Creates a `User` object from a map.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0,
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      enabled: map['enabled'] ?? true,
      authorityIDs: List<dynamic>.from(map['authorityIDs'] ?? []),
    );
  }
}

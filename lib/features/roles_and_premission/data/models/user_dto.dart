class UserDto {
  int? id;
  String? username;
  String? email;
  String? firstname;
  String? lastname;
  List<dynamic>? roles;

  UserDto({
    this.id,
    this.username,
    this.email,
    this.firstname,
    this.lastname,
    this.roles,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: json['id'] as int?,
        username: json['username'] as String?,
        email: json['email'] as String?,
        firstname: json['firstname'] as String?,
        lastname: json['lastname'] as String?,
        roles: json['roles'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'firstname': firstname,
        'lastname': lastname,
        'roles': roles,
      };
}

class User {
  final String username;
  final String email;
  final String firstname;
  final String lastname;
  final String phone;
  final bool enabled;
  final List<int> authorityIDs;

  User({
    required this.username,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.phone,
    this.enabled = true,
    required this.authorityIDs,
  });
}

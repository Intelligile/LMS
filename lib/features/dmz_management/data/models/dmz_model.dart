class DMZModel {
  final int dmzId;
  late String uniqueId;
  late String dmzOrganization;
  late String dmzCountry;
  late String password; // New password field

  DMZModel({
    required this.dmzId,
    required this.uniqueId,
    required this.dmzOrganization,
    required this.dmzCountry,
    required this.password, // Initialize password
  });

  // Factory constructor to create DMZModel from JSON
  factory DMZModel.fromJson(Map<String, dynamic> json) {
    return DMZModel(
      dmzId: json['dmzId'] ?? 0,
      uniqueId: json['uniqueId'] ?? '',
      dmzOrganization: json['dmzOrganization'] ?? '',
      dmzCountry: json['dmzCountry'] ?? '',
      password: json['password'] ?? '', // Parse password
    );
  }

  // Convert DMZModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'dmzId': dmzId,
      'uniqueId': uniqueId,
      'dmzOrganization': dmzOrganization,
      'dmzCountry': dmzCountry,
      'password': password, // Add password to JSON
    };
  }
}

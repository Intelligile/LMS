class OrganizationModel {
  final int id;
  final String name;
  final String address;
  final String contactEmail;
  final String contactPhone;
  final String country;

  OrganizationModel({
    required this.id,
    required this.name,
    required this.address,
    required this.contactEmail,
    required this.contactPhone,
    required this.country,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'country': country,
    };
  }
}

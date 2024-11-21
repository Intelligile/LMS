import 'package:lms/features/organization_management/data/models/organization_model.dart';

class BillingAccountModel {
  final int id;
  late String firstName;
  late String middleName;
  late String lastName;
  late String businessName;
  late String addressLine1;
  late String addressLine2;
  late String city;
  late String postalCode;
  late String country;
  late String businessPhoneNumber;
  late OrganizationModel? organization; // Associated organization

  BillingAccountModel({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.businessName,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.businessPhoneNumber,
    this.organization,
  });

  factory BillingAccountModel.fromJson(Map<String, dynamic> json) {
    return BillingAccountModel(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      businessName: json['businessName'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
      businessPhoneNumber: json['businessPhoneNumber'] ?? '',
      organization: json['organization'] != null
          ? OrganizationModel.fromJson(json['organization'])
          : null,
    );
  }

  Map<String, dynamic> toJson({bool excludeId = false}) {
    return {
      if (!excludeId) 'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'businessName': businessName,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'postalCode': postalCode,
      'country': country,
      'businessPhoneNumber': businessPhoneNumber,
      'organizationId': organization?.id,
    };
  }
}

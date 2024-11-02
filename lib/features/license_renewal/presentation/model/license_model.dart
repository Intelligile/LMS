class LicenseModel {
  String licenseName;
  String licenseKey;
  DateTime purchaseDate;
  DateTime expirationDate;
  String status;
  String productName;
  String userName;
  int usageLimit;
  DateTime? renewalDate;
  String licenseType;
  String licenseTerms;
  String supportLevel;
  double cost;
  double renewalCost;
  DateTime? activationDate;
  String notes;
  bool autoRenewalStatus;

  LicenseModel({
    required this.licenseName,
    required this.licenseKey,
    required this.purchaseDate,
    required this.expirationDate,
    required this.status,
    required this.productName,
    required this.userName,
    required this.usageLimit,
    this.renewalDate,
    required this.licenseType,
    required this.licenseTerms,
    required this.supportLevel,
    required this.cost,
    required this.renewalCost,
    this.activationDate,
    required this.notes,
    required this.autoRenewalStatus,
  });

  factory LicenseModel.fromJson(Map<String, dynamic> json) {
    return LicenseModel(
      licenseName: json['licenseName'],
      licenseKey: json['licenseKey'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
      expirationDate: DateTime.parse(json['expirationDate']),
      status: json['status'],
      productName: json['productName'],
      userName: json['userName'],
      usageLimit: json['usageLimit'],
      renewalDate: json['renewalDate'] != null
          ? DateTime.parse(json['renewalDate'])
          : null,
      licenseType: json['licenseType'],
      licenseTerms: json['licenseTerms'],
      supportLevel: json['supportLevel'],
      cost: json['cost'].toDouble(),
      renewalCost: json['renewalCost'].toDouble(),
      activationDate: json['activationDate'] != null
          ? DateTime.parse(json['activationDate'])
          : null,
      notes: json['notes'],
      autoRenewalStatus: json['autoRenewalStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'licenseName': licenseName,
      'licenseKey': licenseKey,
      'purchaseDate': purchaseDate.toIso8601String(),
      'expirationDate': expirationDate.toIso8601String(),
      'status': status,
      'productName': productName,
      'userName': userName,
      'usageLimit': usageLimit,
      'renewalDate': renewalDate?.toIso8601String(),
      'licenseType': licenseType,
      'licenseTerms': licenseTerms,
      'supportLevel': supportLevel,
      'cost': cost,
      'renewalCost': renewalCost,
      'activationDate': activationDate?.toIso8601String(),
      'notes': notes,
      'autoRenewalStatus': autoRenewalStatus,
    };
  }
}

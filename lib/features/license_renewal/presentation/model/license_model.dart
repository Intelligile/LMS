class FeatureModel {
  int? id;
  String? key;
  DateTime? keyExpiryDate;

  FeatureModel({
    this.id,
    this.key,
    this.keyExpiryDate,
  });

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      id: json['id'],
      key: json['key'],
      keyExpiryDate: json['keyExpiryDate'] != null
          ? DateTime.parse(json['keyExpiryDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'keyExpiryDate': keyExpiryDate?.toIso8601String(),
    };
  }
}

class LicenseModel {
  int? id;
  int? userId;
  String? deviceName;
  DateTime? endDate;
  String? serverCode;
  String? licenseKey;
  List<FeatureModel>? features;
  bool? valid;

  LicenseModel({
    this.id,
    this.userId,
    this.deviceName,
    this.endDate,
    this.serverCode,
    this.licenseKey,
    this.features,
    this.valid,
  });

  factory LicenseModel.fromJson(Map<String, dynamic> json) {
    return LicenseModel(
      id: json['id'],
      userId: json['userId'],
      deviceName: json['deviceName'],
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      serverCode: json['serverCode'],
      licenseKey: json['licenseKey'],
      features: json['features'] != null
          ? (json['features'] as List)
              .map((feature) => FeatureModel.fromJson(feature))
              .toList()
          : [],
      valid: json['valid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'deviceName': deviceName,
      'endDate': endDate?.toIso8601String(),
      'serverCode': serverCode,
      'licenseKey': licenseKey,
      'features': features?.map((feature) => feature.toJson()).toList(),
      'valid': valid,
    };
  }
}

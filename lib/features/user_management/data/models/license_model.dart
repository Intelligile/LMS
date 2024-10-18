import 'package:lms/features/user_management/domain/entities/license.dart';

class LicenseModel extends License {
  LicenseModel({
    required String deviceName,
    required String serverCode,
    required DateTime endDate,
  }) : super(
          deviceName: deviceName,
          serverCode: serverCode,
          endDate: endDate,
        );

  factory LicenseModel.fromJson(Map<String, dynamic> json) {
    return LicenseModel(
      deviceName: json['deviceName'],
      serverCode: json['serverCode'],
      endDate: DateTime.parse(json['endDate']),
    );
  }
}

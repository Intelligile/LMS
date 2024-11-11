import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/license_renewal/presentation/model/license_model.dart';

class LicenseRemoteDataSource {
  final String baseUrl;

  LicenseRemoteDataSource(Api api, {required this.baseUrl});

  Future<List<LicenseModel>> getLicensesByUserId(int userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/license/user/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => LicenseModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load licenses');
    }
  }
}

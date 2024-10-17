import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lms/features/auth_code/domain/entities/authorization_code.dart';
import 'package:lms/features/auth_code/domain/repositories/authorization_code_repository.dart';

class AuthorizationCodeRepositoryImpl implements AuthorizationCodeRepository {
  final String baseUrl = 'http://localhost:8082/licensor/api/auth-codes';

  @override
  Future<AuthorizationCode> generateAmountBasedCode(
      double amount,
      int periodMonths,
      double totalCredit,
      int licenseeId,
      int productId,
      double discount,
      int productLimit) async {
    final response = await http.post(
      Uri.parse('$baseUrl/amount-based'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
        'periodMonths': periodMonths,
        'totalCredit': totalCredit,
        'licenseeId': licenseeId,
        'productId': productId,
        'discount': discount,
        'productLimit': 0,
      }),
    );
    if (response.statusCode == 200) {
      return AuthorizationCode.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to generate amount-based code');
    }
  }

  @override
  Future<AuthorizationCode> generateProductBasedCode(
      int productLimit, int licenseeId, int productId, double discount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/product-based'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'productLimit': productLimit,
        'licenseeId': licenseeId,
        'productId': productId,
        'discount': discount,
      }),
    );
    if (response.statusCode == 200) {
      return AuthorizationCode.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to generate product-based code');
    }
  }

  @override
  Future<AuthorizationCode> generateCombinedCode(
      double amount,
      int periodMonths,
      double totalCredit,
      int productLimit,
      int licenseeId,
      int productId,
      double discount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/combined'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
        'periodMonths': periodMonths,
        'totalCredit': totalCredit,
        'productLimit': productLimit,
        'licenseeId': licenseeId,
        'productId': productId,
        'discount': discount,
      }),
    );
    if (response.statusCode == 200) {
      return AuthorizationCode.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to generate combined code');
    }
  }
}

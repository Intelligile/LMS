import 'package:flutter/material.dart';
import 'package:lms/features/auth_code/domain/repositories/authorization_code_repository.dart';

class AuthorizationCodeViewModel with ChangeNotifier {
  final AuthorizationCodeRepository repository;

  AuthorizationCodeViewModel(this.repository);

  Future<void> generateAmountBasedCode(
      double amount,
      int periodMonths,
      double totalCredit,
      int licenseeId,
      int productId,
      double discount,
      int productLimit) async {
    try {
      await repository.generateAmountBasedCode(amount, periodMonths,
          totalCredit, licenseeId, productId, discount, productLimit);
      print("SUCCESS");
      notifyListeners();
    } catch (e) {
      print("Error generating amount-based code: $e");
    }
  }

  Future<void> generateProductBasedCode(
      int productLimit, int licenseeId, int productId, double discount) async {
    try {
      await repository.generateProductBasedCode(
          productLimit, licenseeId, productId, discount);
      notifyListeners();
    } catch (e) {
      print("Error generating product-based code: $e");
    }
  }

  Future<void> generateCombinedCode(
      double amount,
      int periodMonths,
      double totalCredit,
      int productLimit,
      int licenseeId,
      int productId,
      double discount) async {
    try {
      await repository.generateCombinedCode(amount, periodMonths, totalCredit,
          productLimit, licenseeId, productId, discount);
      notifyListeners();
    } catch (e) {
      print("Error generating combined code: $e");
    }
  }
}

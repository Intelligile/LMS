import 'package:lms/features/auth_code/domain/entities/authorization_code.dart';

abstract class AuthorizationCodeRepository {
  Future<AuthorizationCode> generateAmountBasedCode(
      double amount,
      int periodMonths,
      double totalCredit,
      String licenseeId,
      String productId,
      double discount);
  Future<AuthorizationCode> generateProductBasedCode(
      int productLimit, String licenseeId, String productId, double discount);
  Future<AuthorizationCode> generateCombinedCode(
      double amount,
      int periodMonths,
      double totalCredit,
      int productLimit,
      String licenseeId,
      String productId,
      double discount);
}

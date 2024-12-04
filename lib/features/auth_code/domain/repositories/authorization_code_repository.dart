import 'package:lms/features/auth_code/domain/entities/authorization_code.dart';

abstract class AuthorizationCodeRepository {
  Future<AuthorizationCode> generateAmountBasedCode(
    double amount,
    int periodMonths,
    double totalCredit,
    int licenseeId,
    int productId,
    double discount,
    int productLimit,
  );
  Future<AuthorizationCode> generateProductBasedCode(
      int productLimit, int licenseeId, int productId, double discount);
  Future<AuthorizationCode> generateCombinedCode(
      double amount,
      int periodMonths,
      double totalCredit,
      int productLimit,
      int licenseeId,
      int productId,
      double discount);

  Future<List<AuthorizationCode>> getAllAuthorizationCodes();
  Future<AuthorizationCode?> getAuthorizationCodeByLicenseeId(int licenseeId);
}

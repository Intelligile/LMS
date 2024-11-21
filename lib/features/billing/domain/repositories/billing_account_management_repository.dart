import 'package:lms/features/billing/data/models/billing_account_model.dart';

abstract class BillingAccountRepository {
  Future<List<BillingAccountModel>> getBillingAccountsByOrganizationId(
      int organizationId);

  Future<String> addBillingAccount(BillingAccountModel account);

  Future<String> updateBillingAccount(BillingAccountModel account);

  Future<void> deleteBillingAccount(int accountId);
}

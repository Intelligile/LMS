import 'package:lms/features/billing/data/data_sources/billing_account_management_data_source.dart';
import 'package:lms/features/billing/data/models/billing_account_model.dart';
import 'package:lms/features/billing/domain/repositories/billing_account_management_repository.dart';

class BillingAccountRepositoryImpl implements BillingAccountRepository {
  final BillingAccountRemoteDataSource remoteDataSource;

  BillingAccountRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BillingAccountModel>> getBillingAccountsByOrganizationId(
      int organizationId) async {
    return await remoteDataSource
        .getBillingAccountsByOrganizationId(organizationId);
  }

  @override
  Future<String> addBillingAccount(BillingAccountModel account) async {
    return await remoteDataSource.addBillingAccount(account);
  }

  @override
  Future<String> updateBillingAccount(BillingAccountModel account) async {
    return await remoteDataSource.updateBillingAccount(account);
  }

  @override
  Future<void> deleteBillingAccount(int accountId) async {
    await remoteDataSource.deleteBillingAccount(accountId);
  }
}

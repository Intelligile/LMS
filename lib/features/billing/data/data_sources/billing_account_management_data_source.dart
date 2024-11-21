import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:lms/features/billing/data/models/billing_account_model.dart';

class BillingAccountRemoteDataSource {
  final Api api;

  BillingAccountRemoteDataSource(this.api);

  Future<List<BillingAccountModel>> getBillingAccountsByOrganizationId(
      int organizationId) async {
    try {
      var response = await api.get(
          endPoint: "api/billing-accounts/org/$organizationId",
          token: jwtTokenPublic);
      return (response as List)
          .map((json) => BillingAccountModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch billing accounts: $e');
    }
  }

  Future<String> addBillingAccount(BillingAccountModel account) async {
    try {
      await api.post(
        endPoint: "api/billing-accounts",
        body: account.toJson(excludeId: true), // Exclude 'id' for creation
        token: jwtTokenPublic,
      );
      return "Billing account added successfully";
    } catch (e) {
      throw Exception('Failed to add billing account: $e');
    }
  }

  Future<String> updateBillingAccount(BillingAccountModel account) async {
    try {
      await api.put(
          endPoint: "api/billing-accounts/${account.id}",
          body: account.toJson(),
          token: jwtToken);
      return "Billing account updated successfully";
    } catch (e) {
      throw Exception('Failed to update billing account: $e');
    }
  }

  Future<void> deleteBillingAccount(int accountId) async {
    try {
      await api.delete2(endPoint: "api/billing-accounts/$accountId", body: '');
    } catch (e) {
      throw Exception('Failed to delete billing account: $e');
    }
  }
}

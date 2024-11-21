import 'package:flutter/material.dart';
import 'package:lms/features/billing/data/models/billing_account_model.dart';
import 'package:lms/features/billing/domain/repositories/billing_account_management_repository.dart';

class AddBillingAccount with ChangeNotifier {
  final BillingAccountRepository repository;

  AddBillingAccount(this.repository);

  Future<String> call(BillingAccountModel account) async {
    return await repository.addBillingAccount(account);
  }
}

import 'package:flutter/material.dart';
import 'package:lms/features/dmz_management/data/models/dmz_model.dart';

import 'package:lms/features/dmz_management/data/repositories/dmz_repository.dart';

class AddDMZAccount with ChangeNotifier {
  final DMZRepositoryManagementImpl repository;

  AddDMZAccount(this.repository);

  Future<String> call(List<DMZModel> dmzAccounts) async {
    String result;
    for (var dmz in dmzAccounts) {
      result = await repository.addDMZAccount(dmz);
      // Notify listeners if needed or handle each result individually
    }
    return 'All DMZ accounts added successfully';
  }
}

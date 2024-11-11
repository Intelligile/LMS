import 'package:lms/features/dmz_management/data/models/dmz_model.dart';

abstract class DMZRepository {
  /// Fetches the DMZ account profile using a unique identifier.
  Future<DMZModel> getDMZAccountProfile(String uniqueId);

  /// Updates the DMZ account profile and returns a status message.
  Future<String> updateDMZAccountProfile(DMZModel dmzModel);

  /// Retrieves a list of all DMZ accounts.
  Future<List<DMZModel>> getDMZAccounts();

  /// Adds a new DMZ account and returns a status message.
  Future<String> addDMZAccount(DMZModel dmzModel);

  /// Removes a DMZ account by ID and returns a status message.
  Future<void> removeDMZAccount(int dmzId);
}

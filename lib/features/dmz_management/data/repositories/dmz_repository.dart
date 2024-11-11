import 'package:lms/features/dmz_management/data/data_sources/dmz_remote_data_source.dart';
import 'package:lms/features/dmz_management/data/models/dmz_model.dart';
import 'package:lms/features/dmz_management/domain/repositories/dmz_repository.dart';

class DMZRepositoryManagementImpl implements DMZRepository {
  final DMZManagementRemoteDataSource remoteDataSource;

  DMZRepositoryManagementImpl({required this.remoteDataSource});

  Future<String> addDMZAccount(DMZModel dmzAccount) async {
    try {
      // Call addDMZAccounts with a list containing the single DMZ account
      return await remoteDataSource
          .addDMZAccounts([dmzAccount]); // Wrap DMZ account in a list
    } catch (error) {
      throw Exception('Error adding DMZ account: $error');
    }
  }

  @override
  Future<void> updateDMZAccount(DMZModel dmzAccount, String token) async {
    try {
      await remoteDataSource.updateDMZAccount(dmzAccount, token);
    } catch (error) {
      throw Exception('Error updating DMZ account: $error');
    }
  }

  @override
  Future<void> removeDMZAccount(int dmzId) async {
    try {
      await remoteDataSource.removeDMZAccount(dmzId);
    } catch (error) {
      throw Exception('Error removing DMZ account: $error');
    }
  }

  @override
  Future<List<DMZModel>> getDMZAccounts() async {
    try {
      final List<DMZModel> dmzAccounts =
          await remoteDataSource.getDMZAccounts();
      return dmzAccounts;
    } catch (error) {
      throw Exception('Error fetching DMZ accounts: $error');
    }
  }

  @override
  Future<DMZModel> getDMZAccountProfile(String uniqueId) async {
    try {
      final dmzData = await remoteDataSource.getDMZAccountProfile(uniqueId);
      return DMZModel.fromJson(dmzData);
    } catch (error) {
      throw Exception('Error fetching DMZ account profile: $error');
    }
  }

  Future<DMZModel> updateDMZAccountProfileImpl(
      DMZModel dmzAccount, String token) async {
    try {
      final response = await remoteDataSource.updateDMZAccountProfile(
          dmzAccount.toJson(), token); // Pass the JSON directly

      return DMZModel.fromJson(response);
    } catch (error) {
      throw Exception('Error updating DMZ account profile: $error');
    }
  }

  @override
  Future<String> updateDMZAccountProfile(DMZModel dmzModel) {
    // TODO: implement updateDMZAccountProfile
    throw UnimplementedError();
  }
}

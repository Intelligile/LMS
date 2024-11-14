import 'dart:convert';
import 'package:lms/core/utils/api.dart';
import '../models/dmz_model.dart';

class DMZManagementRemoteDataSource {
  final Api api;

  DMZManagementRemoteDataSource(this.api);

  Future<String> addDMZAccounts(List<DMZModel> dmzAccounts) async {
    List<Map<String, dynamic>> dmzDataList = dmzAccounts.map((dmz) {
      return {
        "uniqueId": dmz.uniqueId,
        "dmzOrganization": dmz.dmzOrganization,
        "dmzCountry": dmz.dmzCountry,
        "password": dmz.password,
      };
    }).toList();

    print("JSON Request Body: ${jsonEncode(dmzDataList)}");

    try {
      await api.post(
        endPoint: "api/dmz/create",
        body: dmzDataList,
      );
      return "DMZ accounts added successfully";
    } catch (e) {
      print("Failed to add DMZ accounts: $e");
      return "Failed to add DMZ accounts: $e";
    }
  }

  Future<String> updateDMZAccount(DMZModel dmz, String token) async {
    try {
      await api.put(
        endPoint: "api/dmz/update/${dmz.dmzId}",
        body: {
          "uniqueId": dmz.uniqueId,
          "dmzOrganization": dmz.dmzOrganization,
          "dmzCountry": dmz.dmzCountry,
          "password": dmz.password
        },
        token: token,
      );
      return "DMZ account updated successfully";
    } catch (e) {
      print("Failed to update DMZ account: $e");
      return "Failed to update DMZ account: $e";
    }
  }

  Future<String> removeDMZAccount(int dmzId) async {
    try {
      await api.delete2(endPoint: "api/dmz/delete/$dmzId", body: '');
      return "DMZ account removed successfully";
    } catch (e) {
      print("Failed to remove DMZ account: $e");
      return "Failed to remove DMZ account: $e";
    }
  }

  Future<List<DMZModel>> getDMZAccounts() async {
    try {
      var response = await api.get(endPoint: "api/dmz/accounts");

      print("Response: $response");

      List<DMZModel?> dmzAccounts = response.map<DMZModel?>((item) {
        if (item is Map<String, dynamic>) {
          try {
            return DMZModel.fromJson(item);
          } catch (e) {
            print('Failed to parse DMZ account data: $e');
            return null; // Return null if parsing fails
          }
        } else {
          print('Invalid DMZ account data format: $item');
          return null;
        }
      }).toList();

      // Filter out null values safely
      return dmzAccounts.whereType<DMZModel>().toList();
    } catch (e) {
      print("Failed to get DMZ accounts: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> getDMZAccountProfile(String uniqueId) async {
    try {
      var response = await api.get(endPoint: "api/dmz/account/$uniqueId");
      return response;
    } catch (e) {
      print("Failed to get DMZ account profile: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateDMZAccountProfile(
      Map<String, dynamic> dmzJson, String token) async {
    try {
      var response = await api.put(
        endPoint: "api/dmz/update/${dmzJson['dmzId']}",
        body: dmzJson,
        token: token,
      );

      return response;
    } catch (e) {
      print("Failed to update DMZ account profile: $e");
      throw "Failed to update DMZ account profile: $e";
    }
  }
}

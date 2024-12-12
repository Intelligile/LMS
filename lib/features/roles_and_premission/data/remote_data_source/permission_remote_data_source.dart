// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:lms/features/roles_and_premission/data/models/permission.dart';

abstract class PermissionRemoteDataSource {
  Future<List<Permission>> getPermissions({String? roleName});
  Future<void> addPermissions(List<Permission> authorities);
}

class PermissionRemoteDataSourceImpl extends PermissionRemoteDataSource {
  final Api api;
  PermissionRemoteDataSourceImpl({
    required this.api,
  });

  @override
  Future<void> addPermissions(List<Permission> permissions) async {
    List<Map<String, dynamic>> body =
        permissions.map((permission) => permission.toJson()).toList();
    await api.post(
        endPoint: 'api/permissions', body: body, token: jwtTokenPublic);
  }

  @override
  Future<List<Permission>> getPermissions({String? roleName}) async {
    List<Permission> permissions = [];
    print("JWT Token: $jwtToken");
    print("IN GET PERMISSIONS METHOD");

    try {
      if (roleName == null) {
        // Fetch all permissions directly if roleName is null
        var result =
            await api.get(endPoint: 'api/permissions', token: jwtTokenPublic);
        // print("Fetched all permissions: $result");

        if (result is List) {
          for (var permissionData in result) {
            try {
              permissions.add(Permission.fromJson(permissionData));
            } catch (e) {
              print("Error parsing permission: $permissionData, Error: $e");
            }
          }
        } else {
          print("Invalid response format for all permissions: $result");
        }
      } else {
        // Extract the first role name if multiple are provided
        roleName = roleName.split(',').first.trim();
        print("ROLE NAME: $roleName");

        // Fetch permissions for the specific role
        var result = await api.get(
          endPoint: 'api/permissions/by-role/$roleName',
          token: jwtTokenPublic,
        );
        // print("Fetched permissions for role $roleName: $result");

        if (result is List) {
          for (var permissionData in result) {
            try {
              permissions.add(Permission.fromJson(permissionData));
            } catch (e) {
              print("Error parsing permission: $permissionData, Error: $e");
            }
          }
        } else {
          print("Invalid response format for role $roleName: $result");
        }
      }

      // Debugging the final permissions list
      // print(
      //     "DEBUG: Final Permissions List: ${permissions.map((perm) => perm.permission).toList()}");
    } catch (e) {
      print("Error in getPermissions: $e");
    }

    return permissions;
  }
}

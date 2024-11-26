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
    print(jwtToken);
    var result;
    // if (roleName != null) {
    result = await api.get(endPoint: 'api/permissions', token: jwtTokenPublic);
    // } else {
    //   result = await api.get(
    //       endPoint: 'api/permissions/by-role/$roleName', token: jwtTokenPublic);
    // }
    for (var permissionData in result) {
      permissions.add(Permission.fromJson(permissionData));
    }
    return permissions;
  }
}

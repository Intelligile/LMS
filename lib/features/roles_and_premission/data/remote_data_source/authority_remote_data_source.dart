// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/roles_and_premission/data/models/authority.dart';

abstract class AuthorityRemoteDataSource {
  Future<List<Authority>> getAuthorities({int? authorityId = 0});
  Future<void> addAuthorities(List<Authority> authorities);
  Future<void> updateAuthorityPermissions(
      {required dynamic authorityId, required List<dynamic> newAuthorities});
}

class AuthorityRemoteDataSourceImpl extends AuthorityRemoteDataSource {
  final Api api;
  AuthorityRemoteDataSourceImpl({
    required this.api,
  });
  @override
  Future<void> addAuthorities(List<Authority> authorities) async {
    List<Map<String, dynamic>> body =
        authorities.map((authority) => authority.toJson()).toList();
    await api.post(endPoint: 'api/authorities', body: body, token: jwtToken);
  }

  @override
  Future<List<Authority>> getAuthorities({int? authorityId = 0}) async {
    List<Authority> authorities = [];
    print(jwtToken);
    var result;
    if (authorityId == 0 || authorityId == null) {
      result = await api.get(endPoint: 'api/authorities', token: jwtToken);
    } else {
      {
        result = await api.get(
            endPoint: 'api/authorities/$authorityId', token: jwtToken);
      }
    }
    for (var authorityData in result) {
      authorities.add(Authority.fromJson(authorityData));
    }
    return authorities;
  }

  @override
  Future<void> updateAuthorityPermissions(
      {required authorityId, required List newAuthorities}) async {
    await api.put(
        endPoint: 'api/authorities/$authorityId/permissions',
        body: newAuthorities,
        token: jwtToken);
  }
}

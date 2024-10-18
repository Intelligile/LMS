// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/roles_and_premission/data/models/user_dto.dart';

abstract class UserRemoteDataSource {
  Future<List<UserDto>> getUsers({dynamic roleId});
}

class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  final Api api;
  UserRemoteDataSourceImpl({
    required this.api,
  });
  @override
  Future<List<UserDto>> getUsers({dynamic roleId}) async {
    List<UserDto> users = [];
    var result;
    if (roleId == null) {
      result = await api.get(endPoint: 'api/users/with-roles', token: jwtToken);
    } else {
      result = await api.get(
          endPoint: 'api/authorities/$roleId/users', token: jwtToken);
    }
    for (var userData in result) {
      users.add(UserDto.fromJson(userData));
    }
    return users;
  }
}

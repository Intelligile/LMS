import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/roles_and_premission/data/remote_data_source/authority_remote_data_source.dart';
import 'package:lms/features/roles_and_premission/data/remote_data_source/permission_remote_data_source.dart';
import 'package:lms/features/roles_and_premission/data/remote_data_source/user_remote_data_source.dart';
import 'package:lms/features/roles_and_premission/data/repositories/authority_repository_impl.dart';
import 'package:lms/features/roles_and_premission/data/repositories/permission_repository_impl.dart';
import 'package:lms/features/roles_and_premission/data/repositories/user_repository_impl.dart';

final locator = GetIt.instance;

void setUpServiceLocator() {
  locator.registerSingleton<Api>(
    Api(
      Dio(),
    ),
  );
  locator.registerSingleton<AuthorityRepositoryImpl>(
    AuthorityRepositoryImpl(
      authorityRemoteDataSource: AuthorityRemoteDataSourceImpl(
        api: locator.get<Api>(),
      ),
    ),
  );

  locator.registerSingleton<PermissionRepositoryImpl>(
    PermissionRepositoryImpl(
      permissionRemoteDataSource: PermissionRemoteDataSourceImpl(
        api: locator.get<Api>(),
      ),
    ),
  );

  locator.registerSingleton<UserRepositoryImpl>(
    UserRepositoryImpl(
      userRemoteDataSource: UserRemoteDataSourceImpl(
        api: locator.get<Api>(),
      ),
    ),
  );
}

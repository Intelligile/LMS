import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/product_region_management/data/data_source/products_remote_data_source.dart';
import 'package:lms/features/product_region_management/data/data_source/region_remote_data_source.dart';
import 'package:lms/features/product_region_management/data/repository/product_repository_impl.dart';
import 'package:lms/features/product_region_management/data/repository/region_repository_impl.dart';
import 'package:lms/features/roles_and_premission/data/remote_data_source/authority_remote_data_source.dart';
import 'package:lms/features/roles_and_premission/data/remote_data_source/permission_remote_data_source.dart';
import 'package:lms/features/roles_and_premission/data/repositories/authority_repository_impl.dart';
import 'package:lms/features/roles_and_premission/data/repositories/permission_repository_impl.dart';

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
  locator.registerSingleton<ProductRepositoryImpl>(
    ProductRepositoryImpl(
      productsRemoteDataSource: ProductsRemoteDataSourceImpl(
        api: locator.get<Api>(),
      ),
    ),
  );
  locator.registerSingleton<RegionRepositoryImpl>(RegionRepositoryImpl(
    regionRemoteDataSource: RegionRemoteDataSourceImpl(
      api: locator.get<Api>(),
    ),
  ));
}

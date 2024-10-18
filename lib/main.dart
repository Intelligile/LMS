// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lms/core/functions/set_up_service_locator.dart';
// import 'package:lms/core/simple_bloc_observer.dart';
// import 'package:lms/core/utils/api.dart';
// import 'package:lms/core/utils/app_router.dart';
// import 'package:lms/features/product_management/data/repository/product_repository_impl.dart';
// import 'package:lms/features/product_management/presentation/manager/cubit/product_cubit.dart';
// import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/add_product_use_case.dart';
// import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/delete_product_use_case.dart';
// import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/get_all_products_use_case.dart';
// import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/get_product_use_case.dart';
// import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/get_region_products_use_case.dart';
// import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/update_product_use_case.dart';
// import 'package:lms/features/purchase_product/application/providers/cart_provider.dart';
// import 'package:lms/features/roles_and_premission/data/remote_data_source/user_remote_data_source.dart';
// import 'package:lms/features/roles_and_premission/data/repositories/authority_repository_impl.dart';
// import 'package:lms/features/roles_and_premission/data/repositories/permission_repository_impl.dart';
// import 'package:lms/features/roles_and_premission/data/repositories/user_repository_impl.dart';
// import 'package:lms/features/roles_and_premission/domain/use_case/authority_use_case/add_authorities_use_case.dart';
// import 'package:lms/features/roles_and_premission/domain/use_case/authority_use_case/get_authorities_use_case.dart';
// import 'package:lms/features/roles_and_premission/domain/use_case/authority_use_case/update_authority_permissions_use_case.dart';
// import 'package:lms/features/roles_and_premission/domain/use_case/permission_use_case/add_permission_use_case.dart';
// import 'package:lms/features/roles_and_premission/domain/use_case/permission_use_case/get_permission_use_case.dart';
// import 'package:lms/features/roles_and_premission/domain/use_case/user_use_case.dart';
// import 'package:lms/features/roles_and_premission/presentation/manager/authoriy_cubit/authority_cubit.dart';
// import 'package:lms/features/roles_and_premission/presentation/manager/permission_cubit/permission_cubit.dart';
// import 'package:lms/features/roles_and_premission/presentation/manager/user_cubit/user_dto_cubit.dart';
// import 'package:lms/features/user_groups/data/data_sources/user_group_service.dart';
// import 'package:lms/features/user_groups/data/repositories/group_repository.dart';
// import 'package:lms/features/user_groups/domain/use_cases/get_groups.dart';
// import 'package:lms/features/user_groups/presentation/state/group_bloc.dart';
// import 'package:provider/provider.dart';

// void main() {
//   setUpServiceLocator();
//   Bloc.observer = SimpleBlocObserver();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<AuthorityCubit>(
//           create: (context) => AuthorityCubit(
//               AddAuthoritiesUseCase(
//                 authorityRepository: locator.get<AuthorityRepositoryImpl>(),
//               ),
//               GetAuthoritiesUseCase(
//                 authorityRepository: locator.get<AuthorityRepositoryImpl>(),
//               ),
//               UpdateAuthorityPermissionsUseCase(
//                   authorityRepository: locator.get<AuthorityRepositoryImpl>())),
//         ),
//         BlocProvider<PermissionCubit>(
//           create: (context) => PermissionCubit(
//             AddPermissionUseCase(
//                 permissionRepository: locator.get<PermissionRepositoryImpl>()),
//             GetPermissionUseCase(
//                 permissionRepository: locator.get<PermissionRepositoryImpl>()),
//           ),
//         ),
//         BlocProvider<UserDtoCubit>(
//           create: (context) => UserDtoCubit(
//             FetchUsersUseCase(
//               userRepository: UserRepositoryImpl(
//                 userRemoteDataSource: UserRemoteDataSourceImpl(
//                   api: Api(
//                     Dio(),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         BlocProvider<ProductCubit>(
//           create: (context) => ProductCubit(
//             DeleteRegionProductUseCase(
//               productRepository: locator.get<ProductRepositoryImpl>(),
//             ),
//             GetAllRegionProductsUseCase(
//               productRepository: locator.get<ProductRepositoryImpl>(),
//             ),
//             GetRegionProductUseCase(
//               productRepository: locator.get<ProductRepositoryImpl>(),
//             ),
//             GetRegionProductsUseCase(
//               productRepository: locator.get<ProductRepositoryImpl>(),
//             ),
//             AddProductUseCase(
//               productRepository: locator.get<ProductRepositoryImpl>(),
//             ),
//             UpdateProductUseCase(
//               productRepository: locator.get<ProductRepositoryImpl>(),
//             ),
//           ),
//         ),
//         // Add GroupBloc provider
//         BlocProvider<GroupBloc>(
//           create: (context) => GroupBloc(
//             GetGroups(
//               groupRepository: GroupRepository(
//                 apiService: ApiService(
//                   api: Api(
//                     Dio(),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//       child: MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (context) => CartProvider()),
//         ],
//         child: MaterialApp.router(
//           routerConfig: AppRouter.router,
//           debugShowCheckedModeBanner: false,
//           theme: ThemeData.light().copyWith(
//             iconTheme: const IconThemeData(color: Colors.black),
//             hintColor: Colors.black,
//             colorScheme: const ColorScheme.light(),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/set_up_service_locator.dart';
import 'package:lms/core/simple_bloc_observer.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/auth/presentation/manager/user_state.dart';
import 'package:lms/features/auth_code/data/repositories/authorization_code_repository_impl.dart';
import 'package:lms/features/auth_code/domain/repositories/authorization_code_repository.dart';
import 'package:lms/features/auth_code/presentation/view_model/authorization_code_view_model.dart';
import 'package:lms/features/product_region_management/data/repository/product_repository_impl.dart';
import 'package:lms/features/product_region_management/data/repository/region_repository_impl.dart';
import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/add_product_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/delete_product_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/get_all_products_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/get_product_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/get_region_products_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/product_use_cases/update_product_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/region_use_cases/add_region_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/region_use_cases/delete_region_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/region_use_cases/get_all_regions_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/region_use_cases/get_region_use_case.dart';
import 'package:lms/features/product_region_management/domain/use_case/region_use_cases/update_region_use_case.dart';
import 'package:lms/features/product_region_management/presentation/manager/product_cubit/product_cubit.dart';
import 'package:lms/features/product_region_management/presentation/manager/region_cubit/region_cubit.dart';
import 'package:lms/features/purchase_product/application/providers/cart_provider.dart';
import 'package:lms/features/roles_and_premission/data/remote_data_source/user_remote_data_source.dart';
import 'package:lms/features/roles_and_premission/data/repositories/authority_repository_impl.dart';
import 'package:lms/features/roles_and_premission/data/repositories/permission_repository_impl.dart';
import 'package:lms/features/roles_and_premission/data/repositories/user_repository_impl.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/authority_use_case/add_authorities_use_case.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/authority_use_case/get_authorities_use_case.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/authority_use_case/update_authority_permissions_use_case.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/permission_use_case/add_permission_use_case.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/permission_use_case/get_permission_use_case.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/user_use_case.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/authoriy_cubit/authority_cubit.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/permission_cubit/permission_cubit.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/user_cubit/user_dto_cubit.dart';
import 'package:lms/features/user_groups/data/data_sources/user_group_service.dart';
import 'package:lms/features/user_groups/data/repositories/group_repository.dart';
import 'package:lms/features/user_groups/domain/use_cases/get_groups.dart';
import 'package:lms/features/user_groups/presentation/state/group_bloc.dart';
import 'package:lms/features/user_management/data/data_sources/user_remote_data_source.dart';
import 'package:provider/provider.dart';

import 'features/user_management/data/repositories/user_repository.dart';

void main() {
  setUpServiceLocator();
  Bloc.observer = SimpleBlocObserver();
  final UserManagementRemoteDataSource userRemoteDataSourceImpl;
  final userRepository = UserRepositoryManagementImpl(
      remoteDataSource: UserManagementRemoteDataSource(
          Api(Dio()))); // Provide actual initialization
  final apiService =
      ApiService(api: Api(Dio())); // Provide actual initialization

  // Create the AppRouter instance
  final appRouter =
      AppRouter(userRepository: userRepository, apiService: apiService);

  // Create the GoRouter instance using the method
  final router = appRouter.createRouter();

  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthorityCubit>(
          create: (context) => AuthorityCubit(
              AddAuthoritiesUseCase(
                authorityRepository: locator.get<AuthorityRepositoryImpl>(),
              ),
              GetAuthoritiesUseCase(
                authorityRepository: locator.get<AuthorityRepositoryImpl>(),
              ),
              UpdateAuthorityPermissionsUseCase(
                  authorityRepository: locator.get<AuthorityRepositoryImpl>())),
        ),
        BlocProvider<PermissionCubit>(
          create: (context) => PermissionCubit(
            AddPermissionUseCase(
                permissionRepository: locator.get<PermissionRepositoryImpl>()),
            GetPermissionUseCase(
                permissionRepository: locator.get<PermissionRepositoryImpl>()),
          ),
        ),
        BlocProvider<UserDtoCubit>(
          create: (context) => UserDtoCubit(
            FetchUsersUseCase(
              userRepository: UserRepositoryImpl(
                userRemoteDataSource: UserRemoteDataSourceImpl(
                  api: Api(
                    Dio(),
                  ),
                ),
              ),
            ),
          ),
        ),
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit(
            DeleteRegionProductUseCase(
              productRepository: locator.get<ProductRepositoryImpl>(),
            ),
            GetAllRegionProductsUseCase(
              productRepository: locator.get<ProductRepositoryImpl>(),
            ),
            GetRegionProductUseCase(
              productRepository: locator.get<ProductRepositoryImpl>(),
            ),
            GetRegionProductsUseCase(
              productRepository: locator.get<ProductRepositoryImpl>(),
            ),
            AddProductUseCase(
              productRepository: locator.get<ProductRepositoryImpl>(),
            ),
            UpdateProductUseCase(
              productRepository: locator.get<ProductRepositoryImpl>(),
            ),
          ),
        ),
        BlocProvider<RegionCubit>(
          create: (context) => RegionCubit(
            AddRegionUseCase(
                regionRepository: locator.get<RegionRepositoryImpl>()),
            DeleteRegionUseCase(
                regionRepository: locator.get<RegionRepositoryImpl>()),
            GetAllRegionsUseCase(
                regionRepository: locator.get<RegionRepositoryImpl>()),
            GetRegionUseCase(
                regionRepository: locator.get<RegionRepositoryImpl>()),
            UpdateRegionUseCase(
                regionRepository: locator.get<RegionRepositoryImpl>()),
          ),
        ),
        // Add GroupBloc provider
        BlocProvider<GroupBloc>(
          create: (context) => GroupBloc(
            GetGroups(
              groupRepository: GroupRepository(
                apiService: ApiService(
                  api: Api(
                    Dio(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CartProvider()),
          ChangeNotifierProvider(
            create: (context) => UserState(),
          ),
          // Provide the repository
          Provider<AuthorizationCodeRepository>(
            create: (_) =>
                AuthorizationCodeRepositoryImpl(), // Replace with your repository implementation
          ),
          // Provide the view model and pass the repository
          ChangeNotifierProvider<AuthorizationCodeViewModel>(
            create: (context) => AuthorizationCodeViewModel(
              Provider.of<AuthorizationCodeRepository>(context, listen: false),
            ),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: true,
          theme: ThemeData.light().copyWith(
            iconTheme: const IconThemeData(color: Colors.black),
            hintColor: Colors.black,
            colorScheme: const ColorScheme.light(),
          ),
        ),
      ),
    );
  }
}

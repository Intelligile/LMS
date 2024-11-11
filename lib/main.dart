import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/set_up_service_locator.dart';
import 'package:lms/core/simple_bloc_observer.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/theme.dart';
import 'package:lms/core/utils/theme_provider.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:lms/features/auth_code/data/repositories/authorization_code_repository_impl.dart';
import 'package:lms/features/auth_code/domain/repositories/authorization_code_repository.dart';
import 'package:lms/features/auth_code/presentation/view_model/authorization_code_view_model.dart';
import 'package:lms/features/home/presentation/views/widgets/drawer_state.dart';
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
import 'package:lms/features/user_management/domain/use_cases/add_user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/user_management/data/repositories/user_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setUpServiceLocator();
  Bloc.observer = SimpleBlocObserver();
  const secureStorage = FlutterSecureStorage();

  // Retrieve the token and related information
  final storedToken = await secureStorage.read(key: 'jwtToken');
  final storedUsername = await secureStorage.read(key: 'usernamePublic');
  final storedRoles = await secureStorage.read(key: 'userRole');
  final tokenExpiration = await secureStorage.read(key: 'tokenExpiration');
  print("TOKEN EXPIRATION $tokenExpiration");
  // Check token expiration
  bool isTokenValid = false;
  if (storedToken != null && tokenExpiration != null) {
    final expirationDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(tokenExpiration) * 1000);
    isTokenValid = DateTime.now().isBefore(expirationDate);
  }
  usernamePublic = storedUsername ?? '';
  userRole = storedRoles ?? '';
  // Define the initial path based on token validity
  final initialPath = isTokenValid ? '/homeView' : '/';

  // Initialize dependencies
  final userRepository = UserRepositoryManagementImpl(
    remoteDataSource: UserManagementRemoteDataSource(Api(Dio())),
  );

  final apiService = ApiService(api: Api(Dio()));
  final appRouter =
      AppRouter(userRepository: userRepository, apiService: apiService);

  // Create the router
  final router = appRouter.createRouter(initialPath: initialPath);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ExpansionTileDrawerProvider()),
        ChangeNotifierProvider(create: (_) => OpenedAndClosedDrawerProvider()),
      ],
      child: MyApp(
        router: router,
        initialUsername: storedUsername, // Pass username to the app
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router, String? initialUsername});

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

          // Provide the UserRepository and AddUser
          Provider<UserRepositoryManagementImpl>(
            create: (_) => UserRepositoryManagementImpl(
                remoteDataSource: UserManagementRemoteDataSource(Api(Dio()))),
          ),
          ChangeNotifierProvider<AddUser>(
            create: (context) => AddUser(
              Provider.of<UserRepositoryManagementImpl>(context, listen: false),
            ),
          ),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp.router(
              routerConfig: router,
              debugShowCheckedModeBanner: true,
              theme: getLightTheme(),
              darkTheme: getDarkTheme(),
              themeMode: themeProvider.themeMode,
            );
          },
        ),
      ),
    );
  }
}

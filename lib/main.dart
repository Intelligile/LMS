import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/functions/set_up_service_locator.dart';
import 'package:lms/core/simple_bloc_observer.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/purchase_product/application/providers/cart_provider.dart';
import 'package:lms/features/roles_and_premission/data/repositories/authority_repository_impl.dart';
import 'package:lms/features/roles_and_premission/data/repositories/permission_repository_impl.dart';
import 'package:lms/features/roles_and_premission/data/repositories/user_repository_impl.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/authority_use_case/add_authorities_use_case.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/authority_use_case/delete_authority_use_case.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/authority_use_case/get_authorities_use_case.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/authority_use_case/update_authority_permissions_use_case.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/permission_use_case/add_permission_use_case.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/permission_use_case/get_permission_use_case.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/user_use_case/update_user_authorities_use_case.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/user_use_case/user_use_case.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/authoriy_cubit/authority_cubit.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/permission_cubit/permission_cubit.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/user_cubit/user_dto_cubit.dart';
import 'package:lms/features/user_groups/data/data_sources/user_group_service.dart';
import 'package:lms/features/user_groups/data/repositories/group_repository.dart';
import 'package:lms/features/user_groups/domain/use_cases/get_groups.dart';
import 'package:lms/features/user_groups/presentation/state/group_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  setUpServiceLocator();
  Bloc.observer = SimpleBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
                authorityRepository: locator.get<AuthorityRepositoryImpl>(),
              ),
              DeleteAuthorityUseCase(
                authorityRepository: locator.get<AuthorityRepositoryImpl>(),
              )),
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
                userRepository: locator.get<UserRepositoryImpl>()),
            UpdateUserAuthoritiesUseCase(
              userRepository: locator.get<UserRepositoryImpl>(),
            ),
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
        ],
        child: MaterialApp.router(
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
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

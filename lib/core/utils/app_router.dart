import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/features/auth/presentation/views/forgot_password_page.dart';
import 'package:lms/features/auth/presentation/views/register_screen.dart';
import 'package:lms/features/auth/presentation/views/signin_screen.dart';
import 'package:lms/features/auth/presentation/views/widgets/reset_password_form.dart';
import 'package:lms/features/home/presentation/views/home_view.dart';
import 'package:lms/features/license_renewal/presentation/views/license_renewal.dart';
import 'package:lms/features/payment/presentation/views/payment_view.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';
import 'package:lms/features/product_region_management/data/models/region_model.dart';
import 'package:lms/features/product_region_management/presentation/views/add_new_region_view.dart';
import 'package:lms/features/product_region_management/presentation/views/home_view.dart';
import 'package:lms/features/product_region_management/presentation/views/manage_product_view.dart';
import 'package:lms/features/product_region_management/presentation/views/region_management_view.dart';
import 'package:lms/features/purchase_product/data/repository/product_repository.dart';
import 'package:lms/features/purchase_product/presentation/pages/product_list_page.dart';
import 'package:lms/features/roles_and_premission/data/models/authority.dart';
import 'package:lms/features/roles_and_premission/presentation/views/add_new_role_view.dart';
import 'package:lms/features/roles_and_premission/presentation/views/manage_roles_view.dart';
import 'package:lms/features/roles_and_premission/presentation/views/roles_and_permission_dashboard_view.dart';
import 'package:lms/features/roles_and_premission/presentation/views/update_roles_view.dart';
import 'package:lms/features/roles_and_premission/presentation/views/users_view.dart';
import 'package:lms/features/user_groups/data/data_sources/user_group_service.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';
import 'package:lms/features/user_groups/presentation/pages/group_list_page.dart';
import 'package:lms/features/user_groups/presentation/widgets/group_edit_page.dart';
import 'package:lms/features/user_groups/presentation/widgets/group_form.dart';
import 'package:lms/features/user_management/data/repositories/user_repository.dart';
import 'package:lms/features/user_management/domain/use_cases/get_user_licenses.dart';
import 'package:lms/features/user_management/domain/use_cases/get_user_profile_data.dart';
import 'package:lms/features/user_management/domain/use_cases/update_user_profile.dart';
import 'package:lms/features/user_management/presentation/pages/user_management_page.dart';
import 'package:lms/features/user_management/presentation/pages/user_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  static const kManageProductView = '/manageProductView';

  static const kProductManagement = '/productManagementView';
  static const kRegionManagement = '/regionManagementView';
  static const kAddRegionView = '/addRegionView';

  final UserRepositoryManagementImpl userRepository;
  final ApiService apiService;

  AppRouter({
    required this.userRepository,
    required this.apiService,
  });

  GoRouter createRouter() {
    return GoRouter(
      initialLocation: kSignIn,
      errorPageBuilder: (context, state) => MaterialPage(child: Container()),
      routes: [
        GoRoute(
          path: kRegister,
          builder: (context, state) => const RegisterScreen(),
        ),
        // GoRoute(
        //   path: kRegionManagement,
        //   builder: (context, state) => const RegisterScreen(),
        // ),
        GoRoute(
          path: kSignIn,
          builder: (context, state) => const SignIn(),
        ),
        GoRoute(
          path: kAddRegionView,
          builder: (context, state) => const AddNewRegionView(),
        ),
        GoRoute(
          path: kRolesAndPermissionView,
          builder: (context, state) => const RolesAndPermissionDashboardView(),
        ),
        GoRoute(
          path: kAddNewRoleView,
          builder: (context, state) => const AddNewRoleView(),
        ),
        GoRoute(
          path: kProductManagement,
          builder: (context, state) => ProductManagementView(),
        ),
        GoRoute(
          path: kUpdateRoleView,
          builder: (context, state) => const UpdateRolesView(),
        ),
        GoRoute(
          path: kManageRolesView,
          builder: (context, state) => ManageRolesView(),
        ),
        GoRoute(
          path: kHomeView,
          builder: (context, state) {
            return FutureBuilder<String?>(
              future: _getUsernameFromSharedPrefs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading while fetching username
                }
                final username = snapshot.data ??
                    'Guest'; // Default to 'Guest' if no username found
                return HomeView(username: username);
              },
            );
          },
        ),
        GoRoute(
          path: kForgot,
          builder: (context, state) => ForgotPasswordPage(),
        ),
        GoRoute(
          path: kResetPassword,
          builder: (context, state) => ResetPasswordForm(),
        ),
        GoRoute(
          path: kUserManagement,
          builder: (context, state) => UserManagementPage(),
        ),
        GoRoute(
          path: kTeamManagement,
          builder: (context, state) => GroupListPage(),
        ),
        GoRoute(
          path: kAddGroup,
          builder: (context, state) => GroupForm(api: apiService),
        ),
        GoRoute(
          path: kGroupList,
          builder: (context, state) => GroupListPage(),
        ),
        GoRoute(
          path: '${AppRouter.kUserProfile}/:username',
          builder: (context, state) {
            final userProfileUseCase = GetUserProfile(userRepository);
            final updateUserProfileUseCase = UpdateUserProfile(userRepository);
            final updateUserLicenses = GetUserLicenses(userRepository);
            final username = state.pathParameters['username'] ?? 'Guest';
            print("USERNAME IN APP ROUTER=>$username");

            return UserProfilePage(
              getUserProfile: userProfileUseCase,
              updateUserProfile: updateUserProfileUseCase,
              username: username,
              getUserLicenses: updateUserLicenses,
            );
          },
        ),
        GoRoute(
          path: kGroupDetails,
          name: 'EditGroup',
          builder: (context, state) {
            final group = state.extra as GroupModel;
            return GroupEditPage(
              group: group,
              api: apiService,
            );
          },
        ),
        GoRoute(
          path: kProductList,
          builder: (context, state) {
            final productRepository = ProductRepository();
            final products = productRepository.getProducts();
            return ProductListPage(products: products);
          },
        ),
        GoRoute(
          path: kPaymentView,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: const PaymentView(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeIn).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: kManageProductView,
          builder: (BuildContext context, GoRouterState state) {
            final product = state.extra as RegionProductModel;
            return ManageProductView(
              product: product,
            );
          },
        ),
        GoRoute(
          path: kRegionManagement,
          builder: (BuildContext context, GoRouterState state) {
            final regions = state.extra as List<RegionModel>;
            return RegionManagementView(regions: regions);
          },
        ),
        GoRoute(
          path: kLicenseRenewalView,
          builder: (context, state) => const LicenseRenewal(),
        ),
        GoRoute(
          path: kUsersView,
          builder: (context, state) {
            final authority = state.extra as Authority;
            return UsersView(authority: authority);
          },
        ),
      ],
    );
  }

  static const kSignIn = '/';
  static const kHomeView = '/homeView';
  static const kPaymentView = '/paymentView';
  static const kLicenseRenewalView = '/licenseRenewalView';
  static const kRolesAndPermissionView = '/rolesAndPermissionView';
  static const kManageRolesView = '/manageRolesView';
  static const kUpdateRoleView = '/updateRoleView';
  static const kAddNewRoleView = '/addNewRoleView';
  static const kRegister = '/register';
  static const kForgot = '/forgot-password';
  static const kResetPassword = '/reset_password';
  static const kUsersView = '/usersView';
  static const kProductList = '/product-list';
  static const kUserManagement = '/user-management';
  static const kTeamManagement = '/team-management';
  static const kAddGroup = '/group_add';
  static const kGroupList = '/group_list_page';
  static const kGroupDetails = '/group_details';
  static const kUserProfile = '/user-profile';
  static Future<String?> _getUsernameFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}

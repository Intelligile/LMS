import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/presentation/views/forgot_password_page.dart';
import 'package:lms/features/auth/presentation/views/register_screen.dart';
import 'package:lms/features/auth/presentation/views/signin_screen.dart';
import 'package:lms/features/auth/presentation/views/widgets/reset_password_form.dart';
import 'package:lms/features/home/presentation/views/home_view.dart';
import 'package:lms/features/license_renewal/presentation/views/license_renewal.dart';
import 'package:lms/features/payment/presentation/views/payment_view.dart';
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
import 'package:lms/features/user_management/presentation/pages/user_management_page.dart';

abstract class AppRouter {
  final Dio _dio = Dio();
  final Api apiInstance = Api(Dio());
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

  // Initialize ApiService in the context where it is needed

  static final ApiService api = ApiService(api: Api(Dio()));

  static final GoRouter router = GoRouter(
    initialLocation: kSignIn,
    errorPageBuilder: (context, state) => MaterialPage(child: Container()),
    routes: [
      GoRoute(
        path: kRegister,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: kSignIn,
        builder: (context, state) => const SignIn(),
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
        path: kUpdateRoleView,
        builder: (context, state) => UpdateRolesView(),
      ),
      GoRoute(
        path: kManageRolesView,
        builder: (context, state) => ManageRolesView(),
      ),
      GoRoute(
        path: kHomeView,
        builder: (context, state) => const HomeView(),
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
        builder: (context, state) => GroupForm(
          api: api, // Pass ApiService instance
        ),
      ),
      GoRoute(
        path: kGroupList,
        builder: (context, state) => GroupListPage(),
      ),
      GoRoute(
        path: kGroupDetails,
        name: 'EditGroup',
        builder: (context, state) {
          final group = state.extra as GroupModel;
          return GroupEditPage(
            group: group,
            api: api, // Pass ApiService instance
          );
        },
      ),
      GoRoute(
        path: kProductList,
        builder: (context, state) {
          final productRepository = ProductRepository();
          final products = productRepository.getProducts();
          return ProductListPage(
            products: products,
          );
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
        path: kLicenseRenewalView,
        builder: (context, state) => const LicenseRenewal(),
      ),
      GoRoute(
        path: kUsersView,
        builder: (context, state) {
          final authority = state.extra as Authority;
          return UsersView(
            authority: authority,
          );
        },
      ),
    ],
  );
}

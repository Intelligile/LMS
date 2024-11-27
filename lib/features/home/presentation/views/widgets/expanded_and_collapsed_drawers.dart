import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:lms/features/home/data/models/expansion_tile_model.dart';
import 'package:lms/features/home/data/models/list_tile_model.dart';
import 'package:lms/features/home/presentation/views/widgets/drawer_item.dart';
import 'package:lms/features/home/presentation/views/widgets/drawer_menu.dart';
import 'package:lms/features/home/presentation/views/widgets/drawer_state.dart';
import 'package:lms/features/roles_and_premission/data/models/permission.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/permission_cubit/permission_cubit.dart';
import 'package:provider/provider.dart';

class CustomExpandedDrawer extends StatefulWidget {
  const CustomExpandedDrawer({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<CustomExpandedDrawer> createState() => _CustomExpandedDrawerState();
}

class _CustomExpandedDrawerState extends State<CustomExpandedDrawer> {
  int? hoveredIndex; // Only one index tracked at a time
  @override
  void initState() {
    super.initState();
    // Trigger permissions fetch on initialization
    context.read<PermissionCubit>().getPermissions(roleName: userRole);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionCubit, PermissionState>(
      builder: (context, state) {
        List<Permission> permissions = [];

        if (state is GetPermissionStateSuccess) {
          permissions = state.permissions;
        } else if (state is PermissionStateFailure) {
          print("Error fetching permissions: ${state.errorMessage}");
        } else if (state is PermissionStateLoading) {
          print("Permissions are loading...");
        } else {
          print("Current state: $state");
        }

        // Debugging: Print the permissions list
        print(
            "DEBUG: Permissions List: ${permissions.map((perm) => perm.permission).toList()}");

        bool drawerOpen =
            context.watch<OpenedAndClosedDrawerProvider>().isDrawerOpen;

        List<dynamic> drawerItems = getDrawerItems(drawerOpen, permissions);

        return Padding(
          padding: const EdgeInsets.only(left: 6, top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: widget.onPressed,
                child: const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(Icons.menu),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: drawerItems.length,
                  itemBuilder: (context, index) {
                    final item = drawerItems[index];
                    return MouseRegion(
                      onEnter: (_) => setState(() => hoveredIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 0),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: hoveredIndex == index
                              ? Colors.grey[200]
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: hoveredIndex == index
                              ? [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              selectedChildIndex = 0;
                            });
                            if (item is ListTileItemModel &&
                                item.path != null) {
                              GoRouter.of(context).go(item.path!);
                            }
                          },
                          child: _buildDrawerContent(item, index, drawerOpen),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerContent(dynamic item, int index, bool drawerOpen) {
    if (item is ListTileItemModel) {
      return DrawerItem(
        item: item,
        isSelected: selectedIndex == index,
      );
    } else if (item is ExpansionListTileItemModel) {
      return DrawerMenu(
        item: item,
        selectedChildIndex: selectedIndex == index ? selectedChildIndex : -1,
        onChildTap: (childIndex) {
          setState(() {
            selectedIndex = index;
            selectedChildIndex = childIndex;
          });
        },
      );
    }
    return const SizedBox.shrink();
  }
}

// External variables for selected indices
int selectedIndex = 0;
int selectedChildIndex = 0;
int? hoveredIndex; // Tracking only the hovered item index

class CustomCollapsedDrawer extends StatefulWidget {
  const CustomCollapsedDrawer({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<CustomCollapsedDrawer> createState() => _CustomCollapsedDrawerState();
}

class _CustomCollapsedDrawerState extends State<CustomCollapsedDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OpenedAndClosedDrawerProvider>(
      builder: (context, drawerStateProvider, child) {
        bool drawerOpen = drawerStateProvider.isDrawerOpen;
        List<Permission> permissions = context.read<PermissionCubit>().state
                is GetAllPermissionStateSuccess
            ? (context.read<PermissionCubit>().state
                    as GetAllPermissionStateSuccess)
                .permissions
            : [];

        List<dynamic> drawerItems = getDrawerItems(drawerOpen, permissions);

        return SizedBox(
          width: 200,
          child: Padding(
            padding: const EdgeInsets.only(left: 6, top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: widget.onPressed,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(Icons.menu),
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: drawerItems.length,
                    itemBuilder: (context, index) {
                      final item = drawerItems[index];
                      return MouseRegion(
                        onEnter: (_) => setState(() => hoveredIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 0),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: hoveredIndex == index
                                ? Colors.grey[200]
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: hoveredIndex == index
                                ? [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(2, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                selectedChildIndex = 0;
                              });
                              if (item is ListTileItemModel &&
                                  item.path != null) {
                                GoRouter.of(context).go(item.path!);
                              }
                            },
                            child: _buildDrawerContent(item, index, drawerOpen),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawerContent(dynamic item, int index, bool drawerOpen) {
    if (item is ListTileItemModel) {
      return DrawerItem(
        item: item,
        isSelected: selectedIndex == index,
      );
    } else if (item is ExpansionListTileItemModel) {
      return DrawerMenu(
        item: item,
        selectedChildIndex: selectedIndex == index ? selectedChildIndex : -1,
        onChildTap: (childIndex) {
          setState(() {
            selectedIndex = index;
            selectedChildIndex = childIndex;
          });
        },
      );
    }
    return const SizedBox.shrink();
  }
}

List<dynamic> getDrawerItems(bool drawerOpen, List<Permission> permissions) {
  return [
    // Home
    if (permissions.any((perm) => perm.permission == 'VIEW_HOME'))
      ListTileItemModel(
        icon: Icons.home_outlined,
        title: drawerOpen ? 'Home' : null,
        path: AppRouter.kHomeView,
      ),

    // Users
    if (permissions.any((perm) => perm.permission == 'EDIT_USERS'))
      ExpansionListTileItemModel(
        isExpanded: drawerOpen,
        icon: Icons.person_outline_sharp,
        title: drawerOpen ? 'Users' : '',
        children: [
          if (permissions.any((perm) => perm.permission == 'EDIT_USERS'))
            ListTileItemModel(
              icon: Icons.visibility,
              title: drawerOpen ? 'Manage Users' : null,
              path: AppRouter.kUserManagement,
              padding: drawerOpen
                  ? const EdgeInsets.only(left: 26.0)
                  : const EdgeInsets.only(left: 0.0),
              iconSize: 20.0,
            ),
        ],
      ),

    // Teams & Groups
    if (permissions.any((perm) => perm.permission == 'VIEW_TEAMS_GROUPS'))
      ExpansionListTileItemModel(
        isExpanded: drawerOpen,
        icon: Icons.groups_outlined,
        title: drawerOpen ? 'Teams & Groups' : '',
        children: [
          ListTileItemModel(
            icon: Icons.group,
            title: drawerOpen ? 'View Groups' : null,
            path: AppRouter.kTeamManagement,
            padding: drawerOpen
                ? const EdgeInsets.only(left: 26.0)
                : const EdgeInsets.only(left: 0.0),
            iconSize: 20.0,
          ),
        ],
      ),

    // Billing
    if (permissions.any((perm) => perm.permission == 'MANAGE_BILLING_ACCOUNTS'))
      ExpansionListTileItemModel(
        isExpanded: drawerOpen,
        icon: FontAwesomeIcons.moneyBill,
        title: drawerOpen ? 'Billing' : '',
        children: [
          if (permissions
              .any((perm) => perm.permission == 'MANAGE_BILLING_ACCOUNTS'))
            ListTileItemModel(
              icon: FontAwesomeIcons.dollarSign,
              title: drawerOpen ? 'Billing Accounts' : null,
              path: AppRouter.kBillingAccountManagement,
              padding: drawerOpen
                  ? const EdgeInsets.only(left: 26.0)
                  : const EdgeInsets.only(left: 0.0),
              iconSize: 20.0,
            ),
          if (permissions
              .any((perm) => perm.permission == 'MANAGE_PAYMENT_METHODS'))
            ListTileItemModel(
              icon: FontAwesomeIcons.solidCreditCard,
              title: drawerOpen ? 'Payment Methods' : null,
              path: AppRouter.kPaymentMethodsManagement,
              padding: drawerOpen
                  ? const EdgeInsets.only(left: 26.0)
                  : const EdgeInsets.only(left: 0.0),
              iconSize: 20.0,
            ),
        ],
      ),

    // Roles & Permissions
    if (permissions.any((perm) => perm.permission == 'VIEW_ROLES_PERMISSIONS'))
      ListTileItemModel(
        icon: Icons.verified_user,
        title: drawerOpen ? 'Roles and Permissions' : null,
        path: AppRouter.kRolesAndPermissionView,
      ),

    // Product
    if (permissions.any((perm) => perm.permission == 'VIEW_PURCHASE_PRODUCT'))
      ExpansionListTileItemModel(
        isExpanded: drawerOpen,
        icon: Icons.add_shopping_cart_sharp,
        title: drawerOpen ? 'Product' : '',
        children: [
          ListTileItemModel(
            icon: Icons.shopping_cart,
            title: drawerOpen ? 'Purchase Product' : null,
            path: AppRouter.kProductList,
            padding: drawerOpen
                ? const EdgeInsets.only(left: 26.0)
                : const EdgeInsets.only(left: 0.0),
            iconSize: 20.0,
          ),
          if (permissions
              .any((perm) => perm.permission == 'COMPLETE_PURCHASE_PRODUCT'))
            ListTileItemModel(
              icon: Icons.check,
              title: drawerOpen ? 'Manage Purchased Products' : null,
              path: AppRouter.kLicenseRenewalView,
              padding: drawerOpen
                  ? const EdgeInsets.only(left: 26.0)
                  : const EdgeInsets.only(left: 0.0),
              iconSize: 20.0,
            ),
        ],
      ),

    // Always Visible Items
    ListTileItemModel(
      icon: Icons.generating_tokens_sharp,
      title: drawerOpen ? 'Generate Auth Code' : null,
      path: AppRouter.kLicensorAuthGenerator,
    ),
    ListTileItemModel(
      icon: Icons.token_outlined,
      title: drawerOpen ? 'Authorization Codes' : null,
      path: AppRouter.kLicensorListAuthCodes,
    ),
    ListTileItemModel(
      icon: Icons.account_tree_outlined,
      title: drawerOpen ? 'DMZ Management' : null,
      path: AppRouter.kDMZManagement,
    ),
    ListTileItemModel(
      icon: FontAwesomeIcons.wrench,
      title: drawerOpen ? 'Setup' : null,
    ),
    ListTileItemModel(
      icon: FontAwesomeIcons.ellipsis,
      title: drawerOpen ? 'Show all items' : null,
    ),
  ];
}

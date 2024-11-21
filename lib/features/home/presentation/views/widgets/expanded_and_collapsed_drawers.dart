import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:lms/features/home/data/models/expansion_tile_model.dart';
import 'package:lms/features/home/data/models/list_tile_model.dart';
import 'package:lms/features/home/presentation/views/widgets/drawer_item.dart';
import 'package:lms/features/home/presentation/views/widgets/drawer_menu.dart';
import 'package:lms/features/home/presentation/views/widgets/drawer_state.dart';
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
  Widget build(BuildContext context) {
    return Consumer<OpenedAndClosedDrawerProvider>(
      builder: (context, drawerStateProvider, child) {
        bool drawerOpen = drawerStateProvider.isDrawerOpen;
        List<dynamic> drawerItems = getDrawerItems(drawerOpen);

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
        List<dynamic> drawerItems = getDrawerItems(drawerOpen);

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

// Define getDrawerItems to retrieve drawer items as needed
List<dynamic> getDrawerItems(bool drawerOpen) {
  return [
    ListTileItemModel(
      icon: Icons.home_outlined,
      title: drawerOpen ? 'Home' : null,
      path: AppRouter.kHomeView,
    ),
    if (userRole.contains('ROLE_ADMIN'))
      ExpansionListTileItemModel(
        isExpanded: false,
        icon: Icons.person_outline_sharp,
        title: drawerOpen ? 'Users' : '',
        children: [
          ListTileItemModel(
            icon: Icons.manage_accounts,
            title: drawerOpen ? 'Manage Users' : null,
            path: AppRouter.kUserManagement,
            padding: const EdgeInsets.only(left: 26.0),
            iconSize: 20.0,
          ),
        ],
      ),
    ExpansionListTileItemModel(
      isExpanded: false,
      icon: Icons.groups_outlined,
      title: drawerOpen ? 'Teams & Groups' : '',
      children: [
        ListTileItemModel(
          icon: Icons.group,
          title: drawerOpen ? 'Show Groups' : null,
          path: AppRouter.kTeamManagement,
          padding: const EdgeInsets.only(left: 26.0),
          iconSize: 20.0,
        ),
      ],
    ),
    ExpansionListTileItemModel(
      isExpanded: false,
      icon: FontAwesomeIcons.moneyBill,
      title: drawerOpen ? 'Billing' : '',
      children: [
        ListTileItemModel(
          icon: FontAwesomeIcons.dollarSign,
          title: drawerOpen ? 'Billing Accounts' : null,
          path: AppRouter.kBillingAccountManagement,
          padding: const EdgeInsets.only(left: 26.0),
          iconSize: 20.0,
        ),
        ListTileItemModel(
          icon: FontAwesomeIcons.solidCreditCard,
          title: drawerOpen ? 'Payment Methods' : null,
          path: AppRouter.kPaymentMethodsManagement,
          padding: const EdgeInsets.only(left: 26.0),
          iconSize: 20.0,
        ),
        // ListTileItemModel(
        //   icon: FontAwesomeIcons.solidCreditCard,
        //   title: drawerOpen ? 'View Payments' : null,
        //   path: AppRouter.kPaymentView,
        //   padding: const EdgeInsets.only(left: 26.0),
        //   iconSize: 20.0,
        // ),
      ],
    ),
    ListTileItemModel(
      icon: Icons.verified_user,
      title: drawerOpen ? 'Roles and permissions' : null,
      path: AppRouter.kRolesAndPermissionView,
    ),
    ListTileItemModel(
      icon: Icons.settings,
      title: drawerOpen ? 'Product Management' : null,
      path: AppRouter.kProductManagement,
    ),
    ExpansionListTileItemModel(
      isExpanded: false,
      icon: Icons.add_shopping_cart_sharp,
      title: drawerOpen ? 'Product' : '',
      children: [
        ListTileItemModel(
          icon: Icons.shopping_cart,
          title: drawerOpen ? 'Purchase Product' : null,
          path: AppRouter.kProductList,
          padding: const EdgeInsets.only(left: 26.0),
          iconSize: 20.0,
        ),
        ListTileItemModel(
          icon: Icons.manage_accounts,
          title: drawerOpen ? 'Manage Purchased Products' : null,
          path: AppRouter.kLicenseRenewalView,
          padding: const EdgeInsets.only(left: 26.0),
          iconSize: 20.0,
        ),
      ],
    ),
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

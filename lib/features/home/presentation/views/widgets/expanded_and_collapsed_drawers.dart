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
  @override
  Widget build(BuildContext context) {
    return Consumer<OpenedAndClosedDrawerProvider>(
        builder: (context, drawerStateProvider, child) {
      bool drawerOpen = drawerStateProvider.isDrawerOpen;
      List<dynamic> drawerItems = getDrawerItems(drawerOpen);
      return Padding(
        padding: const EdgeInsets.only(left: 16, top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: widget.onPressed,
              child: const Padding(
                padding: EdgeInsets.only(left: 10),
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
                  if (item is ListTileItemModel) {
                    return GestureDetector(
                      onTap: () {
                        if (selectedIndex != index) {
                          setState(() {
                            selectedIndex = index;
                            selectedChildIndex = 0;
                          });
                          if (item.path != null) {
                            GoRouter.of(context).go(item.path!);
                          }
                        }
                      },
                      child: DrawerItem(
                        item: item,
                        isSelected: selectedIndex == index,
                      ),
                    );
                  } else if (item is ExpansionListTileItemModel) {
                    return DrawerMenu(
                      item: item,
                      selectedChildIndex:
                          selectedIndex == index ? selectedChildIndex : -1,
                      onChildTap: (childIndex) {
                        setState(() {
                          selectedIndex = index;
                          selectedChildIndex = childIndex;
                        });
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

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
      return Padding(
        padding: const EdgeInsets.only(left: 16, top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: widget.onPressed,
              child: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(Icons.menu),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: drawerItems.length,
                itemBuilder: (context, index) {
                  final item = drawerItems[index];
                  if (item is ListTileItemModel) {
                    return GestureDetector(
                      onTap: () {
                        if (selectedIndex != index) {
                          setState(() {
                            selectedIndex = index;
                            selectedChildIndex = 0;
                          });
                          if (item.path != null) {
                            GoRouter.of(context).go(item.path!);
                          }
                        }
                      },
                      child: DrawerItem(
                        item: item,
                        isSelected: selectedIndex == index,
                      ),
                    );
                  } else if (item is ExpansionListTileItemModel) {
                    return DrawerMenu(
                      item: item,
                      selectedChildIndex:
                          selectedIndex == index ? selectedChildIndex : -1,
                      onChildTap: (childIndex) {
                        setState(() {
                          selectedIndex = index;
                          selectedChildIndex = childIndex;
                        });
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

int selectedIndex = 0;
int selectedChildIndex = 0;

List<dynamic> getDrawerItems(bool drawerOpen) {
  return [
    ListTileItemModel(
      icon: Icons.home_outlined,
      title: drawerOpen ? 'Home' : null,
      path: AppRouter.kHomeView, // Set path
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
            path: AppRouter.kUserManagement, // Set path
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
          path: AppRouter.kTeamManagement, // Set path
        ),
      ],
    ),
    ExpansionListTileItemModel(
      isExpanded: false,
      icon: FontAwesomeIcons.moneyBill,
      title: drawerOpen ? 'Billing' : '',
      children: [
        ListTileItemModel(
          icon: FontAwesomeIcons.solidCreditCard,
          title: drawerOpen ? 'View Payments' : null,
          path: AppRouter.kPaymentView, // Set path
        ),
      ],
    ),
    ListTileItemModel(
      icon: Icons.verified_user,
      title: drawerOpen ? 'Roles and permissions' : null,
      path: AppRouter.kRolesAndPermissionView, // Set path
    ),
    ListTileItemModel(
      icon: Icons.settings,
      title: drawerOpen ? 'Product Management' : null,
      path: AppRouter.kProductManagement, // Set path
    ),
    ExpansionListTileItemModel(
      isExpanded: false,
      icon: Icons.add_shopping_cart_sharp,
      title: drawerOpen ? 'Product' : '',
      children: [
        ListTileItemModel(
          icon: Icons.shopping_cart,
          title: drawerOpen ? 'Purchase Product' : null,
          path: AppRouter.kProductList, // Set path
        ),
        ListTileItemModel(
          icon: Icons.manage_accounts,
          title: drawerOpen ? 'Manage Purchased Products' : null,
          path: AppRouter.kLicenseRenewalView, // Set path
        ),
      ],
    ),
    ListTileItemModel(
      icon: Icons.generating_tokens_sharp,
      title: drawerOpen ? 'Generate Auth Code' : null,
      path: AppRouter.kLicensorAuthGenerator, // Set path
    ),
    ListTileItemModel(
      icon: Icons.token_outlined,
      title: drawerOpen ? 'Authorization Codes' : null,
      path: AppRouter.kLicensorListAuthCodes, // Set path
    ),
    ListTileItemModel(
      icon: FontAwesomeIcons.wrench,
      title: drawerOpen ? 'Setup' : null,

      //path: AppRouter.kSetup, // Set path
    ),
    ListTileItemModel(
      icon: FontAwesomeIcons.ellipsis,
      title: drawerOpen ? 'Show all items' : null,
      // path: AppRouter.kShowAllItems, // Set path
    ),
  ];
}

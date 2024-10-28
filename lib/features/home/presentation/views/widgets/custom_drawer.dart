// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lms/core/utils/assets.dart';
import 'package:lms/core/widgets/build_list_tile.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:lms/features/home/data/models/expansion_tile_model.dart';
import 'package:lms/features/home/data/models/list_tile_model.dart';
import 'package:lms/features/home/presentation/views/widgets/drawer_item.dart';
import 'package:lms/features/home/presentation/views/widgets/drawer_menu.dart';

class CustomExpandedDrawer extends StatefulWidget {
  const CustomExpandedDrawer({super.key});

  @override
  State<CustomExpandedDrawer> createState() => _CustomExpandedDrawerState();
}

class _CustomExpandedDrawerState extends State<CustomExpandedDrawer> {
  final List<dynamic> drawerItems = [
    ListTileItemModel(
      icon: Icons.home_outlined,
      title: 'Home',
      onTap: () {
        // Navigate to Home
        // GoRouter.of(context).go(AppRouter.kHomeView);
      },
    ),
    if (userRole.contains('ROLE_ADMIN'))
      ExpansionListTileItemModel(
        icon: Icons.person_outline_sharp,
        title: 'Users',
        children: [
          ListTileItemModel(
            icon: Icons.manage_accounts,
            title: 'Manage Users',
            onTap: () {
              // GoRouter.of(context).push(AppRouter.kUserManagement);
            },
          ),
        ],
      ),
    ExpansionListTileItemModel(
      icon: Icons.groups_outlined,
      title: 'Teams & Groups',
      children: [
        ListTileItemModel(
          icon: Icons.group,
          title: 'Show Groups',
          onTap: () {
            // GoRouter.of(context).push(AppRouter.kTeamManagement);
          },
        ),
      ],
    ),
    ExpansionListTileItemModel(
      icon: FontAwesomeIcons.moneyBill,
      title: 'Billing',
      children: [
        ListTileItemModel(
          icon: FontAwesomeIcons.solidCreditCard,
          title: 'View Payments',
          onTap: () {
            // GoRouter.of(context).push(AppRouter.kPaymentView);
          },
        ),
      ],
    ),
    ListTileItemModel(
      icon: Icons.verified_user,
      title: 'Roles and permissions',
      onTap: () {
        // GoRouter.of(context).push(AppRouter.kRolesAndPermissionView);
      },
    ),
    ListTileItemModel(
      icon: Icons.settings,
      title: 'Product Management',
      onTap: () {
        // GoRouter.of(context).push(AppRouter.kProductManagement);
      },
    ),
    ExpansionListTileItemModel(
      icon: Icons.add_shopping_cart_sharp,
      title: 'Product',
      children: [
        ListTileItemModel(
          icon: Icons.shopping_cart,
          title: 'Purchase Product',
          onTap: () {
            // GoRouter.of(context).push(AppRouter.kProductList);
          },
        ),
        ListTileItemModel(
          icon: Icons.manage_accounts,
          title: 'Manage Purchased Products',
          onTap: () {
            // GoRouter.of(context).push(AppRouter.kLicenseRenewalView);
          },
        ),
      ],
    ),
    ListTileItemModel(
      icon: Icons.generating_tokens_sharp,
      title: 'Generate Auth Code',
      onTap: () {
        // GoRouter.of(context).push(AppRouter.kLicensorAuthGenerator);
      },
    ),
    ListTileItemModel(
      icon: Icons.token_outlined,
      title: 'Authorization Codes',
      onTap: () {
        // GoRouter.of(context).push(AppRouter.kLicensorListAuthCodes);
      },
    ),
    ListTileItemModel(
      icon: FontAwesomeIcons.wrench,
      title: 'Setup',
      onTap: () {
        // Navigate to Setup
      },
    ),
    ListTileItemModel(
      icon: FontAwesomeIcons.ellipsis,
      title: 'Show all items',
      onTap: () {
        // Show all items
      },
    ),
  ];
  void onChildTap(int index) {
    setState(() {
      selectedChildIndex = index;
    });
  }

  int selectedIndex = 0;
  int selectedChildIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
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
                        selectedChildIndex = 0; // Reset child index if needed
                      });
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
    );
  }
}

// class DrawerExpansionTile extends StatefulWidget {
//   const DrawerExpansionTile({
//     super.key,
//     required this.item,
//   });

//   final ExpansionListTileItemModel item;

//   @override
//   State<DrawerExpansionTile> createState() => _DrawerExpansionTileState();
// }

// class _DrawerExpansionTileState extends State<DrawerExpansionTile> {
//   String selectedItemTitle = '';

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       leading: Icon(widget.item.icon),
//       title: Text(widget.item.title),
//       children: widget.item.children
//           .map(
//             (child) => GestureDetector(
//               onTap: () {
//                 if (selectedItemTitle != child.title) {
//                   setState(() {
//                     selectedItemTitle = '';
//                     selectedItemTitle = child.title;
//                   });
//                 }
//               },
//               child: DrawerItem(
//                   item: child, isSelected: selectedItemTitle == child.title),
//             ),
//           )
//           .toList(),
//     );
//   }
// }

class CustomCollapsedDrawer extends StatefulWidget {
  final VoidCallback closeDrawer;

  const CustomCollapsedDrawer({super.key, required this.closeDrawer});

  @override
  State<CustomCollapsedDrawer> createState() => _CustomCollapsedDrawerState();
}

class _CustomCollapsedDrawerState extends State<CustomCollapsedDrawer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              buildListTile(
                context: context,
                icon: Icons.home_outlined,
                onTap: () {},
              ),
              userRole.contains('ROLE_ADMIN')
                  ? buildListTile(
                      context: context,
                      icon: Icons.person_outline_sharp,
                      onTap: () {
                        // GoRouter.of(context).push(AppRouter.kUserManagement);
                      },
                    )
                  : const SizedBox(),
              //NEED TO CHANGE ENDPOINTS FOR LICENSOR USERS
              buildListTile(
                context: context,
                icon: Icons.person_outline_sharp,
                onTap: () {
                  // GoRouter.of(context).push(AppRouter.kUserManagement);
                },
              ),

              buildListTile(
                context: context,
                icon: Icons.groups_outlined,
                onTap: () {
                  // GoRouter.of(context).push(AppRouter.kTeamManagement);
                },
              ),

              userRole.contains('ROLE_ADMIN')
                  ? buildExpansionTile(
                      context: context,
                      icon: FontAwesomeIcons.moneyBill,
                      children: <Widget>[
                        buildListTile(
                          context: context,
                          icon: FontAwesomeIcons.solidCreditCard,
                          onTap: () {
                            // GoRouter.of(context).push(AppRouter.kPaymentView);
                          },
                        ),
                      ],
                    )
                  : const SizedBox(),

              userRole.contains('ROLE_ADMIN')
                  ? ListTile(
                      title: Image.asset(
                        AssetsData.rolesIcon,
                        height: 30,
                        width: 30,
                      ),
                      onTap: () {
                        // GoRouter.of(context)
                        //   .push(AppRouter.kRolesAndPermissionView);
                      },
                    )
                  : const SizedBox(),
              ListTile(
                title: Image.asset(
                  'assets/images/poroduct_mngmt.png',
                  height: 30,
                  width: 30,
                ),
                onTap: () {
                  // GoRouter.of(context).push(AppRouter.kProductManagement);
                },
              ),
              buildListTile(
                context: context,
                icon: Icons.generating_tokens_sharp,
                onTap: () {
                  // GoRouter.of(context).push(AppRouter.kLicensorAuthGenerator);
                },
              ),
              buildListTile(
                context: context,
                icon: Icons.token_outlined,
                onTap: () {
                  // GoRouter.of(context).push(AppRouter.kLicensorListAuthCodes);
                },
              ),
              // Ensure that userRole.contains is not null and valid
              buildExpansionTile(
                context: context,
                icon: Icons.add_shopping_cart_sharp,
                children: <Widget>[
                  buildListTile(
                    context: context,
                    icon: FontAwesomeIcons.creditCard,
                    onTap: () {
                      // GoRouter.of(context).push(AppRouter.kProductList);
                    },
                  ),
                  buildListTile(
                    context: context,
                    icon: Icons.work_outline,
                    onTap: () {
                      // GoRouter.of(context).push(AppRouter.kLicenseRenewalView);
                    },
                  ),
                ],
              ),

              buildListTile(
                context: context,
                icon: FontAwesomeIcons.wrench,
                onTap: () {
                  // Navigate to Copilot
                },
              ),
              const Divider(),
              buildListTile(
                context: context,
                icon: FontAwesomeIcons.ellipsis,
                onTap: () {
                  // Show all items
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DrawerItemModel {
  final IconData icon;
  String? title;
  final VoidCallback onTap;
  DrawerItemModel({
    required this.icon,
    this.title,
    required this.onTap,
  });
}

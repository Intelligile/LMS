import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/assets.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:lms/features/auth/presentation/manager/user_state.dart';
import 'package:provider/provider.dart';

class CustomExpandedDrawer extends StatefulWidget {
  final VoidCallback closeDrawer;

  const CustomExpandedDrawer({super.key, required this.closeDrawer});

  @override
  State<CustomExpandedDrawer> createState() => _CustomExpandedDrawerState();
}

class _CustomExpandedDrawerState extends State<CustomExpandedDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(builder: (context, userState, child) {
      return SizedBox(
        width: 250,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    title: const Row(
                      children: [
                        Icon(Icons.home_outlined),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Home'),
                      ],
                    ),
                    onTap: () {
                      // Navigate to Home
                    },
                  ),
                  userRole.contains('ROLE_ADMIN')
                      ? ExpansionTile(
                          title: const Row(
                            children: [
                              Icon(Icons.person_outline_sharp),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Users'),
                            ],
                          ),
                          children: <Widget>[
                            ListTile(
                              title: const Text('Manage Users'),
                              onTap: () {
                                GoRouter.of(context)
                                    .push(AppRouter.kUserManagement);
                              },
                            ),
                          ],
                        )
                      : Container(),
                  ExpansionTile(
                    title: const Row(
                      children: [
                        Icon(Icons.groups_outlined),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Teams & Groups'),
                      ],
                    ),
                    children: <Widget>[
                      ListTile(
                        title: const Text('Show Groups'),
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.kTeamManagement);
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Row(
                      children: [
                        Icon(FontAwesomeIcons.moneyBill),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Billing'),
                      ],
                    ),
                    children: <Widget>[
                      ListTile(
                        title: const Icon(FontAwesomeIcons.solidCreditCard),
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.kPaymentView);
                        },
                      ),
                    ],
                  ),
                  // ListTile(
                  //   title: Row(
                  //     children: [
                  //       Image.asset(
                  //         AssetsData.copilotIcon,
                  //         height: 30,
                  //         width: 30,
                  //       ),
                  //       const SizedBox(
                  //         width: 5,
                  //       ),
                  //       const Text('Copilot'),
                  //     ],
                  //   ),
                  //   onTap: () {
                  //     // Navigate to Copilot
                  //   },
                  // ),
                  userRole.contains('ROLE_ADMIN')
                      ? ListTile(
                          title: Row(
                            children: [
                              Image.asset(
                                AssetsData.rolesIcon,
                                height: 30,
                                width: 30,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('Roles and permissions'),
                            ],
                          ),
                          onTap: () {
                            GoRouter.of(context)
                                .push(AppRouter.kRolesAndPermissionView);
                          },
                        )
                      : Container(),
                  if (userState.isLicensor)
                    ListTile(
                      title: Row(
                        children: [
                          Image.asset(
                            'assets/images/poroduct_mngmt.png',
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text('Product Management'),
                        ],
                      ),
                      onTap: () {
                        GoRouter.of(context).push(AppRouter.kProductManagement);
                      },
                    ),
                  if (!userState.isLicensor)
                    ExpansionTile(
                      title: const Row(
                        children: [
                          Icon(Icons.add_shopping_cart_sharp),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Product'),
                        ],
                      ),
                      children: <Widget>[
                        ListTile(
                          title: const Text('Purchase Product'),
                          onTap: () {
                            GoRouter.of(context).push(AppRouter.kProductList);
                          },
                        ),
                        ListTile(
                          title: const Text('Manage Purchased Products'),
                          onTap: () {
                            GoRouter.of(context)
                                .push(AppRouter.kLicenseRenewalView);
                          },
                        ),
                      ],
                    ),
                  if (userState.isLicensor)
                    ListTile(
                      title: const Row(
                        children: [
                          Icon(Icons.generating_tokens_sharp),
                          Text('Generate Auth Code'),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      onTap: () {
                        GoRouter.of(context)
                            .push(AppRouter.kLicensorAuthGenerator);
                      },
                    ),
                  if (userState.isLicensor)
                    ListTile(
                      title: const Row(
                        children: [
                          Icon(Icons.token_outlined),
                          Text('Authorization Codes'),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      onTap: () {
                        GoRouter.of(context)
                            .push(AppRouter.kLicensorListAuthCodes);
                      },
                    ),
                  // ListTile(
                  //   title: const Row(
                  //     children: [
                  //       Icon(Icons.work_outline),
                  //       Text('Market place')
                  //     ],
                  //   ),
                  //   onTap: () {
                  //     GoRouter.of(context).push(AppRouter.kLicenseRenewalView);
                  //   },
                  // ),
                  ListTile(
                    title: const Row(
                      children: [
                        Icon(FontAwesomeIcons.wrench),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Setup'),
                      ],
                    ),
                    onTap: () {
                      // Navigate to Setup
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Row(
                      children: [
                        Icon(FontAwesomeIcons.ellipsis),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Show all items'),
                      ],
                    ),
                    onTap: () {
                      // Show all items
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class CustomCollapsedDrawer extends StatefulWidget {
  final VoidCallback closeDrawer;

  const CustomCollapsedDrawer({super.key, required this.closeDrawer});

  @override
  State<CustomCollapsedDrawer> createState() => _CustomCollapsedDrawerState();
}

class _CustomCollapsedDrawerState extends State<CustomCollapsedDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(builder: (context, userState, child) {
      return SizedBox(
        width: 120, // Increased the width for better layout
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    title: const Icon(Icons.home_outlined),
                    onTap: () {},
                  ),
                  userRole.contains('ROLE_ADMIN')
                      ? ListTile(
                          title: const Icon(Icons.person_outline_sharp),
                          onTap: () {
                            GoRouter.of(context)
                                .push(AppRouter.kUserManagement);
                          },
                        )
                      : Container(),
                  //NEED TO CHANGE ENDPOINTS FOR LICENSOR USERS
                  if (userState.isLicensor)
                    ListTile(
                      title: const Icon(Icons.person_outline_sharp),
                      onTap: () {
                        GoRouter.of(context).push(AppRouter.kUserManagement);
                      },
                    ),

                  ListTile(
                    title: const Icon(Icons.groups_outlined),
                    onTap: () {
                      GoRouter.of(context).push(AppRouter.kTeamManagement);
                    },
                  ),

                  userRole.contains('ROLE_ADMIN')
                      ? ExpansionTile(
                          title: const Row(
                            children: [
                              Icon(FontAwesomeIcons.moneyBill),
                            ],
                          ),
                          children: <Widget>[
                            ListTile(
                              title:
                                  const Icon(FontAwesomeIcons.solidCreditCard),
                              onTap: () {
                                GoRouter.of(context)
                                    .push(AppRouter.kPaymentView);
                              },
                            ),
                          ],
                        )
                      : Container(),

                  userRole.contains('ROLE_ADMIN')
                      ? ListTile(
                          title: Image.asset(
                            AssetsData.rolesIcon,
                            height: 30,
                            width: 30,
                          ),
                          onTap: () {
                            GoRouter.of(context)
                                .push(AppRouter.kRolesAndPermissionView);
                          },
                        )
                      : Container(),
                  if (userState.isLicensor)
                    ListTile(
                      title: Image.asset(
                        'assets/images/poroduct_mngmt.png',
                        height: 30,
                        width: 30,
                      ),
                      onTap: () {
                        GoRouter.of(context).push(AppRouter.kProductManagement);
                      },
                    ),
                  if (userState.isLicensor)
                    ListTile(
                      title: const Row(
                        children: [
                          Icon(Icons.generating_tokens_sharp),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      onTap: () {
                        GoRouter.of(context)
                            .push(AppRouter.kLicensorAuthGenerator);
                      },
                    ),
                  if (userState.isLicensor)
                    ListTile(
                      title: const Row(
                        children: [
                          Icon(Icons.token_outlined),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      onTap: () {
                        GoRouter.of(context)
                            .push(AppRouter.kLicensorListAuthCodes);
                      },
                    ),
                  // Ensure that userRole.contains is not null and valid
                  if (!userState.isLicensor)
                    ExpansionTile(
                      title: const Icon(Icons.add_shopping_cart_sharp),
                      children: <Widget>[
                        ListTile(
                          title: const Icon(FontAwesomeIcons.creditCard),
                          onTap: () {
                            GoRouter.of(context).push(AppRouter.kProductList);
                          },
                        ),
                        ListTile(
                          title: const Icon(Icons.work_outline),
                          onTap: () {
                            GoRouter.of(context)
                                .push(AppRouter.kLicenseRenewalView);
                          },
                        ),
                      ],
                    ),
                  // ListTile(
                  //   title: const Icon(Icons.work_outline),
                  //   onTap: () {
                  //     GoRouter.of(context).push(AppRouter.kLicenseRenewalView);
                  //   },
                  // ),
                  ListTile(
                    title: const Icon(FontAwesomeIcons.wrench),
                    onTap: () {
                      // Navigate to Copilot
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Icon(FontAwesomeIcons.ellipsis),
                    onTap: () {
                      // Show all items
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

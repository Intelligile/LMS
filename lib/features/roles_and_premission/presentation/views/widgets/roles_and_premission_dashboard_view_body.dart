// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/constants.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/styles.dart';
import 'package:lms/core/widgets/custom_breadcrumb.dart';
import 'package:lms/features/roles_and_premission/data/models/authority.dart';
import 'package:lms/features/roles_and_premission/data/models/permission.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/authoriy_cubit/authority_cubit.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/permission_cubit/permission_cubit.dart';
import 'package:lms/features/roles_and_premission/presentation/views/roles_and_permission_dashboard_view.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/actions_container.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/all_permission_card.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/roles_table_filtering_row.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/roles_table_header.dart';

class RolesAndPermissionDashboardViewBody extends StatefulWidget {
  const RolesAndPermissionDashboardViewBody({super.key});

  @override
  State<RolesAndPermissionDashboardViewBody> createState() =>
      _RolesAndPermissionDashboardViewBodyState();
}

class _RolesAndPermissionDashboardViewBodyState
    extends State<RolesAndPermissionDashboardViewBody> {
  @override
  Widget build(BuildContext context) {
    context.read<AuthorityCubit>().getAuthorities();

    return BlocConsumer<AuthorityCubit, AuthorityState>(
      listener: (context, state) {
        if (state is AuthorityStateFailure) {
          showSnackBar(context, state.errorMessage, Colors.red);
        } else if (state is GetAuthorityStateSuccess) {
          authorities = state.authorities;
        }
      },
      builder: (context, state) {
        return Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: CustomBreadcrumb(
                  items: const ['Home', 'Roles & Permissions'],
                  onTap: (index) {
                    if (index == 0) {
                      GoRouter.of(context).go(AppRouter.kHomeView);
                    } else if (index == 1) {}
                  },
                ),
              ),
              MediaQuery.sizeOf(context).width > 600
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              GoRouter.of(context)
                                  .push(AppRouter.kManageRolesView);
                            },
                            child: const ActionsContainer(
                                containerBgColor: Colors.white,
                                txtColor: kPrimaryColor,
                                containerIcon: Icon(
                                  Icons.settings,
                                  color: kPrimaryColor,
                                ),
                                containerText: 'Manage roles'),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: ActionsContainer(
                                containerIcon: Icon(
                                  FontAwesomeIcons.plus,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                containerText: 'Invite people',
                                containerBgColor: kPrimaryColor,
                                txtColor: Colors.white),
                          )
                        ],
                      ),
                    )
                  : const SizedBox()
            ],
          ),
          MediaQuery.sizeOf(context).width < 600
              ? Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.kManageRolesView);
                        },
                        child: const ActionsContainer(
                            containerBgColor: Colors.white,
                            txtColor: kPrimaryColor,
                            containerIcon: Icon(
                              Icons.settings,
                              color: kPrimaryColor,
                            ),
                            containerText: 'Manage roles'),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: ActionsContainer(
                            containerIcon: Icon(
                              FontAwesomeIcons.plus,
                              size: 22,
                              color: Colors.white,
                            ),
                            containerText: 'Invite people',
                            containerBgColor: kPrimaryColor,
                            txtColor: Colors.white),
                      )
                    ],
                  ),
                )
              : const SizedBox(),
          const RolesTableFilteringRow(),
          const RolesTableHeader(),
          state is AuthorityStateLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: authorities.length,
                    itemBuilder: (context, index) {
                      final role = authorities[index];
                      return RoleItem(role: role);
                    },
                  ),
                ),
        ]);
      },
    );
  }
}

class RoleItem extends StatefulWidget {
  final Authority role;

  const RoleItem({super.key, required this.role});

  @override
  State<RoleItem> createState() => _RoleItemState();
}

class _RoleItemState extends State<RoleItem> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          isSelected = value ?? false;
                        });
                      },
                    ),
                    InkWell(
                      onTap: () {
                        _openAuthorityFormFromRight(context,
                            authority: widget.role);
                      },
                      child: Text(
                        widget.role.authority ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: Text(
                  "this is a demo description of certain role",
                  // widget.role.description ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openAuthorityFormFromRight(BuildContext context,
      {required Authority authority}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // Allows the background to remain visible
        pageBuilder: (context, animation, secondaryAnimation) =>
            SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
                  .animate(animation),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.6, // 60% width of screen
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(-4, 0),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: Scaffold(
                  body: AuthorityPermissionsView(
                    authority: authority,
                  ),
                ),
              ),
            ),
          ),
        ),

        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}

class AuthorityPermissionsView extends StatefulWidget {
  final Authority authority;

  const AuthorityPermissionsView({super.key, required this.authority});

  @override
  _AuthorityPermissionsViewState createState() =>
      _AuthorityPermissionsViewState();
}

class _AuthorityPermissionsViewState extends State<AuthorityPermissionsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  List<Permission> perms = [];
  @override
  Widget build(BuildContext context) {
    context
        .read<PermissionCubit>()
        .getPermissions(roleName: widget.authority.authority);
    context.read<PermissionCubit>().getPermissions();
    return BlocListener<PermissionCubit, PermissionState>(
      listener: (context, state) {
        if (state is GetAllPermissionStateSuccess) {
          perms = state.permissions;
          for (Permission p in perms) {
            print(p.permission);
          }
        }
        if (state is GetPermissionStateSuccess) {
          singleRolesPermissions = state.permissions;
        } else if (state is PermissionStateFailure) {
          showSnackBar(context, state.errorMessage, Colors.red);
        }
      },
      child: BlocBuilder<PermissionCubit, PermissionState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.authority.authority ?? '',
                style: Styles.textStyle20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                      tabs: const [
                        Tab(text: 'General'),
                        Tab(text: 'Assigned'),
                        Tab(text: 'Permissions'),
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // General tab
                    const Center(
                      child: Text(
                        'General Information',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    // Assigned tab
                    const Center(
                      child: Text(
                        'Assigned Users',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),

                    // Permissions tab
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Expanded(flex: 2, child: Text('Role')),
                              Expanded(child: Text('Scope')),
                              Expanded(child: Text('Configuration')),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: perms.length,
                            itemBuilder: (context, index) {
                              final permission = perms[index];
                              return state is PermissionStateLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : AllPermissionCard(
                                      permission: permission,
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: BlocListener<AuthorityCubit, AuthorityState>(
                        listener: (context, state) {
                          if (state is UpdateAuthorityPermissionsStateSuccess) {
                            showSnackBar(
                                context, 'updated successfully', Colors.green);
                            context.read<PermissionCubit>().getPermissions(
                                roleName: widget.authority.authority);
                          } else if (state
                              is UpdateAuthorityPermissionsStateFailure) {
                            showSnackBar(
                                context, state.errorMessage, Colors.red);
                          }
                        },
                        child: state is UpdateAuthorityPermissionsStateLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ActionsContainer(
                                containerBgColor: Colors.green,
                                containerIcon: const Icon(Icons.save),
                                containerText: 'Save',
                                txtColor: Colors.white,
                                onPressed: () {
                                  List<dynamic> permissionsId =
                                      updatedPermission
                                          .map((p) => p.id)
                                          .toList();
                                  context
                                      .read<AuthorityCubit>()
                                      .updateAuthorityPermissions(
                                          authorityId: widget.authority.id,
                                          authorities: permissionsId);
                                },
                              )),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}

// class AuthorityDetailsView extends StatelessWidget {
//   const AuthorityDetailsView({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             authority.authority ?? '',
//             style: Styles.textStyle20,
//           ),
//           Row(
//             children: [
//               TextButton(
//                 onPressed: () {},
//                 child: const Text(
//                   'Save',
//                   style: TextStyle(fontSize: 16, color: Colors.black),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text(
//                   'Cancel',
//                   style: TextStyle(fontSize: 16, color: Colors.black),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

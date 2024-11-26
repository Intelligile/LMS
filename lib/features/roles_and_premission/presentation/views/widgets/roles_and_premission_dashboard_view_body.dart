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
import 'package:lms/features/roles_and_premission/data/models/user_dto.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/authoriy_cubit/authority_cubit.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/permission_cubit/permission_cubit.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/user_cubit/user_dto_cubit.dart';
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
              Expanded(
                child: Text(
                  widget.role.description ?? '',
                  style: const TextStyle(
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

  List<UserDto> _users = [];
  List<Permission> perms = [];

  @override
  Widget build(BuildContext context) {
    context
        .read<PermissionCubit>()
        .getPermissions(roleName: widget.authority.authority);
    context.read<UserDtoCubit>().getUsers(roleId: widget.authority.id);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.authority.authority ?? 'Authority Details',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              context
                  .read<PermissionCubit>()
                  .getPermissions(roleName: widget.authority.authority);
              context
                  .read<UserDtoCubit>()
                  .getUsers(roleId: widget.authority.id);
            },
            icon: const Icon(Icons.refresh),
          )
        ],
        bottom: TabBar(
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGeneralTab(),
          _buildAssignedTab(context),
          _buildPermissionsTab(context),
        ],
      ),
    );
  }

  Widget _buildGeneralTab() {
    return const Center(
      child: Text(
        'General Information',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildAssignedTab(BuildContext context) {
    return BlocBuilder<UserDtoCubit, UserDtoState>(
      builder: (context, state) {
        if (state is FetchUserLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FetchUserSuccessState) {
          _users = state.users;
          if (_users.isEmpty) {
            return const Center(
              child: Text(
                'No users assigned to this role.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        user.firstname?[0].toUpperCase() ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      user.username ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      '${user.email}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: const Text(
                      'Default',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is FetchUserFailureState) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          return const Center(
            child: Text(
              'No data available.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }
      },
    );
  }

  Widget _buildPermissionsTab(BuildContext context) {
    return BlocBuilder<PermissionCubit, PermissionState>(
      builder: (context, state) {
        if (state is PermissionStateLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetPermissionStateSuccess) {
          perms = state.permissions;

          // Log permissions for debugging
          print('Permissions Loaded: ${perms.length}');

          if (perms.isEmpty) {
            return const Center(
              child: Text(
                'No permissions available.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(flex: 5, child: Text('Permission')),
                    Expanded(flex: 3, child: Text('Assigned')),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: perms.length,
                    itemBuilder: (context, index) {
                      final permission = perms[index];
                      // Determine if permission is currently assigned
                      bool isAssigned = permission.authorityIds
                              ?.contains(widget.authority.id) ??
                          false;

                      return Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                permission.permission ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Checkbox(
                              value: isAssigned,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    // Assign permission
                                    permission.authorityIds ??=
                                        <dynamic>[]; // Initialize if null
                                    permission.authorityIds!
                                        .add(widget.authority.id);
                                  } else {
                                    // Unassign permission
                                    permission.authorityIds
                                        ?.remove(widget.authority.id);
                                  }

                                  // Immediately update the UI
                                  bool updatedIsAssigned = permission
                                          .authorityIds
                                          ?.contains(widget.authority.id) ??
                                      false;

                                  // Refresh UI with the updated state
                                  isAssigned = updatedIsAssigned;

                                  // Prepare checked IDs for the API call
                                  List<dynamic> checkedIds = perms
                                      .where((perm) =>
                                          perm.authorityIds
                                              ?.contains(widget.authority.id) ??
                                          false)
                                      .map((perm) => perm.id as dynamic)
                                      .toList();

                                  // Call updateAuthorityPermissions endpoint
                                  context
                                      .read<AuthorityCubit>()
                                      .updateAuthorityPermissions(
                                        authorityId: widget.authority.id,
                                        authorities: checkedIds,
                                      );
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is PermissionStateFailure) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          return const Center(
            child: Text(
              'Loading permissions...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
      },
    );
  }
}

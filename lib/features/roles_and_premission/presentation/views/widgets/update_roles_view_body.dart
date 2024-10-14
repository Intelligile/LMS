import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/features/roles_and_premission/data/models/authority.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/authoriy_cubit/authority_cubit.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/permission_cubit/permission_cubit.dart';
import 'package:lms/features/roles_and_premission/presentation/views/roles_and_permission_dashboard_view.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/actions_container.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/all_permission_card.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/permission_card.dart';

class UpdateRolesViewBody extends StatelessWidget {
  const UpdateRolesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PermissionCubit, PermissionState>(
      listener: (context, state) {
        if (state is GetAllPermissionStateSuccess) {
          allPermissions = state.permissions;
        }

        if (state is GetPermissionStateSuccess) {
          singleRolesPermissions = state.permissions;
        } else if (state is PermissionStateFailure) {
          showSnackBar(context, state.errorMessage, Colors.red);
        }
      },
      child: BlocBuilder<PermissionCubit, PermissionState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(left: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoleNameDropdown(
                  title: 'Select Role',
                  authorities: authorities,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Permissions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: state is PermissionStateLoading
                      ? const Center(child: CircularProgressIndicator())
                      : singleRolesPermissions.isNotEmpty
                          ? ListView.builder(
                              itemCount: singleRolesPermissions.length,
                              itemBuilder: (context, index) {
                                return PermissionCard(
                                  title: singleRolesPermissions[index]
                                          .permission ??
                                      '',
                                  subTitle: singleRolesPermissions[index]
                                          .permissionDescription ??
                                      '',
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                  'No Permissions were assigned to this role!'),
                            ),
                ),
                const Divider(),
                const Text('all permissions'),
                Expanded(
                  child: state is PermissionStateLoading
                      ? const Center(child: CircularProgressIndicator())
                      : allPermissions.isNotEmpty
                          ? ListView.builder(
                              itemCount: allPermissions.length,
                              itemBuilder: (context, index) {
                                return AllPermissionCard(
                                  permission: allPermissions[index],
                                );
                              },
                            )
                          : const Center(
                              child: Text('No available Permissions!'),
                            ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 110,
                      child: BlocListener<AuthorityCubit, AuthorityState>(
                          listener: (context, state) {
                            if (state
                                is UpdateAuthorityPermissionsStateSuccess) {
                              showSnackBar(context, 'updated successfully',
                                  Colors.green);
                              context.read<PermissionCubit>().getPermissions(
                                  roleName: selectedAuthority!.authority);
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
                                  containerIcon: Icon(Icons.save),
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
                                            authorityId: selectedAuthority!.id,
                                            authorities: permissionsId);
                                  },
                                )),
                    ),
                    const SizedBox(width: 30),
                    const SizedBox(
                        width: 110,
                        child: ActionsContainer(
                          containerBgColor: Colors.red,
                          containerIcon: Icon(Icons.cancel),
                          containerText: 'Cancel',
                          txtColor: Colors.white,
                        )),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Define the public Authority object
Authority? selectedAuthority;

class RoleNameDropdown extends StatefulWidget {
  final List<Authority> authorities;
  final String title;

  const RoleNameDropdown({
    super.key,
    required this.authorities,
    required this.title,
  });

  @override
  _RoleNameDropdownState createState() => _RoleNameDropdownState();
}

class _RoleNameDropdownState extends State<RoleNameDropdown> {
  late String selectedRole;

  @override
  void initState() {
    super.initState();
    // Initialize selectedRole and selectedAuthority
    selectedRole = widget.authorities[0].authority ?? '';
    selectedAuthority = widget.authorities.firstWhere(
      (authority) => authority.authority == selectedRole,
    );

    // Call getPermissions after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PermissionCubit>().getPermissions(roleName: selectedRole);
      context.read<PermissionCubit>().getPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16.0),
          SizedBox(
            width: 300,
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedRole,
              onChanged: (String? newValue) {
                setState(() {
                  selectedRole = newValue!;
                  // Update selectedAuthority based on selectedRole
                  selectedAuthority = widget.authorities.firstWhere(
                    (authority) => authority.authority == selectedRole,
                  );
                });

                updatedPermission.clear();
                // Trigger the getPermissions function with the updated role name
                context
                    .read<PermissionCubit>()
                    .getPermissions(roleName: selectedRole);
              },
              items: widget.authorities
                  .map<DropdownMenuItem<String>>((Authority value) {
                return DropdownMenuItem<String>(
                  value: value.authority,
                  child: Text(value.authority ?? ''),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

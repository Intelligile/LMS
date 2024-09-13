import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/styles.dart';
import 'package:lms/features/roles_and_premission/data/models/authority.dart';
import 'package:lms/features/roles_and_premission/data/models/user_dto.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/authoriy_cubit/authority_cubit.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/user_cubit/user_dto_cubit.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/actions_container.dart';

class ChangeUserRoleViewBody extends StatelessWidget {
  const ChangeUserRoleViewBody(
      {super.key, required this.userDto, required this.allAuthorities});
  final UserDto userDto;
  final List<Authority> allAuthorities;
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserDtoCubit, UserDtoState>(
      listener: (context, state) {
        if (state is UpdateUserAuthoritiesFailureState) {
          showSnackBar(context, state.errorMessage, Colors.red);
        } else if (state is UpdateUserAuthoritiesSuccessState) {
          showSnackBar(
              context, 'user authorities updated successfully', Colors.green);
        }
      },
      child: BlocBuilder<UserDtoCubit, UserDtoState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(left: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userDto.roles!.length == 1
                      ? 'Change ${userDto.username}s role'
                      : 'Change ${userDto.username}s roles',
                  style: Styles.textStyle20,
                ),
                const SizedBox(height: 16.0),
                Text(
                    userDto.roles!.length == 1
                        ? ' ${userDto.username}\'s current role'
                        : ' ${userDto.username}\'s current roles',
                    style: Styles.textStyle18),
                const SizedBox(height: 16.0),
                Expanded(
                  child: userDto.roles!.isNotEmpty
                      ? ListView.builder(
                          itemCount: userDto.roles!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 12),
                                child: Text(
                                  userDto.roles != null &&
                                          userDto.roles!.isNotEmpty
                                      ? userDto.roles![index] ??
                                          '' // Ensure you are accessing the correct index
                                      : 'No roles available', // A default message in case the list is empty or null
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text('No Roles were assigned to this user!'),
                        ),
                ),
                const Divider(),
                const Text('Assign Role:', style: Styles.textStyle18),
                Expanded(
                    child: state is AuthorityStateLoading
                        ? const Center(child: CircularProgressIndicator())
                        : allAuthorities.isNotEmpty
                            ? ListView.builder(
                                itemCount: allAuthorities.length,
                                itemBuilder: (context, index) {
                                  return AllRolesCard(
                                    role: allAuthorities[index],
                                    userRoles: userDto.roles ?? [],
                                  );
                                },
                              )
                            : const Center(
                                child: Text('No available Roles!'),
                              )),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 110,
                      child: ActionsContainer(
                        containerBgColor: Colors.green,
                        containerIcon: const Icon(Icons.save),
                        containerText: 'Save',
                        txtColor: Colors.white,
                        onPressed: () {
                          List<int> rolesId =
                              updatedRoles.map((p) => p.id!).toList();
                          context.read<UserDtoCubit>().updateUserAuthorities(
                              userId: userDto.id!, authoritiesId: rolesId);
                        },
                      ),
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

// Declare the updatedPermission list as a public global variable
List<Authority> updatedRoles = [];

class AllRolesCard extends StatefulWidget {
  const AllRolesCard({
    super.key,
    required this.role,
    required this.userRoles,
  });

  final Authority role;
  final List<dynamic> userRoles;
  @override
  _AllRolesCardState createState() => _AllRolesCardState();
}

class _AllRolesCardState extends State<AllRolesCard> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();

    // Initialize isChecked based on whether the role is in singleRolesroles
    isChecked = widget.userRoles.any((perm) => perm == widget.role.authority);

    // Ensure already checked roles are added to the updatedRole list
    if (isChecked && !updatedRoles.contains(widget.role)) {
      updatedRoles.add(widget.role);
    }
  }

  void _onCheckboxChanged(bool? value) {
    setState(() {
      isChecked = value ?? false;

      if (isChecked) {
        // Add role to updatedRole list
        if (!updatedRoles.contains(widget.role)) {
          updatedRoles.add(widget.role);
        }
      } else {
        // Remove role from updatedRole list
        updatedRoles
            .removeWhere((perm) => perm.authority == widget.role.authority);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Wrap the Checkbox in a SizedBox or Container
          SizedBox(
            width: 40,
            child: Checkbox(
              value: isChecked,
              onChanged: _onCheckboxChanged,
            ),
          ),
          // Use Flexible to ensure the ListTile takes up remaining space correctly
          Flexible(
            child: ListTile(
              title: Text(widget.role.authority ?? ''),
              onTap: () {},
              subtitle: Text(widget.role.description ?? ''),
            ),
          ),
        ],
      ),
    );
  }
}

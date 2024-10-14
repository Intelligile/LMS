// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/features/roles_and_premission/data/models/user_dto.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/user_cubit/user_dto_cubit.dart';
import 'package:lms/features/roles_and_premission/presentation/views/roles_and_permission_dashboard_view.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/pop_up_menu_actions_button.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/users_table_filtering_row.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/users_table_header.dart';

class RolesAndPermissionDashboardViewBody extends StatefulWidget {
  const RolesAndPermissionDashboardViewBody({super.key});

  @override
  State<RolesAndPermissionDashboardViewBody> createState() =>
      _RolesAndPermissionDashboardViewBodyState();
}

class _RolesAndPermissionDashboardViewBodyState
    extends State<RolesAndPermissionDashboardViewBody> {
  void _removeUser(UserDto user) {
    setState(() {
      users.remove(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<UserDtoCubit>().getUsers();

    return BlocListener<UserDtoCubit, UserDtoState>(
      listener: (context, state) {
        if (state is FetchUserFailureState) {
          showSnackBar(context, state.errorMessage, Colors.red);
        } else if (state is FetchUserSuccessState) {
          users = state.users;
        }
      },
      child: BlocBuilder<UserDtoCubit, UserDtoState>(
        builder: (context, state) {
          return Column(
            children: [
              // Filters Row
              const UsersTableFilteringRow(),
              // Data Row
              const UsersTableHeader(),
              // List of Users
              state is FetchUserLoadingState
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      // This ensures the ListView takes the remaining space
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          UserDto user = users[index];
                          return Column(
                            children: [
                              displayUserRow(user: user),
                              const Divider(
                                thickness: .5,
                              )
                            ],
                          );
                        },
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  Container displayUserRow({required UserDto user}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
        children: [
          Expanded(
            child:
                displayUserName(userName: user.username!, email: user.email!),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: user.roles!
                  .map(
                    (role) => Container(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        role.trim(),
                        style: const TextStyle(
                          height: 1.5,
                          fontFamily: 'Courier',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          PopUpMenuActionsButton(
            onSelected: (value) {
              if (value == 'Remove') {
                _removeUser(user);
              }
            },
          ),
        ],
      ),
    );
  }

  Row displayUserName({required String userName, required String email}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue[100],
          radius: 20,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(email),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/features/roles_and_premission/data/models/authority.dart';
import 'package:lms/features/roles_and_premission/data/models/user_dto.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/user_cubit/user_dto_cubit.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/permission_card.dart';

class UsersViewBody extends StatelessWidget {
  UsersViewBody({super.key, required this.authority});
  Authority authority;
  List<UserDto> _users = [];
  @override
  Widget build(BuildContext context) {
    context.read<UserDtoCubit>().getUsers(roleId: authority.id);
    return BlocListener<UserDtoCubit, UserDtoState>(
      listener: (context, state) {
        if (state is FetchUserFailureState) {
          showSnackBar(context, state.errorMessage, Colors.red);
        } else if (state is FetchUserSuccessState) {
          _users = state.users;
        }
      },
      child: BlocBuilder<UserDtoCubit, UserDtoState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('users in ${authority.authority}'),
              state is FetchUserLoadingState
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _users.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                          itemCount: _users.length,
                          itemBuilder: (context, index) {
                            return PermissionCard(
                              title: _users[index].username,
                            );
                          },
                        ))
                      : Text('no users in role : ${authority.authority}')
            ],
          );
        },
      ),
    );
  }
}

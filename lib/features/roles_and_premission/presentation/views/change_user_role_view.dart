import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/roles_and_premission/data/models/user_dto.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/authoriy_cubit/authority_cubit.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/change_user_role_view_body.dart';

class ChangeUserRoleView extends StatelessWidget {
  const ChangeUserRoleView({super.key, required this.userDto});
  final UserDto userDto;
  @override
  Widget build(BuildContext context) {
    // Fetch authorities when the widget is built
    context.read<AuthorityCubit>().getAuthorities();

    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<AuthorityCubit, AuthorityState>(
        builder: (context, state) {
          if (state is AuthorityStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetAuthorityStateSuccess) {
            final allAuthorities = state.authorities;
            return ChangeUserRoleViewBody(
              allAuthorities: allAuthorities,
              userDto: userDto,
            );
          } else if (state is AuthorityStateFailure) {
            // Display error message if fetching authorities fails
            return Center(child: Text(state.errorMessage));
          } else {
            return const Center(child: Text('No available Roles!'));
          }
        },
      ),
    );
  }
}

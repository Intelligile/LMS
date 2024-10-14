import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/styles.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/authoriy_cubit/authority_cubit.dart';
import 'package:lms/features/roles_and_premission/presentation/views/roles_and_permission_dashboard_view.dart';

class ManageRolesViewBody extends StatelessWidget {
  ManageRolesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger the authorities fetch when the widget is built
    context.read<AuthorityCubit>().getAuthorities();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocConsumer<AuthorityCubit, AuthorityState>(
        listener: (context, state) {
          if (state is AuthorityStateFailure) {
            showSnackBar(context, state.errorMessage, Colors.red);
          } else if (state is GetAuthorityStateSuccess) {
            authorities = state.authorities;
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Custom roles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              state is AuthorityStateLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: authorities.length,
                        itemBuilder: (context, index) {
                          final role = authorities[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(role.authority ?? ''),
                                  InkWell(
                                    onTap: () {
                                      GoRouter.of(context).push(
                                          AppRouter.kUsersView,
                                          extra: role);
                                    },
                                    child: Text(
                                      'view users',
                                      style: Styles.textStyle20
                                          .copyWith(color: Colors.blue),
                                    ),
                                  )
                                ],
                              ),
                              onTap: () {
                                // Handle role tap
                              },
                            ),
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
}

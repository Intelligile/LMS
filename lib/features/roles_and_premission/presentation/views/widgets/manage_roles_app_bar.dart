import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/styles.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/actions_container.dart';

class ManageRolesAppBarBody extends StatelessWidget {
  const ManageRolesAppBarBody({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Manage Roles',
                    style: Styles.textStyle20,
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push(AppRouter.kUpdateRoleView);
                      },
                      child: const ActionsContainer(
                        containerIcon: Icon(
                          Icons.update,
                          size: 22,
                          color: Colors.white,
                        ),
                        containerText: 'Update role',
                        containerBgColor: Colors.blue,
                        txtColor: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push(AppRouter.kManageRolesView);
                      },
                      child: GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.kAddNewRoleView);
                        },
                        child: const ActionsContainer(
                          containerBgColor: Colors.white,
                          txtColor: Colors.blue,
                          containerIcon: Icon(
                            FontAwesomeIcons.plus,
                            color: Colors.blue,
                          ),
                          containerText: 'Create new role',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    const Text(
                      'Create, view and edit roles & permissions for this site. ',
                      style: Styles.textStyle16,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Learn more',
                      style: Styles.textStyle16.copyWith(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

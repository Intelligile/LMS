import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/styles.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/actions_container.dart';

class AppBarBody extends StatelessWidget {
  const AppBarBody({
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
                    'Roles and Permissions Dashboard',
                    style: Styles.textStyle20,
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push(AppRouter.kManageRolesView);
                      },
                      child: const ActionsContainer(
                          containerBgColor: Colors.white,
                          txtColor: Colors.blue,
                          containerIcon: Icon(
                            Icons.settings,
                            color: Colors.blue,
                          ),
                          containerText: 'Manage roles'),
                    ),
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
                        containerBgColor: Colors.blue,
                        txtColor: Colors.white),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    const Text(
                      'Invite people to work on this site, assign them roles and set their permissions.',
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

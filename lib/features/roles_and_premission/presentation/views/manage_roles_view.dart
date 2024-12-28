import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/constants.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/styles.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/actions_container.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/manage_roles_view_body.dart';

class ManageRolesView extends StatelessWidget {
  const ManageRolesView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              const Text(
                'Manage Roles',
                style: Styles.textStyle20,
              ),
              const Spacer(),
              MediaQuery.sizeOf(context).width > 600
                  ? AppBarActionButton(
                      ontap: () {
                        GoRouter.of(context).push(AppRouter.kUpdateRoleView);
                      },
                      icon: Icons.update,
                    )
                  : const SizedBox(),
              MediaQuery.sizeOf(context).width > 600
                  ? AppBarActionButton(
                      ontap: () {
                        GoRouter.of(context).push(AppRouter.kAddNewRoleView);
                      },
                      icon: FontAwesomeIcons.plus,
                      txt: 'Create new role',
                      tColor: kPrimaryColor,
                      bColor: Colors.white,
                    )
                  : const SizedBox(),
            ],
          ),
        ),

        //  PreferredSize(
        //   preferredSize: const Size.fromHeight(110),
        //   child: AppBar(
        //     leading: const SizedBox(),
        //     backgroundColor: const Color(0xfff0f4f7),
        //     flexibleSpace: const ManageRolesAppBarBody(),
        //   ),
        // ),
        body: const ManageRolesViewBody(),
      ),
    );
  }
}

class AppBarActionButton extends StatelessWidget {
  const AppBarActionButton(
      {super.key,
      required this.ontap,
      required this.icon,
      this.tColor,
      this.bColor,
      this.txt});
  final VoidCallback ontap;
  final IconData icon;
  final Color? tColor;
  final Color? bColor;
  final String? txt;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: ontap,
        child: ActionsContainer(
          containerIcon: Icon(
            icon,
            size: 22,
            color: tColor ?? Colors.white,
          ),
          containerText: txt ?? 'Update role',
          containerBgColor: bColor ?? kPrimaryColor,
          txtColor: tColor ?? Colors.white,
        ),
      ),
    );
  }
}

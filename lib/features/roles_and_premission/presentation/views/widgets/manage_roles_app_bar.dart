// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lms/constants.dart';
// import 'package:lms/core/utils/app_router.dart';
// import 'package:lms/core/utils/styles.dart';
// import 'package:lms/features/roles_and_premission/presentation/views/widgets/actions_container.dart';

// class ManageRolesAppBarBody extends StatelessWidget {
//   const ManageRolesAppBarBody({
//     super.key,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         Container(
//           // height: ,
//           constraints:
//               BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 40),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   const Text(
//                     'Manage Roles',
//                     style: Styles.textStyle20,
//                   ),
//                   const Spacer(),
//                   MediaQuery.sizeOf(context).width > 600
//                       ? AppBarActionButton(
//                           ontap: () {
//                             GoRouter.of(context)
//                                 .push(AppRouter.kUpdateRoleView);
//                           },
//                           icon: Icons.update,
//                         )
//                       : const SizedBox(),
//                   MediaQuery.sizeOf(context).width > 600
//                       ? AppBarActionButton(
//                           ontap: () {
//                             GoRouter.of(context)
//                                 .push(AppRouter.kManageRolesView);
//                           },
//                           icon: FontAwesomeIcons.plus,
//                           txt: 'Create new role',
//                           tColor: kPrimaryColor,
//                           bColor: Colors.white,
//                         )
//                       : const SizedBox(),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10.0),
//                 child: Row(
//                   children: [
//                     const Flexible(
//                       child: Text(
//                         'Create, view and edit roles & permissions for this site. ',
//                         style: Styles.textStyle16,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     const SizedBox(width: 5),
//                     Flexible(
//                       child: Text(
//                         'Learn more',
//                         style: Styles.textStyle16.copyWith(color: Colors.blue),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

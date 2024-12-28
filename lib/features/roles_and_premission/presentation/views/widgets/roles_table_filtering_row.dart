import 'package:flutter/material.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/custom_search_bar.dart';

class RolesTableFilteringRow extends StatelessWidget {
  const RolesTableFilteringRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MediaQuery.sizeOf(context).width < 600
          ? const CustomSearchBar()
          : const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomSearchBar(),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(),
                )
              ],
            ),
    );
  }
}

// class UsersTableFilteringRow extends StatelessWidget {
//   const UsersTableFilteringRow({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           const Expanded(
//             flex: 4,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 FittedBox(
//                     fit: BoxFit.scaleDown,
//                     child: CustomDropDownButton(label: 'Show', value: 'All')),
//                 FittedBox(
//                     fit: BoxFit.scaleDown,
//                     child: CustomDropDownButton(label: 'Role', value: 'All')),
//                 Expanded(child: CustomSearchBar()),
//               ],
//             ),
//           ),
//           Expanded(
//             child: FittedBox(
//               fit: BoxFit.scaleDown,
//               child: TextButton(
//                 onPressed: () {},
//                 child: const Text(
//                   'Clear Filters',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:lms/core/utils/styles.dart';

// Container userNameIcon() {
//     return Container(
//           width: 40.0,
//           height: 40.0,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(width: 2, color: Colors.white),
//           ),
//           child: Center(
//             child: Text(
//               'FZ',
//               style: Styles.textStyle16.copyWith(color: Colors.white),
//             ),
//           ),
//         );
//   }

import 'package:flutter/material.dart';
import 'package:lms/core/utils/styles.dart';

class UserNameIcon extends StatelessWidget {
  const UserNameIcon({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate the size of the container as a percentage of the screen size
    double containerSize =
        screenWidth * 0.04; // 10% of the screen width, for example

    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2, color: Colors.white),
      ),
      child: Center(
        child: Text(
          'FZ',
          style: Styles.textStyle16.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

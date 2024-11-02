import 'package:flutter/material.dart';
import 'package:lms/core/utils/styles.dart';

class AppBarGridIconAndTitle extends StatelessWidget {
  const AppBarGridIconAndTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        const Icon(
          Icons.apps,
          color: Colors.white,
        ),
        Text(
          'License Management System',
          style: Styles.textStyle20.copyWith(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }
}

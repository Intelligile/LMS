import 'package:flutter/material.dart';

class RolesTableHeader extends StatelessWidget {
  const RolesTableHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Expanded(
              child: Text('Role Group',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child: Text('Description',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

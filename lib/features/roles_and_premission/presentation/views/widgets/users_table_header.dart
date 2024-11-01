import 'package:flutter/material.dart';

class UsersTableHeader extends StatelessWidget {
  const UsersTableHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[50],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
          Spacer(),
          Text('Role', style: TextStyle(fontWeight: FontWeight.bold)),
          Spacer(),
        ],
      ),
    );
  }
}

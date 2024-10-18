import 'package:flutter/material.dart';

class PermissionCard extends StatelessWidget {
  const PermissionCard({super.key, this.title, this.subTitle});
  final String? title;
  final String? subTitle;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(title ?? ''),
        onTap: () {},
        subtitle: Text(subTitle ?? ''),
      ),
    );
  }
}

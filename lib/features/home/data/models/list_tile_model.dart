import 'package:flutter/material.dart';

class ListTileItemModel {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  ListTileItemModel({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

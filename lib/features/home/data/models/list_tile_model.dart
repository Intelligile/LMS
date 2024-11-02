import 'package:flutter/material.dart';

class ListTileItemModel {
  final IconData icon;
  final String? title;
  final String? path;
  final EdgeInsetsGeometry padding; // Padding property
  final double iconSize; // Icon size property

  ListTileItemModel({
    required this.icon,
    this.title,
    this.path,
    this.padding = const EdgeInsets.all(0), // Default to no padding
    this.iconSize = 24.0, // Default icon size
  });
}

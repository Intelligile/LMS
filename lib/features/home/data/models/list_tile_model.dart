import 'package:flutter/material.dart';

class ListTileItemModel {
  final IconData icon;
  final String title;
  final String? path;

  ListTileItemModel({
    required this.icon,
    required this.title,
    this.path,
  });
}

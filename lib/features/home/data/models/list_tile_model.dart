import 'package:flutter/material.dart';

class ListTileItemModel {
  final IconData icon;
  final String? title;
  final String? path;

  ListTileItemModel({
    required this.icon,
    this.title,
    this.path,
  });
}

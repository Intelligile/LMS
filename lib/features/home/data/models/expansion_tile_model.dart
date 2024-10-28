import 'package:flutter/material.dart';
import 'package:lms/features/home/data/models/list_tile_model.dart';

class ExpansionListTileItemModel {
  final IconData icon;
  final String title;
  final List<ListTileItemModel> children;

  ExpansionListTileItemModel({
    required this.icon,
    required this.title,
    required this.children,
  });
}

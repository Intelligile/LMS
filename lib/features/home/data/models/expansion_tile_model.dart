import 'package:flutter/material.dart';
import 'package:lms/features/home/data/models/list_tile_model.dart';

class ExpansionListTileItemModel {
  final IconData icon;
  final String title;
  final List<ListTileItemModel> children;
  final bool isExpanded;
  ExpansionListTileItemModel({
    required this.isExpanded,
    required this.icon,
    required this.title,
    required this.children,
  });
}

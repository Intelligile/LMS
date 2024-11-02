import 'package:flutter/material.dart';
import 'package:lms/features/home/data/models/list_tile_model.dart';
import 'package:lms/features/home/presentation/views/widgets/active_and_inactive_drawer_item.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({super.key, required this.item, required this.isSelected});

  final ListTileItemModel item;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return isSelected
        ? ActiveDrawerItem(item: item)
        : InActiveDrawerItem(item: item);
  }
}

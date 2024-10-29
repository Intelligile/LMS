import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/get_responsive_font_size.dart';
import 'package:lms/features/home/data/models/expansion_tile_model.dart';
import 'package:lms/features/home/presentation/views/widgets/drawer_item.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({
    super.key,
    required this.item,
    required this.selectedChildIndex,
    required this.onChildTap,
  });

  final ExpansionListTileItemModel item;
  final int selectedChildIndex;
  final ValueChanged<int> onChildTap;
  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      leading: Icon(widget.item.icon),
      title: Text(
        widget.item.title,
        style: TextStyle(
          color: Colors.black,
          fontSize: getResponsiveFontSize(context, baseFontSize: 14),
        ),
      ),
      iconColor: Colors.black,
      collapsedIconColor: Colors.black,
      children: widget.item.children.asMap().entries.map(
        (entry) {
          final index = entry.key;
          final child = entry.value;
          return GestureDetector(
            onTap: () {
              widget.onChildTap(index);
              if (child.path != null) {
                GoRouter.of(context).go(child.path!);
              }
            },
            child: DrawerItem(
              item: child,
              isSelected: widget.selectedChildIndex == index,
            ),
          );
        },
      ).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/features/home/data/models/expansion_tile_model.dart';
import 'package:lms/features/home/presentation/views/widgets/drawer_item.dart';
import 'package:lms/features/home/presentation/views/widgets/drawer_state.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final drawerStateProvider = Provider.of<DrawerStateProvider>(context);
    final isExpanded = drawerStateProvider.isExpanded(item.title);

    return ExpansionTile(
      initiallyExpanded: isExpanded,
      onExpansionChanged: (value) {
        drawerStateProvider.toggleExpansion(item.title);
      },
      leading: Icon(item.icon),
      title: Text(item.title, style: const TextStyle(color: Colors.black)),
      iconColor: Colors.black,
      collapsedIconColor: Colors.black,
      children: item.children.asMap().entries.map(
        (entry) {
          final index = entry.key;
          final child = entry.value;
          return GestureDetector(
            onTap: () {
              onChildTap(index);
              if (child.path != null) {
                GoRouter.of(context).go(child.path!);
              }
            },
            child: DrawerItem(
              item: child,
              isSelected: selectedChildIndex == index,
            ),
          );
        },
      ).toList(),
    );
  }
}

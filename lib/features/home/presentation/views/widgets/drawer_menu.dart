import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/theme_provider.dart';
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
    final drawerStateProvider =
        Provider.of<ExpansionTileDrawerProvider>(context);

    final isExpanded = drawerStateProvider.isExpanded(item.title ?? '');
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ExpansionTile(
      tilePadding: const EdgeInsets.only(left: 8),
      initiallyExpanded: isExpanded,
      onExpansionChanged: (value) {
        drawerStateProvider.toggleExpansion(item.title ?? '');
      },
      leading: Icon(item.icon),
      title: Text(item.title ?? ''),
      iconColor: themeProvider.themeMode == ThemeMode.light
          ? Colors.black
          : Colors.white,
      collapsedIconColor: themeProvider.themeMode == ThemeMode.light
          ? Colors.black
          : Colors.white,
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

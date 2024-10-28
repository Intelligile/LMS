import 'package:flutter/material.dart';
import 'package:lms/constants.dart';
import 'package:lms/core/functions/get_responsive_font_size.dart';
import 'package:lms/features/home/data/models/list_tile_model.dart';

class InActiveDrawerItem extends StatelessWidget {
  const InActiveDrawerItem({
    super.key,
    required this.item,
  });

  final ListTileItemModel item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(item.icon),
      title: Flexible(
        child: Text(
          item.title,
          style: TextStyle(
            fontSize: getResponsiveFontSize(context, baseFontSize: 14),
          ),
        ),
      ),
      //onTap: item.onTap,
    );
  }
}

class ActiveDrawerItem extends StatelessWidget {
  const ActiveDrawerItem({
    super.key,
    required this.item,
  });

  final ListTileItemModel item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        item.icon,
        color: kPrimaryColor,
      ),
      title: Flexible(
        child: Text(
          item.title,
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: getResponsiveFontSize(context, baseFontSize: 14),
          ),
        ),
      ),
      onTap: item.onTap,
    );
  }
}

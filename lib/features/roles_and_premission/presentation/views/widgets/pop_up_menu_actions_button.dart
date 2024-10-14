import 'package:flutter/material.dart';

class PopUpMenuActionsButton extends StatelessWidget {
  const PopUpMenuActionsButton({
    super.key,
    this.onSelected,
  });
  final void Function(String)? onSelected;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'Change Role',
            child: Text('Change Role'),
          ),
          const PopupMenuItem<String>(
            value: 'Resend Invite',
            child: Text('Resend Invite'),
          ),
          const PopupMenuItem<String>(
            value: 'Get Invite Link',
            child: Text('Get Invite Link'),
          ),
          const PopupMenuItem<String>(
            value: 'Remove',
            child: Text('Remove'),
          ),
        ];
      },
    );
  }
}

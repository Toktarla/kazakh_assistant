import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../config/app_colors.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteConfirmationDialog({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      title: Text('confirm_delete').tr(),
      content: Text('confirm_delete_message').tr(),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: const TextStyle(color: AppColors.blueAccentColor),
          ).tr(),
        ),
        TextButton(
          onPressed: () {
            onDelete();
            Navigator.of(context).pop();
          },
          child: Text(
            'yes',
            style: const TextStyle(color: Colors.red),
          ).tr(),
        ),
      ],
    );
  }
}

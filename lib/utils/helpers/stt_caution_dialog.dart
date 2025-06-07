import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SttCautionDialog extends StatelessWidget {
  const SttCautionDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const SttCautionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('stt_dialog.title'.tr()),
      content: Text('stt_dialog.message'.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('stt_dialog.ok'.tr()),
        ),
      ],
    );
  }
}

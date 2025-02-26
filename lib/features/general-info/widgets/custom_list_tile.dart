import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String content;
  const CustomListTile(this.title, this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(content),
    );
  }
}

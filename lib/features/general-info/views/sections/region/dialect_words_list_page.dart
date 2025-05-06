import 'package:flutter/material.dart';

import '../../../../../config/variables.dart';

class DialectWordsListPage extends StatelessWidget {
  final String regionId;
  final String typeKey;

  const DialectWordsListPage({super.key, required this.regionId, required this.typeKey});

  @override
  Widget build(BuildContext context) {
    final words = mockWords[typeKey] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(typeTitles[typeKey] ?? 'Диалекты'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: words.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          final word = words[index];
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Диалект: ${word['dialect']}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("Литературный: ${word['standard']}",),
                Text("Русский: ${word['russian']}",),
              ],
            ),
          );
        },
      ),
    );
  }
}
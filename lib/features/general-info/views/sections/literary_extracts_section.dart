import 'package:flutter/material.dart';
import '../../widgets/custom_list_tile.dart';

class LiteraryExtractsWidget extends StatelessWidget {
  final List<dynamic> literaryExtracts;

  const LiteraryExtractsWidget({Key? key, required this.literaryExtracts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: literaryExtracts.length,
      itemBuilder: (context, index) {
        final extractData = literaryExtracts[index];
        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ExpansionTile(
            title: Text(extractData['title']),
            children: [
              CustomListTile("Author", extractData['author']),
              CustomListTile("Extract", extractData['extract']),
              CustomListTile("Translation", extractData['translation']),
              ListTile(
                title: const Text("Audio: (Tap to play)"),
                onTap: () {
                  // Implement audio logic
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
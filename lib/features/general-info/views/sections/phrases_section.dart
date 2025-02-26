import 'package:flutter/material.dart';
import '../../widgets/custom_list_tile.dart';

class PhrasesWidget extends StatelessWidget {
  final List<dynamic> phrases;

  const PhrasesWidget({Key? key, required this.phrases}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: phrases.length,
      itemBuilder: (context, index) {
        final phraseData = phrases[index];
        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ExpansionTile(
            backgroundColor: Theme.of(context).cardColor,
            collapsedBackgroundColor: Theme.of(context).cardColor,
            title: Text(phraseData['phrase']),
            children: [
              CustomListTile("Meaning", phraseData['meaning']),
              CustomListTile("Usage", phraseData['usage']),
              CustomListTile("Example", phraseData['example']),
              CustomListTile("When to use", phraseData['whenToUse']),
              CustomListTile("Alternatives", phraseData['alternatives'].join(', ')),
            ],
          ),
        );
      },
    );
  }
}
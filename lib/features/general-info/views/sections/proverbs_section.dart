import 'package:flutter/material.dart';

import '../../widgets/custom_list_tile.dart';

class ProverbsWidget extends StatelessWidget {
  final List<dynamic> proverbs;

  const ProverbsWidget({Key? key, required this.proverbs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: proverbs.length,
      itemBuilder: (context, index) {
        final proverbData = proverbs[index];
        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ExpansionTile(
            title: Text(proverbData['proverb']),
            children: [
              CustomListTile("Meaning", proverbData['meaning']),
              CustomListTile("Literal Meaning", proverbData['literalMeaning']),
              CustomListTile("Example", proverbData['example']),
              CustomListTile("Usage", proverbData['usage']),
              CustomListTile("Related Proverbs", proverbData['relatedProverbs'].join(', ')),
            ],
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';

import '../../widgets/custom_list_tile.dart';

class IdiomsWidget extends StatelessWidget {
  final List<dynamic> idioms;

  const IdiomsWidget({Key? key, required this.idioms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: idioms.length,
      itemBuilder: (context, index) {
        final idiomData = idioms[index];
        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ExpansionTile(
            title: Text(idiomData['idiom']),
            children: [
              CustomListTile("Meaning", idiomData['meaning']),
              CustomListTile("Literal Meaning", idiomData['literalMeaning']),
              CustomListTile("Example", idiomData['example']),
              CustomListTile("Usage", idiomData['usage']),
              CustomListTile("Synonyms", idiomData['synonyms'].join(', ')),
            ],
          ),
        );
      },
    );
  }
}
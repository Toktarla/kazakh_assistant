import 'package:flutter/material.dart';

class RegionalDialectsWidget extends StatelessWidget {
  final Map<String, dynamic> regionalDialects;

  const RegionalDialectsWidget({Key? key, required this.regionalDialects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: regionalDialects.length,
      itemBuilder: (context, regionIndex) {
        final regionName = regionalDialects.keys.toList()[regionIndex];
        final regionData = regionalDialects[regionName];

        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ExpansionTile(
            title: Text(regionName, style: const TextStyle(fontWeight: FontWeight.bold)),
            children: List.generate(regionData.length, (dialectIndex) {
              final dialect = regionData[dialectIndex];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(dialect['dialect'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Word')),
                      DataColumn(label: Text('Dialect Variation')),
                    ],
                    rows: dialect['words'].entries.map<DataRow>((entry) { // Specify the return type <DataRow>
                      return DataRow(cells: [
                        DataCell(Text(entry.key)),
                        DataCell(Text(entry.value)),
                      ]);
                    }).toList() as List<DataRow>, // Explicitly cast to List<DataRow>
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
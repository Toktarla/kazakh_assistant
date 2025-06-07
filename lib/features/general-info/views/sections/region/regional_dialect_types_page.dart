import 'package:flutter/material.dart';
import 'package:proj_management_project/features/general-info/widgets/default_app_bar.dart';
import '../../../../../config/variables.dart';
import 'dialect_words_list_page.dart';

class RegionDialectTypesPage extends StatelessWidget {
  final String regionId;

  const RegionDialectTypesPage({super.key, required this.regionId});

  @override
  Widget build(BuildContext context) {

    final types = dialectTypes;


    return Scaffold(
      appBar: const DefaultAppBar(),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: types.map((type) {

          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DialectWordsListPage(

                  regionId: regionId,
                  typeKey: type['key']!,
                ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).primaryColor),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(type['icon'], size: 36),
                  const SizedBox(height: 12),
                  Text(
                    type['title']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
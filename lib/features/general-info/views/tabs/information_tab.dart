import 'package:flutter/material.dart';
import 'package:proj_management_project/utils/extensions/localized_context_extension.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/di/injection_container.dart';
import '../../../../config/variables.dart';
import '../../../../services/local/app_data_box_manager.dart';
import '../../models/section.dart';
import '../../../../utils/widgets/blob_background.dart';
import '../intermediary_page.dart';

class InformationTab extends StatefulWidget {
  const InformationTab({super.key});

  @override
  State<InformationTab> createState() => _InformationTabState();
}

class _InformationTabState extends State<InformationTab> {
  late List<Section> sections;
  late AppDataBoxManager boxManager;

  @override
  void initState() {
    super.initState();
    boxManager = sl<AppDataBoxManager>();
    sections = boxManager.getAllInformationSections();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColors = isDarkMode ? darkCardColors : lightCardColors;

    return sections.isEmpty
        ? const Center(child: Text('No Information sections available.'))
        : ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sections.length,
      itemBuilder: (context, sectionIndex) {
        final section = sections[sectionIndex];
        final icon = infoIcons[sectionIndex % infoIcons.length];
        final gradientColor = cardColors[sectionIndex % cardColors.length];

        return Container(
          height: 130,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              final contentType = section.contentType;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => IntermediaryPage(contentType: contentType, contentTypeIndex: section.contentTypeIndex!,),
                ),
              );
            },
            child: Row(
              children: [
                Container(
                  width: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                    child: BlobBackground(
                      icon: icon,
                      iconColor: isDarkMode ? AppColors.pinkColor : AppColors.darkBlueColor,
                      leftColor: gradientColor.withOpacity(0.9),
                      rightColor: Colors.deepOrangeAccent.withOpacity(0.6),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.localizedValue(
                            kz: section.titleKz,
                            ru: section.titleRu,
                            en: section.titleEn,
                          ) ?? '',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            context.localizedValue(
                              kz: section.descriptionKz,
                              ru: section.descriptionRu,
                              en: section.descriptionEn,
                            ) ?? '',
                            maxLines: 3,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:proj_management_project/features/general-info/widgets/default_app_bar.dart';
import 'package:proj_management_project/services/local/app_data_box_manager.dart';
import 'package:proj_management_project/utils/extensions/localized_context_extension.dart';
import '../../../../../config/di/injection_container.dart';
import '../../../../../config/variables.dart';
import '../../../../profile/viewmodels/theme_cubit.dart';
import '../../../models/idiom.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../widgets/daily_info_card.dart';
import 'idiom_learning_page.dart';

class IdiomsWidget extends StatefulWidget {
  const IdiomsWidget({Key? key}) : super(key: key);

  @override
  State<IdiomsWidget> createState() => _IdiomsWidgetState();
}

class _IdiomsWidgetState extends State<IdiomsWidget> {
  List<IdiomType> idiomTypes = [];
  late bool isDarkMode;
  final dataBoxManager = sl<AppDataBoxManager>();

  @override
  void initState() {
    super.initState();
    idiomTypes = dataBoxManager.getAllIdiomTypes();
    isDarkMode = sl<ThemeCubit>().isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final colors = isDarkMode ? darkCardColors : lightCardColors;

    return Scaffold(
      appBar: const DefaultAppBar(),
      body: Column(
        children: [
        DailyItemCard<Idiom>(
            title: 'Daily Idiom',
            item: dataBoxManager.getDailyIdiom(),
            getContent: (i) => i.idiom ?? '',
            getMeaning: (i) => i.meaningEn,
            icon: Icons.lightbulb,
            getDetails: (p) => {
              "Usage".tr(): p.usageRu,
              "Example".tr(): p.example,
              "When to Use".tr(): p.whenToUseRu,
              "Meaning".tr(): p.meaningRu,
              "Literal Meaning".tr(): p.literalMeaningRu,
              "Synonyms".tr(): p.synonyms,
            },
            bgColor: Theme.of(context).primaryColorDark,
            iconColor: Theme.of(context).textTheme.titleLarge!.color,
            textColor: Theme.of(context).textTheme.titleLarge!.color,
        ),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: idiomTypes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final type = idiomTypes[index];
                  final idioms = type.idioms;
                  final learnedCount = idioms.where((i) => i.isLearned).length;
                  final percent = idioms.isEmpty ? 0.0 : learnedCount / idioms.length;
                  final bgColor = colors[index % colors.length];

                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => IdiomLearningPage(
                              idioms: type.idioms,
                              title: context.localizedValue(
                                kz: type.typeKz,
                                ru: type.typeRu,
                                en: type.typeEn,
                              ) ?? '',
                            ),
                          ),
                        );
                      },
                      child: _buildIdiomTypeCard(type, percent, bgColor));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdiomTypeCard(IdiomType type, double percent, Color bgColor) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 60,
                lineWidth: 6.0,
                animation: true,
                percent: percent,
                center: CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).cardColor,
                  backgroundImage:
                      NetworkImage(type.imageUrl ?? defaultNoImageUrl),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.deepPurpleAccent,
                backgroundColor: Colors.grey.shade200,
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                      context.localizedValue(
                        kz: type.typeKz,
                        ru: type.typeRu,
                        en: type.typeEn,
                      ) ?? '',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:proj_management_project/features/general-info/views/tabs/exercises_tab.dart';
import 'package:proj_management_project/features/general-info/views/tabs/learn_tab.dart';
import 'package:proj_management_project/features/general-info/views/tabs/information_tab.dart';
import '../../../config/di/injection_container.dart';
import '../../../services/local/app_data_box_manager.dart';
import '../../../utils/widgets/tabbar_background_painter.dart';
import 'favorites_page.dart';

class GeneralInformationPage extends StatefulWidget {
  @override
  _GeneralInformationPageState createState() => _GeneralInformationPageState();
}

class _GeneralInformationPageState extends State<GeneralInformationPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final tabs = [
    Tab(text: "Learn".tr()),
    Tab(text: 'Information'.tr()),
    Tab(text: 'Exercises'.tr()),
  ];

  @override
  void initState() {
    super.initState();
    sl<AppDataBoxManager>().loadFavoriteCount();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: TabBarBackgroundPainter(),
                  ),
                ),
                Center(
                  child: TabBar(
                    controller: _tabController,
                    onTap: (_) => setState(() {}),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.white.withOpacity(0.7),
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: const Color(0xFFFFC107),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tabs: List.generate(tabs.length, (index) {
                      final tabText = tabs[index].text!;
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / tabs.length,
                        height: 50,
                        child: Center(
                          child: Text(
                            tabText,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            softWrap: false,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildFavoritesCard(),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                LearnTab(),
                InformationTab(),
                ExercisesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesCard() {
    // Use ValueListenableBuilder to automatically update the favorites count
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => FavoritesPage()));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.amberAccent.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.white, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: const Text(
                  'View Your Favorites',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ).tr(),
              ),
              // Use ValueListenableBuilder to listen to the favorite count changes
              ValueListenableBuilder<int>(
                valueListenable: sl<AppDataBoxManager>().favoriteCountNotifier,
                builder: (context, allFavoritesCount, _) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      allFavoritesCount.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:proj_management_project/features/general-info/views/exercises_tab.dart';
import 'package:proj_management_project/features/general-info/views/information_tab.dart';

class GeneralInformationPage extends StatefulWidget {
  @override
  _GeneralInformationPageState createState() => _GeneralInformationPageState();
}

class _GeneralInformationPageState extends State<GeneralInformationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kazakh Learning').tr(),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  controller: _tabController,
                  indicator: const BoxDecoration(),
                  unselectedLabelStyle: Theme.of(context).textTheme.titleLarge,
                  labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'Information',),
                    Tab(text: 'Exercises'),
                  ],
                  labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  InformationTab(),
                  ExercisesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart'; // Import salomon_bottom_bar
import 'package:proj_management_project/features/chat/views/chat_history_screen.dart';
import 'package:proj_management_project/features/profile/views/profile_page.dart';
import '../../../services/local/local_notifications_service.dart';
import '../../general-info/views/general_information_page.dart';
import '../../translation/views/translation_page.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    GeneralInformationPage(),
    const TranslationPage(),
    HistoryPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    LocalNotificationService.scheduleDailyMotivationalMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.info),
            title: const Text("General Info").tr(),
            selectedColor: Colors.purple,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.g_translate),
            title: const Text("Translation").tr(),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.chat_outlined),
            title: const Text("AI Chat").tr(),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile").tr(),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
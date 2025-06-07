import 'package:flutter/material.dart';
import 'package:proj_management_project/features/auth/views/auth_screen.dart';
import 'package:proj_management_project/features/auth/views/login_screen.dart';
import 'package:proj_management_project/features/auth/views/register_screen.dart';
import 'package:proj_management_project/features/auth/views/verify_email_screen.dart';
import 'package:proj_management_project/features/chat/views/chat_history_screen.dart';
import 'package:proj_management_project/features/general-info/views/general_information_page.dart';
import 'package:proj_management_project/features/intro/intro_screen.dart';
import 'package:proj_management_project/features/profile/views/language_page.dart';
import 'package:proj_management_project/features/profile/views/manage_account_page.dart';
import 'package:proj_management_project/features/profile/views/profile_page.dart';
import 'package:proj_management_project/utils/error/error_page.dart';
import 'package:proj_management_project/features/home/views/home_page.dart';
import 'package:proj_management_project/features/streak/views/streak_tracker_page.dart';
import '../features/chat/views/chat_screen.dart';
import '../features/intro/app_setup_page.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/Login':
        return _materialRoute(const LoginPage());
      case '/Register':
        return _materialRoute(const RegisterPage());
      case '/VerifyEmail':
        return _materialRoute(const VerifyEmailPage());
      case '/Profile':
        return _materialRoute(const ProfilePage());
      case '/GeneralInformation':
        return _materialRoute(GeneralInformationPage());
      case '/Auth':
        return _materialRoute(const AuthScreen());
      case '/Intro':
        return _materialRoute(const IntroScreen());
      case '/Language':
        return _materialRoute(const LanguagePage());
      case '/Home':
        return _materialRoute(const HomePage());
      case '/Chat':
        final map = settings.arguments as Map<String,dynamic>;
        return _materialRoute(ChatScreen(chatId: map['chatId'],));
      case '/ChatHistory':
        return _materialRoute(HistoryPage());
      case '/ManageAccount':
        return _materialRoute(const ManageAccountPage());
      case '/AppSetUp':
        return _materialRoute(const AppSetUpPage());
      case '/StreakTracker':
        final map = settings.arguments as Map<String,dynamic>;
        return _materialRoute(StreakTracker(userId: map['userId']));
      default:
        return _materialRoute(const ErrorPage());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(
      builder: (_) => view,
    );
  }
}
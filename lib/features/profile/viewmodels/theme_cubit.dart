import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/app_colors.dart';
import '../../../utils/animations/fade_in_transition.dart';

class ThemeCubit extends Cubit<ThemeData> {
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(_darkTheme);

  ThemeData get theme {
    final isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    return isDarkMode ? _darkTheme : _lightTheme;
  }

  static final ThemeData _lightTheme = ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadePageTransitionsBuilder(),
        TargetPlatform.iOS: FadePageTransitionsBuilder(),
      },
    ),
    brightness: Brightness.light,
    primaryColor: AppColors.blueAccentColor,
    drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        shadowColor: Colors.blueAccent
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.pinkColor;
        } else {
          return AppColors.pinkColor;
        }
      }),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.blueAccentColor;
        } else {
          return AppColors.cyanColor;
        }
      }),
      splashRadius: 28.0,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.blueAccentColor,
    ),
    textTheme: GoogleFonts.nunitoTextTheme(const TextTheme(
      titleLarge: TextStyle(fontSize: 18, color: Colors.black),
      titleMedium: TextStyle(fontSize: 14, color: Colors.black),
      displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.blueAccentColor),
      displayMedium: TextStyle(fontSize: 24, color: AppColors.whiteColor, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 16, color: Colors.black),
    )),
    appBarTheme: const AppBarTheme(
      color: AppColors.brightColor,
      elevation: 5,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 20,
        color: Colors.black
      )
    ),
    primaryIconTheme: const IconThemeData(
      color: AppColors.blueAccentColor,
    ),
    cardColor: AppColors.brightColor,
    scaffoldBackgroundColor: Colors.white,
    dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        contentTextStyle: const TextStyle(color: Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      elevation: 10,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey.withValues(alpha: 0.32);
          }
          if (states.contains(WidgetState.selected)) {
            return Colors.blue;
          }
          return null; // Default color
        },
      ),
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
          if (states.contains(WidgetState.focused)) {
            return Colors.blue.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.hovered)) {
            return Colors.blue.withValues(alpha : 0.08);
          }
          return null;
        },
      ),
    ),
    primaryColorLight: AppColors.brightColor,

  );

  static final ThemeData _darkTheme = ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadePageTransitionsBuilder(),
        TargetPlatform.iOS: FadePageTransitionsBuilder(),
      },
    ),
    textTheme: GoogleFonts.nunitoTextTheme(const TextTheme(
      titleLarge: TextStyle(fontSize: 18, color: Colors.white),
      titleMedium: TextStyle(fontSize: 14, color: Colors.white),
      titleSmall: TextStyle(fontSize: 12, color: Colors.white),
      displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.whiteColor),
      displayMedium: TextStyle(fontSize: 24, color: AppColors.whiteColor, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 16, color: AppColors.pinkColor),
    )),
    brightness: Brightness.dark,
    primaryColor: AppColors.blueColor,
    drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.black,
        elevation: 0,
        shadowColor: Colors.black12
    ),
    primaryIconTheme: const IconThemeData(
      color: AppColors.whiteColor,
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      iconColor: AppColors.whiteColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.blueColor,
      unselectedItemColor: AppColors.unSelectedBottomBarColorDark,
      selectedItemColor: AppColors.pinkColor,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.pinkColor,
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      elevation: 1,
      centerTitle: true,
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 20,
          color: AppColors.whiteColor
      )
    ),
    cardColor: AppColors.blackBrightColor,
    scaffoldBackgroundColor: Colors.white10,
    dialogTheme: DialogTheme(
      backgroundColor: Colors.black26,
      contentTextStyle: const TextStyle(color: Colors.grey),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: const TextStyle(color: Colors.white, ),
      elevation: 10,
    ),
    primaryColorLight: AppColors.blackBrightColor,
  );

  Future<void> loadTheme() async {
    final isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    emit(isDarkMode ? _darkTheme : _lightTheme);
  }

  void toggleTheme() {
    final isDarkMode = state.brightness == Brightness.dark;
    _prefs.setBool('isDarkMode', !isDarkMode);
    emit(!isDarkMode ? _darkTheme : _lightTheme);
  }
}
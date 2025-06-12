import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'app_colors.dart';

var pathToFirebaseAdminSdk = dotenv.env['PATH_TO_FIREBASE_ADMIN_SDK'];
var senderId = dotenv.env['SENDER_ID'];
var geminiApiKey = dotenv.env['GEMINI_API_KEY'];

TextStyle kanitStyle = GoogleFonts.kanit();
const defaultUserPhotoUrl = 'https://toppng.com/uploads/preview/instagram-default-profile-picture-11562973083brycehrmyv.png';
const String defaultImagePath = 'https://t4.ftcdn.net/jpg/01/86/29/31/360_F_186293166_P4yk3uXQBDapbDFlR17ivpM6B1ux0fHG.jpg';
const String defaultNoImageUrl = 'https://static.vecteezy.com/system/resources/thumbnails/004/141/669/small_2x/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-coming-soon-sign-simple-nature-silhouette-in-frame-isolated-illustration-vector.jpg';

final List<Color> lightCardColors = [
  Colors.lightBlue[100]!,
  Colors.lightGreen[100]!,
  Colors.pink[100]!,
  Colors.yellow[100]!,
  Colors.cyan[100]!,
  Colors.amber[100]!,
  Colors.teal[100]!,
];

final List<Color> darkCardColors = [
  Colors.blueGrey[800]!,
  AppColors.darkBlueColor,
  Colors.purple[800]!,
  AppColors.unSelectedBottomBarColorLight,
  Colors.blueGrey[800]!,
  AppColors.blackBrightColor,
  Colors.brown[800]!,
];

final List<IconData> learnIcons = [
  Icons.auto_stories,
  Icons.record_voice_over,
  LineIcons.chalkboardTeacher,
  Icons.menu_book,
  Icons.library_books,
  Icons.map,
  Icons.book,
];

final List<IconData> infoIcons = [
  Icons.menu_book,
  Icons.library_books,
  Icons.map,
  Icons.book,
];
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var pathToFirebaseAdminSdk = dotenv.env['PATH_TO_FIREBASE_ADMIN_SDK'];
var senderId = dotenv.env['SENDER_ID'];
var geminiApiKey = dotenv.env['GEMINI_API_KEY'];

TextStyle kanitStyle = GoogleFonts.kanit();
const defaultUserPhotoUrl = 'https://toppng.com/uploads/preview/instagram-default-profile-picture-11562973083brycehrmyv.png';
const String defaultImagePath = 'https://t4.ftcdn.net/jpg/01/86/29/31/360_F_186293166_P4yk3uXQBDapbDFlR17ivpM6B1ux0fHG.jpg';
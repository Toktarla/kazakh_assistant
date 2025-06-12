import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:proj_management_project/config/di/injection_container.dart';
import 'package:proj_management_project/config/load_json_data.dart';
import 'package:proj_management_project/config/routes.dart';
import 'package:proj_management_project/features/auth/providers/authentication_provider.dart';
import 'package:proj_management_project/features/chat/providers/chat_provider.dart';
import 'package:proj_management_project/features/general-info/models/user_level.dart';
import 'package:proj_management_project/services/local/app_data_box_manager.dart';
import 'package:proj_management_project/services/local/internet_checker.dart';
import 'package:proj_management_project/services/local/objectbox.dart';
import 'package:provider/provider.dart';
import 'features/intro/intro_screen.dart' show IntroScreen, shouldShowIntro;
import 'features/profile/viewmodels/theme_cubit.dart';
import 'services/remote/firebase_messaging_service.dart';
import 'config/firebase/firebase_options.dart';
import 'services/local/local_notifications_service.dart';
import 'utils/helpers/snackbar_helper.dart';
import 'package:device_preview/device_preview.dart';

late ObjectBox objectbox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();
  objectbox = await ObjectBox.create();
  await setupServiceLocator();
  InternetChecker().initialize();

  final firebaseMessagingService = sl<FirebaseMessagingService>();
  firebaseMessagingService.initialize();
  LocalNotificationService.initialize();

  await dotenv.load(fileName: ".env");

  bool hasSeenIntro = shouldShowIntro();

  runApp(
      EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('kk')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp(hasSeenIntro: false))
  );
}



class MyApp extends StatelessWidget {
  final bool hasSeenIntro;
  const MyApp({super.key, required this.hasSeenIntro});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
            create: (_) =>
            sl()..loadTheme(),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthenticationProvider(sl(), sl(), sl(), sl())),
          ChangeNotifierProvider(create: (_) => ChatProvider(sl(), sl())),
        ],
        child: BlocBuilder<ThemeCubit, ThemeData>(
          builder: (context, state) {
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              builder: DevicePreview.appBuilder,
              theme: state,
              debugShowCheckedModeBanner: false,
              onGenerateRoute: AppRoutes.onGenerateRoutes,
              title: 'KazSpark',
              initialRoute:  hasSeenIntro ? "/Auth" : "/Intro",
              scaffoldMessengerKey: SnackbarHelper.scaffoldMessengerKey,
            );
          },
        ),
      ),
    );
  }
}

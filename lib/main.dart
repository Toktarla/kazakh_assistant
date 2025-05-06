import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:proj_management_project/config/di/injection_container.dart';
import 'package:proj_management_project/config/routes.dart';
import 'package:proj_management_project/features/auth/providers/authentication_provider.dart';
import 'package:proj_management_project/features/auth/views/register_screen.dart';
import 'package:proj_management_project/features/chat/providers/chat_provider.dart';
import 'package:proj_management_project/features/general-info/views/general_information_page.dart';
import 'package:proj_management_project/features/general-info/views/sections/literature_recommendations_section.dart';
import 'package:proj_management_project/features/home/views/home_page.dart';
import 'package:provider/provider.dart';
import 'features/general-info/views/sections/region/interactive_map.dart';
import 'features/intro/intro_screen.dart' show IntroScreen, shouldShowIntro;
import 'features/profile/viewmodels/theme_cubit.dart';
import 'services/remote/firebase_messaging_service.dart';
import 'config/firebase/firebase_options.dart';
import 'services/local/local_notifications_service.dart';
import 'utils/helpers/snackbar_helper.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  await EasyLocalization.ensureInitialized();
  await setupServiceLocator();

  // final firebaseMessagingService = sl<FirebaseMessagingService>();
  // LocalNotificationService.initialize();
  // firebaseMessagingService.initialize();

  await dotenv.load(fileName: ".env");
  bool hasSeenIntro = await shouldShowIntro();
  runApp(
      EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('kk')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: DevicePreview(
        enabled: false,
        builder: (context) => MyApp(hasSeenIntro: hasSeenIntro)
      ))
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
            sl()..loadTheme()
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthenticationProvider(sl(), sl(), sl(), sl())),
          ChangeNotifierProvider(create: (_) => ChatProvider(sl())),
        ],
        child: BlocBuilder<ThemeCubit, ThemeData>(
          builder: (context, state) {
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              builder: DevicePreview.appBuilder,
              useInheritedMediaQuery: true,
              theme: state,
              debugShowCheckedModeBanner: false,
              onGenerateRoute: AppRoutes.onGenerateRoutes,
              title: 'KazSpark',
              home: MapPage(),
              // initialRoute:  hasSeenIntro ? "/Auth" : "/Intro"
              scaffoldMessengerKey: SnackbarHelper.scaffoldMessengerKey,
            );
          },
        ),
      ),
    );
  }
}

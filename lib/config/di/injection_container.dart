import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proj_management_project/features/auth/providers/authentication_provider.dart';
import 'package:proj_management_project/features/auth/repositories/authentication_repository.dart';
import 'package:proj_management_project/features/chat/providers/chat_provider.dart';
import 'package:proj_management_project/features/chat/repositories/chat_repository.dart';
import 'package:proj_management_project/main.dart';
import 'package:proj_management_project/services/local/app_data_box_manager.dart';
import 'package:proj_management_project/services/local/ranking_service.dart';
import 'package:proj_management_project/services/remote/authentication_service.dart';
import 'package:proj_management_project/services/remote/firestore_service.dart';
import 'package:proj_management_project/services/remote/firebase_messaging_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/profile/viewmodels/theme_cubit.dart';
import '../../services/remote/kazakh_learning_api.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final store = objectbox.store;
  final AppDataBoxManager appDataBoxManager = AppDataBoxManager(store, prefs);
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Local Storage
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerSingleton<AppDataBoxManager>(appDataBoxManager);
  sl.registerSingleton<GoogleSignIn>(googleSignIn);

  // Register Firebase instances
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
  sl.registerLazySingleton<KazakhLearningApi>(() => KazakhLearningApi());

  // Register services
  sl.registerLazySingleton<RankingService>(() => RankingService());
  sl.registerLazySingleton<FirestoreService>(() => FirestoreService(sl(),sl()));
  sl.registerLazySingleton<FirebaseMessagingService>(() => FirebaseMessagingService(sl(),sl<FirestoreService>()));
  sl.registerLazySingleton<AuthenticationService>(() => AuthenticationService(sl()));

  // Register repositories
  sl.registerLazySingleton<ChatRepository>(() => ChatRepository(sl(),sl()));
  sl.registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepository(sl<AuthenticationService>(), sl<FirestoreService>()));

  sl.registerFactory<ChatProvider>(() => ChatProvider(sl(), sl()));
  sl.registerFactory<AuthenticationProvider>(() => AuthenticationProvider(sl(), sl(), sl(), sl()));
  sl.registerFactory<ThemeCubit>(() => ThemeCubit(sl()));
}

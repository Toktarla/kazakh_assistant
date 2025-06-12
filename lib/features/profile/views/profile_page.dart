import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:proj_management_project/features/profile/widgets/custom_chevron_icon.dart';
import 'package:proj_management_project/utils/helpers/snackbar_helper.dart';
import 'package:proj_management_project/utils/widgets/near_regular_hexagon_painter.dart';
import '../../../config/di/injection_container.dart';
import '../../../config/variables.dart';
import '../../../services/local/local_notifications_service.dart';
import '../../../services/local/ranking_service.dart';
import '../../../utils/helpers/delete_confirmation_dialog.dart';
import '../viewmodels/theme_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  int _userLevel = 1;
  late final List<String> exerciseTypes;
  late LevelData levelData;
  double _levelProgress = 0.0;
  late LevelData _nextLevelData;
  final firestore = sl<RankingService>();

  @override
  void initState() {
    super.initState();
    _loadLevel();
    _loadProgress();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Now it's safe to access inherited widgets like EasyLocalization and Theme
    levelData = RankingService.getLevelData(context, _userLevel);
    _nextLevelData = RankingService.getLevelData(context, _userLevel + 1);
  }

  Future<void> _loadLevel() async {
    _userLevel = await RankingService.getCurrentUserLevel();
    setState(() {
      levelData = RankingService.getLevelData(context, _userLevel);
      _nextLevelData = RankingService.getLevelData(context, _userLevel + 1);
    });
  }

  Future<void> _loadProgress() async {
    _levelProgress = await RankingService.getUserLevelProgress();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
        ).tr(),
        elevation: 5,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account',
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ).tr(),
                      const SizedBox(height: 10),
                      ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(user?.photoURL ?? defaultImagePath), radius: 25,).animate().fadeIn(duration: 500.ms),
                        title: Text(user?.isAnonymous ?? false ? "Guest".tr() : user?.displayName ?? "No Display Name".tr()),
                        subtitle: Text(user?.isAnonymous ?? false ? "No Email".tr() : user?.email ?? "No Display Name".tr()),
                        trailing: const CustomChevronIcon(),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                double localProgress = _levelProgress;
                                int localLevel = _userLevel;

                                return StatefulBuilder(
                                  builder: (context, setDialogState) {
                                    final levelData = RankingService.getLevelData(context, localLevel);

                                    return AlertDialog(
                                      backgroundColor: Theme.of(context).cardColor,
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                LinearProgressIndicator(
                                                  value: localProgress,
                                                  minHeight: 15,
                                                  backgroundColor: levelData.color.withOpacity(0.3),
                                                  valueColor: AlwaysStoppedAnimation<Color>(levelData.color),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("LVL: $localLevel", style: const TextStyle(color: Colors.black)),
                                                    Text("LVL: ${localLevel + 1}", style: const TextStyle(color: Colors.black)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            CustomPaint(
                                              painter: NearRegularHexagonPainter(levelData.color),
                                              child: SizedBox(
                                                width: 150,
                                                height: 150,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("RANK", style: Theme.of(context).textTheme.titleMedium).tr(),
                                                      Text(
                                                        localLevel.toString(),
                                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 36),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(levelData.title, style: Theme.of(context).textTheme.displayLarge),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Flexible(
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      await RankingService.addProgress(10); // +10 EXP
                                                      final level = await RankingService.getCurrentUserLevel();
                                                      final progress = await RankingService.getUserLevelProgress();

                                                      setState(() {
                                                        _userLevel = level;
                                                        _levelProgress = progress;
                                                      });
                                                      setDialogState(() {
                                                        localLevel = level;
                                                        localProgress = progress;
                                                      });
                                                    },
                                                    child: Text("Add EXP", style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      await RankingService.addProgress(-10); // -10 EXP
                                                      final level = await RankingService.getCurrentUserLevel();
                                                      final progress = await RankingService.getUserLevelProgress();

                                                      setState(() {
                                                        _userLevel = level;
                                                        _levelProgress = progress;
                                                      });
                                                      setDialogState(() {
                                                        localLevel = level;
                                                        localProgress = progress;
                                                      });
                                                    },
                                                    child: Text("Decrease EXP", style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }
                      ),
                      ListTile(
                        leading: const Icon(Icons.lock_outline),
                        title: const Text('Password and Security').tr(),
                        subtitle: const Text('Edit Credentials').tr(),
                        trailing: const CustomChevronIcon(),
                        onTap: () {
                          Navigator.pushNamed(context, '/ManageAccount');
                        },
                      ),
                      ListTile(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteConfirmationDialog(
                                onDelete: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacementNamed(context, '/Login');
                                },
                              );
                            },
                          );
                        },
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text(
                          'Sign Out',
                        ).tr(),
                        subtitle: const Text(
                          'Log out from your account',
                        ).tr(),
                        trailing: const CustomChevronIcon(),
                      ),
                    ],
                  ),
                ),
                // Settings Container
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ).tr(),
                      const SizedBox(height: 10),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: const Text('Language').tr(),
                        trailing: const CustomChevronIcon(),
                        onTap: () {
                          Navigator.pushNamed(context, '/Language');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.notifications),
                        title: const Text('Notification Settings').tr(),
                        trailing: const CustomChevronIcon(),
                        onTap: () async {
                          TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget? child) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              );
                            },
                          );

                          if (selectedTime != null) {
                            LocalNotificationService.scheduleDailyMotivationalMessage(
                              hour: selectedTime.hour,
                              minute: selectedTime.minute,
                              localeCode: context.locale.languageCode,
                            );
                            SnackbarHelper.showSuccessSnackbar(message: 'NotificationTime'.tr(args: [selectedTime.format(context)]));
                          }
                        },
                      ),
                      ListTile(
                        leading: context.read<ThemeCubit>().state.brightness == Brightness.light
                            ? const Icon(Icons.light_mode_rounded)
                            : const Icon(Icons.dark_mode_rounded),
                        title: const Text('Dark Theme').tr(),
                        trailing: CupertinoSwitch(
                          value: context.read<ThemeCubit>().state.brightness == Brightness.dark,
                          onChanged: (value) {
                            context.read<ThemeCubit>().toggleTheme();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
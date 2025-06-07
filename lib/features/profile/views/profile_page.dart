import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:proj_management_project/features/profile/widgets/custom_chevron_icon.dart';
import 'package:proj_management_project/utils/helpers/snackbar_helper.dart';
import '../../../config/variables.dart';
import '../../../services/local/local_notifications_service.dart';
import '../../../utils/helpers/delete_confirmation_dialog.dart';
import '../viewmodels/theme_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? userId = user?.uid;

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
                        title: Text(user!.isAnonymous ? "Guest".tr() : user.displayName ?? "No Display Name".tr()),
                        subtitle: Text(user.isAnonymous ? "No Email".tr() : user.email ?? "No Display Name".tr()),
                        trailing: const CustomChevronIcon(),
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
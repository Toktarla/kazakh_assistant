import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:proj_management_project/main.dart';
import '../../config/di/injection_container.dart';
import '../../config/load_json_data.dart';
import '../../services/local/app_data_box_manager.dart';
import '../general-info/models/user_level.dart';

class AppSetUpPage extends StatefulWidget {
  const AppSetUpPage({super.key});

  @override
  State<AppSetUpPage> createState() => _AppSetUpPageState();
}

class _AppSetUpPageState extends State<AppSetUpPage> {
  UserLevel? _selectedLevel;
  bool _isLoading = false;
  int _progressPercent = 0; // from 0 to 100

  Future<void> _startSetup() async {
    setState(() {
      _isLoading = true;
      _progressPercent = 0;
    });

    try {
      final appDataManager = sl<AppDataBoxManager>();
      appDataManager.updateFavoriteCount(0);

      appDataManager.setUserLevel(_selectedLevel!);
      setState(() => _progressPercent = 20);
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() => _progressPercent = 25);
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() => _progressPercent = 30);

      await seedAppDataIfNeeded(objectbox.store);
      setState(() => _progressPercent = 95);

      await Future.delayed(const Duration(milliseconds: 400));
      setState(() => _progressPercent = 100);

      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/Auth');
      }
    } catch (e) {
      debugPrint('Setup failed: $e');
      setState(() {
        _isLoading = false;
        _progressPercent = 0;
      });
      // Optional: show error dialog here
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _isLoading
              ? Column(
            key: const ValueKey('loading'),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/setup.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Text(
                'Setting things up for you...',
                style: theme.textTheme.titleMedium,
              ).tr(),
              const SizedBox(height: 10),
              Text(
                'Please wait while we configure your preferences.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ).tr(),
              const SizedBox(height: 30),
              // Show progress bar with percentage
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: LinearProgressIndicator(
                  value: _progressPercent / 100,
                  color: theme.primaryColor,
                  backgroundColor: theme.primaryColor.withOpacity(0.3),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '$_progressPercent% done',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.primaryColor,
                ),
              ),
            ],
          )
              : Padding(
            key: const ValueKey('selector'),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GlassCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/lottie/setup.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    'Choose your Kazakh language level',
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ).tr(),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: UserLevel.values.map((level) {
                      final isSelected = _selectedLevel == level;

                      // Define icon and color per level
                      late final IconData icon;
                      late final Color color;

                      switch (level) {
                        case UserLevel.Beginner:
                          icon = LucideIcons.bookOpen;
                          color = Colors.green;
                          break;
                        case UserLevel.Intermediate:
                          icon = LucideIcons.trendingUp;
                          color = Colors.orangeAccent;
                          break;
                        case UserLevel.Native:
                          icon = LucideIcons.award;
                          color = Colors.redAccent;
                          break;
                      }

                      return ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icon,
                              size: 18,
                              color: isSelected ? Colors.white : color,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              level.levelName,
                              style: TextStyle(
                                color: isSelected ? Colors.white : color,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ).tr(),
                          ],
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => _selectedLevel = level);
                        },
                        selectedColor: color,
                        backgroundColor: color.withOpacity(0.2),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _selectedLevel == null ? null : _startSetup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: Theme.of(context).textTheme.titleLarge,
                    ).tr(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class GlassCard extends StatelessWidget {
  final Widget child;

  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.shade200.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 4,
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: child,
    );
  }
}

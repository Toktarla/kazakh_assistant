import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'package:proj_management_project/config/di/injection_container.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../services/local/app_data_box_manager.dart';
import '../../intro/intro_screen.dart';

class StreakTracker extends StatefulWidget {
  final String userId;

  const StreakTracker({super.key, required this.userId});

  @override
  State<StreakTracker> createState() => _StreakTrackerState();
}

class _StreakTrackerState extends State<StreakTracker> with SingleTickerProviderStateMixin {
  late final AppDataBoxManager _appDataManager;
  late AnimationController _animationController;
  late ConfettiController _confettiController;

  // Calendar and streak state
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late int _streakCount;
  late Set<DateTime> _activityDays;
  late bool _isStreakLost;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Animation states
  bool _showCalendar = false;
  bool _isLoading = true;

  late bool hasSeenIntro;

  @override
  void initState() {
    super.initState();
    _appDataManager = sl<AppDataBoxManager>();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    hasSeenIntro =  shouldShowIntro();
    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _initializeStreakData();
  }

  Future<void> _initializeStreakData() async {
    // Get streak data from AppDataBoxManager
    final streakData = await _appDataManager.getStreakData(widget.userId);
    final activityData = await _appDataManager.getUserActivityDays(widget.userId);

    setState(() {
      _streakCount = streakData['streakCount'] ?? 0;
      _isStreakLost = streakData['isStreakLost'] ?? false;
      _activityDays = activityData.map((date) => DateUtils.dateOnly(date)).toSet();
      _isLoading = false;
    });

    // Update streak on new day visit
    await _appDataManager.updateStreak(widget.userId);

    // If user has a streak of 7 or more, show confetti
    if (_streakCount >= 7 && !_isStreakLost) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _confettiController.play();
      });
    }

    // Show calendar with animation after data is loaded
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _showCalendar = true;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  // Calendar day builder
  Widget _buildCalendarDay(BuildContext context, DateTime day, DateTime focusedDay) {
    final bool isToday = isSameDay(day, DateTime.now());
    final bool isSelected = isSameDay(day, _selectedDay);
    final bool isActivityDay = _activityDays.contains(DateUtils.dateOnly(day));

    // Check if day is in the current month
    final bool isInCurrentMonth = day.month == focusedDay.month;

    // Day container design
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).primaryColor
            : isActivityDay && isInCurrentMonth
            ? Colors.deepPurple.shade100
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isToday
            ? Border.all(color: Theme.of(context).primaryColor, width: 2)
            : null,
        boxShadow: isSelected
            ? [BoxShadow(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
          blurRadius: 4,
          offset: const Offset(0, 2),
        )]
            : null,
      ),
      child: Center(
        child: Text(
          day.day.toString(),
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : isActivityDay && isInCurrentMonth
                ? Colors.deepPurple.shade800
                : isInCurrentMonth
                ? Colors.black87
                : Colors.grey.withValues(alpha: 0.4),
            fontWeight: isToday || isSelected || isActivityDay ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }

  Widget buildStreakMessage({required int streakCount, required bool isStreakLost, required bool isFirstLaunch, TextStyle? textStyle}) {
    if (streakCount == 0) {
      if (isStreakLost) {
        return Text("StreakLost".tr(args: [streakCount.toString()]) , style: textStyle, textAlign: TextAlign.center);
      } else if (isFirstLaunch) {
        return Text("StreakOnFire", style: textStyle, textAlign: TextAlign.center).tr();
      }
    }
    return Text("CurrentStreak".tr(args: [streakCount.toString()]), style: textStyle, textAlign: TextAlign.center,);
  }


  Widget _buildStreakSection() {
    final streakIcon = _isStreakLost
        ? 'assets/lottie/sad.json'
        : _streakCount >= 7
        ? 'assets/lottie/fire.json'
        : 'assets/lottie/fire.json';

    final streakDescription = _isStreakLost
        ? 'StreakLostMessage'.tr()
        : _streakCount >= 7
        ? 'StreakOnFire'.tr()
        : 'KeepGoing'.tr();

    return Column(
      children: [
        // Confetti controller for milestones
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -pi / 2, // Straight up
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            maxBlastForce: 20,
            minBlastForce: 10,
            gravity: 0.1,
            particleDrag: 0.05,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
              Colors.green,
            ],
          ),
        ),

        // Streak animation and counter
        SizedBox(
          height: 120,
          width: 120,
          child: _isStreakLost
              ? FadeIn(
            duration: const Duration(milliseconds: 800),
            child: Lottie.asset(
              streakIcon,
              repeat: true,
            ),
          )
              : Lottie.asset(
                streakIcon,
                repeat: true,
              ),
        ),

        // Streak counter text
        FadeInUp(
          from: 10,
          duration: const Duration(milliseconds: 600),
          child: buildStreakMessage(
            streakCount: _streakCount,
            isStreakLost: _isStreakLost,
            isFirstLaunch: hasSeenIntro,
            textStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: _isStreakLost
                  ? Colors.grey.shade700
                  : Colors.deepPurple.shade800,
            ),
          )
        ),

        const SizedBox(height: 8),

        // Streak description
        FadeInUp(
          from: 10,
          delay: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 600),
          child: Text(
            streakDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Streak day circles for visual indicator
        _buildStreakCircles(),
      ],
    );
  }

  Widget _buildStreakCircles() {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        days.length,
            (index) {
          final isActive = index < (_isStreakLost ? 0 : _streakCount % 7);
          final bool isToday = index == DateTime.now().weekday - 1;

          return FadeInUp(
            duration: Duration(milliseconds: 400 + (index * 50)),
            from: 20,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.deepPurple.shade600
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
                border: isToday
                    ? Border.all(color: Colors.deepPurple.shade800, width: 2)
                    : null,
                boxShadow: isActive
                    ? [BoxShadow(
                  color: Colors.deepPurple.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )]
                    : null,
              ),
              child: Center(
                child: Text(
                  days[index],
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        )
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              spacing: 24,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'YourProgressTracker'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 48), // For alignment
                  ],
                ),
                // Streak Section
                _buildStreakSection(),

                // Continue Button
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  duration: const Duration(milliseconds: 800),
                  from: 20,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      elevation: 5,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/Home', arguments: {
                        'userId': widget.userId
                      });
                    },
                    child: Text(
                      'Continue'.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Calendar Section Title
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  from: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ActivityCalendar'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple.shade800,
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Text(
                          '${_activityDays.length} ${'DaysActive'.tr()}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Calendar with animation
                if (_showCalendar)
                  FadeIn(
                    duration: const Duration(milliseconds: 800),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadowColor: Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TableCalendar(
                          firstDay: DateTime.utc(2023, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: _buildCalendarDay,
                            todayBuilder: _buildCalendarDay,
                            selectedBuilder: _buildCalendarDay,
                          ),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          onFormatChanged: (format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                          calendarStyle: CalendarStyle(
                            outsideDaysVisible: true,
                            markersAnchor: 0.7,
                            markerDecoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            weekendTextStyle: Theme.of(context).textTheme.displayMedium!,
                            disabledTextStyle: Theme.of(context).textTheme.displayMedium!,
                            defaultTextStyle: Theme.of(context).textTheme.displayMedium!,
                            holidayTextStyle: Theme.of(context).textTheme.displayMedium!,
                            selectedTextStyle: Theme.of(context).textTheme.displayMedium!,
                            weekNumberTextStyle: Theme.of(context).textTheme.displayMedium!,
                            todayTextStyle: Theme.of(context).textTheme.displayMedium!,
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: Theme.of(context).textTheme.displaySmall!,
                            weekendStyle: Theme.of(context).textTheme.displaySmall!
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonVisible: true,
                            titleCentered: true,
                            formatButtonShowsNext: false,
                            formatButtonDecoration: BoxDecoration(
                              color: Colors.deepPurple.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            formatButtonTextStyle: TextStyle(
                              color: Colors.deepPurple.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                            titleTextStyle: TextStyle(
                              color: Colors.deepPurple.shade800,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            leftChevronIcon: Icon(
                              Icons.chevron_left,
                              color: Colors.deepPurple.shade800,
                            ),
                            rightChevronIcon: Icon(
                              Icons.chevron_right,
                              color: Colors.deepPurple.shade800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Stats at the bottom
                if (_showCalendar)
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    duration: const Duration(milliseconds: 800),
                    from: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard(
                          'CurrentStreakText'.tr(),
                          '$_streakCount ${'Days'.tr()}',
                          Icons.local_fire_department,
                          Colors.orange,
                        ),
                        _buildStatCard(
                          'BestStreak'.tr(),
                          '${_appDataManager.getBestStreak(widget.userId)} ${'Days'.tr()}',
                          Icons.emoji_events,
                          Colors.amber,
                        ),
                        _buildStatCard(
                          'ThisMonth'.tr(),
                          '${_getThisMonthActivityCount()} ${'Days'.tr()}',
                          Icons.calendar_month,
                          Colors.blue,
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

  // Helper method to get this month's activity count
  int _getThisMonthActivityCount() {
    final now = DateTime.now();
    return _activityDays
        .where((date) => date.month == now.month && date.year == now.year)
        .length;
  }

  // Stat card widget
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
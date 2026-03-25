import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/ramadan.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/services/prayer_times_service.dart';
import 'package:mess_manager/features/ramadan/providers/ramadan_provider.dart';

/// Ramadan Calendar Screen - Shows month view with prayer times and meal status
class RamadanCalendarScreen extends ConsumerStatefulWidget {
  const RamadanCalendarScreen({super.key});

  @override
  ConsumerState<RamadanCalendarScreen> createState() =>
      _RamadanCalendarScreenState();
}

class _RamadanCalendarScreenState extends ConsumerState<RamadanCalendarScreen> {
  String _selectedDistrict = 'Dhaka';
  DateTime _currentMonth = DateTime.now();
  final Map<String, PrayerTimes?> _prayerTimesCache = {};
  bool _isLoadingTimes = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final season = ref.read(activeRamadanSeasonProvider);
    if (season != null) {
      _currentMonth = DateTime(season.startDate.year, season.startDate.month);
    }
    _loadMonthPrayerTimes();
  }

  /// Load prayer times for each day in the current month
  Future<void> _loadMonthPrayerTimes() async {
    setState(() => _isLoadingTimes = true);
    final season = ref.read(activeRamadanSeasonProvider);
    if (season == null) {
      setState(() => _isLoadingTimes = false);
      return;
    }

    // Get all days in the current month that fall within Ramadan
    final daysInMonth = _getDaysInMonth(_currentMonth, season);

    for (final day in daysInMonth) {
      final key = _dateKey(day);
      if (!_prayerTimesCache.containsKey(key)) {
        final times = await PrayerTimesService.getTimesForDistrict(
          district: _selectedDistrict,
          date: day,
        );
        if (mounted) {
          setState(() => _prayerTimesCache[key] = times);
        }
      }
    }

    if (mounted) {
      setState(() => _isLoadingTimes = false);
    }
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month}-${date.day}-$_selectedDistrict';

  List<DateTime> _getDaysInMonth(DateTime month, RamadanSeason season) {
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final lastOfMonth = DateTime(month.year, month.month + 1, 0);

    // Clamp to Ramadan season bounds
    final start = firstOfMonth.isBefore(season.startDate)
        ? season.startDate
        : firstOfMonth;
    final end = lastOfMonth.isAfter(season.endDate)
        ? season.endDate
        : lastOfMonth;

    final days = <DateTime>[];
    var current = start;
    while (!current.isAfter(end)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final season = ref.watch(activeRamadanSeasonProvider);
    final meals = ref.watch(ramadanMealsProvider);

    if (season == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0E1A),
        body: Stack(
          children: [
            // Background gradient
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF0A0E1A), Color(0xFF0D1520)],
                  ),
                ),
              ),
            ),
            // Breathing accent orb top-right
            Positioned(
              top: -60,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.15),
                      AppColors.primary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scaleXY(begin: 0.8, end: 1.2, duration: 4000.ms),
            ),
            // Breathing accent orb bottom-left
            Positioned(
              bottom: -80,
              left: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.1),
                      AppColors.primary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scaleXY(begin: 1.0, end: 1.3, duration: 5000.ms),
            ),
            // Content
            SafeArea(
              child: Column(
                children: [
                  // Custom header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            HapticService.navigation();
                            context.pop();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: AppSpacing.accentCard(accent: AppColors.accent, radius: 12),
                            child: Icon(
                              LucideIcons.arrowLeft,
                              size: 18,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                        const Gap(12),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.4),
                                AppColors.primary.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                          child: const Icon(
                            LucideIcons.calendar,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                        const Gap(10),
                        Text(
                          'Ramadan Calendar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Empty state
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.calendarX,
                            size: 64,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          const Gap(16),
                          Text(
                            'No Active Ramadan Season',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(8),
                          Text(
                            'Create a season first',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A0E1A), Color(0xFF0D1520)],
                ),
              ),
            ),
          ),
          // Breathing accent orb top-right
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.8, end: 1.2, duration: 4000.ms),
          ),
          // Breathing accent orb bottom-left
          Positioned(
            bottom: -80,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.3, duration: 5000.ms),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Custom header row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () {
                          HapticService.navigation();
                          context.pop();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                          child: Icon(
                            LucideIcons.arrowLeft,
                            size: 18,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                      const Gap(12),
                      // Gradient halo icon
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.primary.withValues(alpha: 0.4),
                              AppColors.primary.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                        child: const Icon(
                          LucideIcons.calendar,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      const Gap(10),
                      // Title
                      Expanded(
                        child: Text(
                          'Ramadan Calendar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                      // District selector
                      PopupMenuButton<String>(
                        initialValue: _selectedDistrict,
                        onSelected: (district) {
                          HapticService.selectionTick();
                          setState(() {
                            _selectedDistrict = district;
                            _prayerTimesCache.clear();
                          });
                          _loadMonthPrayerTimes();
                        },
                        itemBuilder: (context) {
                          return PrayerTimesService.getAvailableDistricts()
                              .map(
                                (d) => PopupMenuItem(
                                  value: d,
                                  child: Text(d),
                                ),
                              )
                              .toList();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    LucideIcons.mapPin,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                  const Gap(4),
                                  Text(
                                    _selectedDistrict,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Month navigation header
                _buildMonthHeader(season),
                // Loading indicator
                if (_isLoadingTimes)
                  LinearProgressIndicator(
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                // Calendar grid
                Expanded(child: _buildCalendarGrid(season, meals)),
                // Selected date details
                if (_selectedDate != null)
                  _buildSelectedDateDetails(season, meals),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(RamadanSeason season) {
    final canGoPrev = _currentMonth.isAfter(
      DateTime(season.startDate.year, season.startDate.month),
    );
    final canGoNext = _currentMonth.isBefore(
      DateTime(season.endDate.year, season.endDate.month),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: AppSpacing.accentCard(accent: AppColors.accent, radius: 14),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    LucideIcons.chevronLeft,
                    size: 20,
                    color: canGoPrev
                        ? Colors.white.withValues(alpha: 0.9)
                        : Colors.white.withValues(alpha: 0.15),
                  ),
                  onPressed: canGoPrev
                      ? () {
                          HapticService.lightTap();
                          setState(() {
                            _currentMonth = DateTime(
                              _currentMonth.year,
                              _currentMonth.month - 1,
                            );
                          });
                          _loadMonthPrayerTimes();
                        }
                      : null,
                ),
                Expanded(
                  child: Text(
                    _getMonthName(_currentMonth),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    LucideIcons.chevronRight,
                    size: 20,
                    color: canGoNext
                        ? Colors.white.withValues(alpha: 0.9)
                        : Colors.white.withValues(alpha: 0.15),
                  ),
                  onPressed: canGoNext
                      ? () {
                          HapticService.lightTap();
                          setState(() {
                            _currentMonth = DateTime(
                              _currentMonth.year,
                              _currentMonth.month + 1,
                            );
                          });
                          _loadMonthPrayerTimes();
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn();
  }

  String _getMonthName(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  Widget _buildCalendarGrid(RamadanSeason season, List<RamadanMeal> meals) {
    final daysInMonth = _getDaysInMonth(_currentMonth, season);
    if (daysInMonth.isEmpty) {
      return Center(
        child: Text(
          'No Ramadan days in this month',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Weekday headers
          Row(
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const Gap(8),
          // Calendar days grid
          _buildDaysGrid(daysInMonth, season, meals),
        ],
      ),
    );
  }

  Widget _buildDaysGrid(
    List<DateTime> ramadanDays,
    RamadanSeason season,
    List<RamadanMeal> meals,
  ) {
    // Build full month grid with empty cells for non-Ramadan days
    final firstOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    );
    final startWeekday = firstOfMonth.weekday % 7; // 0 = Sunday

    final List<Widget> dayWidgets = [];

    // Add empty cells for days before the month starts
    for (var i = 0; i < startWeekday; i++) {
      dayWidgets.add(const SizedBox.shrink());
    }

    // Add all days of the month
    for (var day = 1; day <= lastOfMonth.day; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isInRamadan = ramadanDays.any(
        (d) =>
            d.year == date.year && d.month == date.month && d.day == date.day,
      );

      if (isInRamadan) {
        dayWidgets.add(_buildDayCell(date, season, meals));
      } else {
        // Non-Ramadan day (very faint)
        dayWidgets.add(
          Container(
            margin: const EdgeInsets.all(2),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
          ),
        );
      }
    }

    // Build rows of 7 days
    final rows = <Widget>[];
    for (var i = 0; i < dayWidgets.length; i += 7) {
      final rowChildren = dayWidgets.sublist(
        i,
        (i + 7).clamp(0, dayWidgets.length),
      );
      // Pad row to 7 items if needed
      while (rowChildren.length < 7) {
        rowChildren.add(const SizedBox.shrink());
      }
      rows.add(
        Row(children: rowChildren.map((w) => Expanded(child: w)).toList()),
      );
    }

    return Column(children: rows);
  }

  Widget _buildDayCell(
    DateTime date,
    RamadanSeason season,
    List<RamadanMeal> meals,
  ) {
    final isToday = _isSameDay(date, DateTime.now());
    final isSelected =
        _selectedDate != null && _isSameDay(date, _selectedDate!);
    final dayMeals = meals.where(
      (m) => m.seasonId == season.id && _isSameDay(m.date, date),
    );
    final hasSehri = dayMeals.any((m) => m.type == RamadanMealType.sehri);
    final hasIftar = dayMeals.any((m) => m.type == RamadanMealType.iftar);

    final prayerTimes = _prayerTimesCache[_dateKey(date)];

    return GestureDetector(
      onTap: () {
        HapticService.selectionTick();
        setState(() => _selectedDate = date);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : isToday
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.06),
            width: isSelected || isToday ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 12,
                    spreadRadius: -2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Day number
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? AppColors.primary
                    : Colors.white.withValues(alpha: 0.9),
              ),
            ),
            const Gap(2),
            // Meal status indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasSehri)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.info,
                      shape: BoxShape.circle,
                    ),
                  ),
                if (hasSehri && hasIftar) const Gap(2),
                if (hasIftar)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      shape: BoxShape.circle,
                    ),
                  ),
                if (!hasSehri && !hasIftar)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            // Prayer times (compact)
            if (prayerTimes != null) ...[
              const Gap(2),
              Text(
                prayerTimes.sehriEnd.split(' ').first,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.info.withValues(alpha: 0.8),
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(delay: (date.day * 20).ms);
  }

  Widget _buildSelectedDateDetails(
    RamadanSeason season,
    List<RamadanMeal> meals,
  ) {
    if (_selectedDate == null) return const SizedBox.shrink();

    final dayMeals = meals
        .where(
          (m) => m.seasonId == season.id && _isSameDay(m.date, _selectedDate!),
        )
        .toList();
    final prayerTimes = _prayerTimesCache[_dateKey(_selectedDate!)];
    final hasSehri = dayMeals.any((m) => m.type == RamadanMealType.sehri);
    final hasIftar = dayMeals.any((m) => m.type == RamadanMealType.iftar);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.08),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(
              top: BorderSide(
                color: AppColors.accent.withValues(alpha: 0.18),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date header
              Row(
                children: [
                  const Icon(
                    LucideIcons.calendar,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      _formatDate(_selectedDate!),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _selectedDate = null),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: AppSpacing.accentCard(accent: AppColors.accent, radius: 8),
                      child: Icon(
                        LucideIcons.x,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(12),
              // Prayer times
              if (prayerTimes != null)
                Row(
                  children: [
                    Expanded(
                      child: _timeChip(
                        'Sehri',
                        prayerTimes.sehriEnd,
                        LucideIcons.sunrise,
                        AppColors.info,
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: _timeChip(
                        'Iftar',
                        prayerTimes.iftarTime,
                        LucideIcons.sunset,
                        AppColors.warning,
                      ),
                    ),
                  ],
                ),
              const Gap(12),
              // Meal status
              Row(
                children: [
                  Expanded(
                    child:
                        _mealStatusBadge('Sehri', hasSehri, AppColors.info),
                  ),
                  const Gap(8),
                  Expanded(
                    child:
                        _mealStatusBadge('Iftar', hasIftar, AppColors.warning),
                  ),
                ],
              ),
              // Meal count
              if (dayMeals.isNotEmpty) ...[
                const Gap(12),
                Text(
                  '${dayMeals.length} meal(s) logged',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().slideY(begin: 0.1).fadeIn();
  }

  Widget _timeChip(String label, String time, IconData icon, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: color),
              const Gap(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: color.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mealStatusBadge(String label, bool done, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: done
                ? color.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: done
                  ? color.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.06),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                done ? LucideIcons.checkCircle : LucideIcons.circle,
                size: 16,
                color: done ? color : Colors.white.withValues(alpha: 0.3),
              ),
              const Gap(8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: done ? color : Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return '${weekdays[date.weekday % 7]}, ${date.day} ${months[date.month - 1]}';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

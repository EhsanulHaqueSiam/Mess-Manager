import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:go_router/go_router.dart';
import 'package:getwidget/getwidget.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/ramadan.dart';
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
        appBar: AppBar(
          title: 'Ramadan Calendar'.text.make(),
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            onPressed: () => context.pop(),
          ),
        ),
        body: VStack(alignment: MainAxisAlignment.center, [
          const Icon(
            LucideIcons.calendarX,
            size: 64,
            color: AppColors.textMutedDark,
          ),
          16.heightBox,
          'No Active Ramadan Season'.text.xl
              .color(AppColors.textPrimaryDark)
              .center
              .make(),
          8.heightBox,
          'Create a season first'.text
              .color(AppColors.textSecondaryDark)
              .center
              .make(),
        ]).centered(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: HStack([
          const Icon(LucideIcons.calendar, color: AppColors.primary, size: 22),
          8.widthBox,
          'Ramadan Calendar'.text.make(),
        ]),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
        actions: [
          // District selector
          PopupMenuButton<String>(
            initialValue: _selectedDistrict,
            onSelected: (district) {
              setState(() {
                _selectedDistrict = district;
                _prayerTimesCache.clear();
              });
              _loadMonthPrayerTimes();
            },
            itemBuilder: (context) {
              return PrayerTimesService.getAvailableDistricts()
                  .map((d) => PopupMenuItem(value: d, child: Text(d)))
                  .toList();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: HStack([
                const Icon(
                  LucideIcons.mapPin,
                  size: 14,
                  color: AppColors.primary,
                ),
                4.widthBox,
                _selectedDistrict.text.sm.color(AppColors.primary).make(),
              ]),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Month navigation header
          _buildMonthHeader(season),
          // Loading indicator
          if (_isLoadingTimes)
            LinearProgressIndicator(
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          // Calendar grid
          Expanded(child: _buildCalendarGrid(season, meals)),
          // Selected date details
          if (_selectedDate != null) _buildSelectedDateDetails(season, meals),
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderDark.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: HStack([
        GFIconButton(
          icon: const Icon(LucideIcons.chevronLeft, size: 20),
          type: GFButtonType.transparent,
          onPressed: canGoPrev
              ? () {
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
        _getMonthName(
          _currentMonth,
        ).text.lg.bold.color(AppColors.textPrimaryDark).make().expand(),
        GFIconButton(
          icon: const Icon(LucideIcons.chevronRight, size: 20),
          type: GFButtonType.transparent,
          onPressed: canGoNext
              ? () {
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
      ]),
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
        child: 'No Ramadan days in this month'.text
            .color(AppColors.textMutedDark)
            .make(),
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
                      child: d.text.xs.color(AppColors.textMutedDark).make(),
                    ),
                  ),
                )
                .toList(),
          ),
          8.heightBox,
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
        // Non-Ramadan day (greyed out)
        dayWidgets.add(
          Container(
            margin: const EdgeInsets.all(2),
            child: Center(
              child: '$day'.text.xs
                  .color(AppColors.textMutedDark.withValues(alpha: 0.3))
                  .make(),
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
      onTap: () => setState(() => _selectedDate = date),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.2)
              : isToday
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : isToday
                ? AppColors.primary.withValues(alpha: 0.5)
                : AppColors.borderDark.withValues(alpha: 0.3),
            width: isSelected || isToday ? 2 : 1,
          ),
        ),
        child: VStack(alignment: MainAxisAlignment.center, [
          // Day number
          '${date.day}'.text.sm.bold
              .color(isSelected ? AppColors.primary : AppColors.textPrimaryDark)
              .make(),
          2.heightBox,
          // Meal status indicators
          HStack(alignment: MainAxisAlignment.center, [
            if (hasSehri)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.info,
                  shape: BoxShape.circle,
                ),
              ),
            if (hasSehri && hasIftar) 2.widthBox,
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
          ]),
          // Prayer times (compact)
          if (prayerTimes != null) ...[
            2.heightBox,
            prayerTimes.sehriEnd
                .split(' ')
                .first
                .text
                .xs
                .color(AppColors.info.withValues(alpha: 0.8))
                .make(),
          ],
        ]),
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          top: BorderSide(color: AppColors.borderDark.withValues(alpha: 0.5)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: VStack(crossAlignment: CrossAxisAlignment.start, [
        // Date header
        HStack([
          const Icon(LucideIcons.calendar, size: 18, color: AppColors.primary),
          8.widthBox,
          _formatDate(
            _selectedDate!,
          ).text.lg.bold.color(AppColors.textPrimaryDark).make().expand(),
          GFIconButton(
            icon: const Icon(LucideIcons.x, size: 18),
            type: GFButtonType.transparent,
            size: GFSize.SMALL,
            onPressed: () => setState(() => _selectedDate = null),
          ),
        ]),
        12.heightBox,
        // Prayer times
        if (prayerTimes != null)
          HStack([
            _timeChip(
              'Sehri',
              prayerTimes.sehriEnd,
              LucideIcons.sunrise,
              AppColors.info,
            ).expand(),
            8.widthBox,
            _timeChip(
              'Iftar',
              prayerTimes.iftarTime,
              LucideIcons.sunset,
              AppColors.warning,
            ).expand(),
          ]),
        12.heightBox,
        // Meal status
        HStack([
          _mealStatusBadge('Sehri', hasSehri, AppColors.info).expand(),
          8.widthBox,
          _mealStatusBadge('Iftar', hasIftar, AppColors.warning).expand(),
        ]),
        // Meal count
        if (dayMeals.isNotEmpty) ...[
          12.heightBox,
          '${dayMeals.length} meal(s) logged'.text.sm
              .color(AppColors.textSecondaryDark)
              .make(),
        ],
      ]),
    ).animate().slideY(begin: 0.1).fadeIn();
  }

  Widget _timeChip(String label, String time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: HStack([
        Icon(icon, size: 16, color: color),
        8.widthBox,
        VStack(crossAlignment: CrossAxisAlignment.start, [
          label.text.xs.color(color.withValues(alpha: 0.8)).make(),
          time.text.sm.bold.color(color).make(),
        ]),
      ]),
    );
  }

  Widget _mealStatusBadge(String label, bool done, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: done ? color.withValues(alpha: 0.2) : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: done ? color : AppColors.borderDark),
      ),
      child: HStack(alignment: MainAxisAlignment.center, [
        Icon(
          done ? LucideIcons.checkCircle : LucideIcons.circle,
          size: 16,
          color: done ? color : AppColors.textMutedDark,
        ),
        8.widthBox,
        label.text.sm.color(done ? color : AppColors.textMutedDark).make(),
      ]),
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

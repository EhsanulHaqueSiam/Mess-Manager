import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/ramadan.dart';
import 'package:mess_manager/core/models/money_transaction.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/services/prayer_times_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/features/ramadan/providers/ramadan_provider.dart';
import 'package:mess_manager/features/money/providers/money_provider.dart';

/// Ramadan Screen - Cosmic Bioluminescence Design
class RamadanScreen extends ConsumerStatefulWidget {
  const RamadanScreen({super.key});

  @override
  ConsumerState<RamadanScreen> createState() => _RamadanScreenState();
}

class _RamadanScreenState extends ConsumerState<RamadanScreen> {
  String _selectedDistrict = 'Dhaka';
  PrayerTimes? _prayerTimes;
  bool _isLoadingTimes = false;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    setState(() => _isLoadingTimes = true);
    final times = await PrayerTimesService.getTimesForDistrict(
      district: _selectedDistrict,
    );
    setState(() {
      _prayerTimes = times;
      _isLoadingTimes = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final season = ref.watch(activeRamadanSeasonProvider);
    final balances = ref.watch(ramadanBalancesProvider);
    final mealRate = ref.watch(ramadanMealRateProvider);
    final members = ref.watch(membersProvider);

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

          // Breathing accent orb - top right
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
                .scaleXY(begin: 0.8, end: 1.2, duration: 4000.ms, curve: Curves.easeInOut),
          ),

          // Breathing accent orb - bottom left
          Positioned(
            bottom: 100,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.1),
                    AppColors.secondary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.3, duration: 5000.ms, curve: Curves.easeInOut),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Custom header
                _buildCosmicHeader(season),

                // Body
                Expanded(
                  child: season == null
                      ? _buildNoSeasonState()
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Season Info Card
                              _buildSeasonCard(season, mealRate)
                                  .animate()
                                  .fadeIn()
                                  .scale(begin: const Offset(0.95, 0.95)),
                              const Gap(16),

                              // Prayer Times Card
                              _buildPrayerTimesCard(),
                              const Gap(16),

                              // Quick Actions
                              _buildQuickActions(season),
                              const Gap(16),

                              // Today's Meals
                              _buildTodayMeals(season),
                              const Gap(16),

                              // Balances section label
                              _buildSectionLabel('BALANCES'),
                              const Gap(8),
                              ...balances.asMap().entries.map(
                                (e) => _buildBalanceRow(e.value, members, e.key),
                              ),
                              const Gap(16),

                              // Credit/Debt Section
                              _buildCreditDebtSection(members),
                              const Gap(80), // FAB clearance
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: season != null
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: () => _showAddMealSheet(context, season),
                icon: const Icon(LucideIcons.utensils, color: Colors.white),
                label: Text('Add Meal', style: TextStyle(color: Colors.white.withValues(alpha: 0.95))),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            )
                .animate()
                .scale(delay: 300.ms)
                .then()
                .shimmer(duration: 2000.ms, delay: 1000.ms, color: Colors.white.withValues(alpha: 0.1))
          : null,
    );
  }

  Widget _buildCosmicHeader(RamadanSeason? season) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          // Gradient halo icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.3),
                  AppColors.primary.withValues(alpha: 0.0),
                ],
              ),
            ),
            child: const Center(
              child: Icon(LucideIcons.moon, color: AppColors.primary, size: 22),
            ),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ramadan',
                  style: AppTypography.titleLarge.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Blessed Month',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
          // Calendar button
          if (season != null)
            _glassIconButton(
              icon: LucideIcons.calendar,
              onTap: () => context.push('/ramadan-calendar'),
              tooltip: 'View Calendar',
            ),
          if (season != null) const Gap(8),
          // New Season button
          if (season == null)
            _glassIconButton(
              icon: LucideIcons.plus,
              onTap: () => _showCreateSeasonSheet(context),
              tooltip: 'New Season',
            ),
        ],
      ),
    );
  }

  Widget _glassIconButton({
    required IconData icon,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    final button = GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 40,
            height: 40,
            decoration: AppSpacing.accentCard(accent: AppColors.accent, radius: 12),
            child: Center(
              child: Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.7)),
            ),
          ),
        ),
      ),
    );
    if (tooltip != null) {
      return Tooltip(message: tooltip, child: button);
    }
    return button;
  }

  Widget _buildNoSeasonState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.primary.withValues(alpha: 0.0),
                ],
              ),
            ),
            child: Icon(LucideIcons.moon, size: 40, color: Colors.white.withValues(alpha: 0.3)),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(begin: 0.9, end: 1.1, duration: 3000.ms, curve: Curves.easeInOut),
          const Gap(16),
          Text(
            'No Active Ramadan Season',
            textAlign: TextAlign.center,
            style: AppTypography.titleLarge.copyWith(color: Colors.white.withValues(alpha: 0.9)),
          ),
          const Gap(8),
          Text(
            'Create a new season to start tracking',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          ),
          const Gap(24),
          AppPrimaryButton(
            text: 'Create Season',
            icon: LucideIcons.plus,
            onPressed: () => _showCreateSeasonSheet(context),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildSeasonCard(RamadanSeason season, double mealRate) {
    final daysLeft = season.endDate.difference(DateTime.now()).inDays;
    final totalDays = season.endDate.difference(season.startDate).inDays;
    final progress = 1 - (daysLeft / totalDays);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: AppSpacing.gradientCard(gradient: AppColors.gradientRamadan, radius: AppSpacing.radiusMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(LucideIcons.moon, color: Colors.white, size: 24),
                const Gap(8),
                Expanded(
                  child: Text(
                    'Ramadan ${season.year}',
                    style: AppTypography.titleLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AppBadge(
                  text: '$daysLeft days left',
                  color: Colors.white.withValues(alpha: 0.15),
                  textColor: Colors.white,
                ),
              ]),
              const Gap(12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress.clamp(0, 1).toDouble(),
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation(Colors.white.withValues(alpha: 0.8)),
                  minHeight: 6,
                ),
              ),
              const Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statItem('Members', '${season.optedInMemberIds.length}'),
                  _statItem('Meal Rate', '${mealRate.toStringAsFixed(1)}'),
                  _statItem('Progress', '${(progress * 100).toInt()}%'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(children: [
      Text(
        value,
        style: AppTypography.titleMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: Colors.white.withValues(alpha: 0.6),
        ),
      ),
    ]);
  }

  /// Prayer times card with Sehri/Iftar countdown - uses live API
  Widget _buildPrayerTimesCard() {
    final now = DateTime.now();
    final times = _prayerTimes;

    // Fallback times if API not loaded
    final sehriTime = times?.sehriEnd ?? '04:30';
    final iftarTime = times?.iftarTime ?? '18:15';

    // Parse times for countdown
    DateTime? sehriDt;
    DateTime? iftarDt;
    try {
      final sehriParts = sehriTime.split(':');
      final iftarParts = iftarTime.split(':');
      sehriDt = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(sehriParts[0]),
        int.parse(sehriParts[1]),
      );
      iftarDt = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(iftarParts[0]),
        int.parse(iftarParts[1]),
      );
    } catch (_) {}

    // Countdown logic
    String countdownText;
    bool isCountingToIftar;

    if (sehriDt != null && now.isBefore(sehriDt)) {
      final diff = sehriDt.difference(now);
      countdownText = '${diff.inHours}h ${diff.inMinutes % 60}m to Sehri';
      isCountingToIftar = false;
    } else if (iftarDt != null && now.isBefore(iftarDt)) {
      final diff = iftarDt.difference(now);
      countdownText = '${diff.inHours}h ${diff.inMinutes % 60}m to Iftar';
      isCountingToIftar = true;
    } else {
      countdownText = 'Iftar complete \u2022 Fast tomorrow';
      isCountingToIftar = false;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: AppSpacing.accentCard(accent: AppColors.accent),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with district selector
                Row(children: [
                  const Icon(LucideIcons.clock, color: AppColors.primary, size: 18),
                  const Gap(8),
                  Text(
                    "Today's Times",
                    style: AppTypography.titleSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // District dropdown
                  _isLoadingTimes
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary.withValues(alpha: 0.6),
                          ),
                        )
                      : PopupMenuButton<String>(
                          initialValue: _selectedDistrict,
                          onSelected: (district) {
                            HapticService.selectionTick();
                            setState(() => _selectedDistrict = district);
                            _loadPrayerTimes();
                          },
                          color: const Color(0xFF141B2D),
                          itemBuilder: (context) {
                            return PrayerTimesService.getAvailableDistricts()
                                .map((d) => PopupMenuItem(
                                      value: d,
                                      child: Text(d, style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
                                    ))
                                .toList();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                            ),
                            child: Row(children: [
                              Text(
                                _selectedDistrict,
                                style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
                              ),
                              const Gap(4),
                              const Icon(LucideIcons.chevronDown, size: 14, color: AppColors.primary),
                            ]),
                          ),
                        ),
                ]),
                const Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Sehri
                    Column(children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.info.withValues(alpha: 0.2),
                              AppColors.info.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(LucideIcons.sunrise, color: AppColors.info, size: 24),
                        ),
                      ),
                      const Gap(4),
                      Text('Sehri', style: AppTypography.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.5))),
                      Text(
                        '$sehriTime AM',
                        style: AppTypography.titleMedium.copyWith(color: AppColors.info, fontWeight: FontWeight.bold),
                      ),
                    ]),
                    Container(
                      width: 1,
                      height: 50,
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                    // Iftar
                    Column(children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.warning.withValues(alpha: 0.2),
                              AppColors.warning.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(LucideIcons.sunset, color: AppColors.warning, size: 24),
                        ),
                      ),
                      const Gap(4),
                      Text('Iftar', style: AppTypography.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.5))),
                      Text(
                        '$iftarTime PM',
                        style: AppTypography.titleMedium.copyWith(color: AppColors.warning, fontWeight: FontWeight.bold),
                      ),
                    ]),
                  ],
                ),
                const Gap(12),
                // Countdown Banner
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: (isCountingToIftar ? AppColors.warning : AppColors.info).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        border: Border.all(
                          color: (isCountingToIftar ? AppColors.warning : AppColors.info).withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isCountingToIftar ? LucideIcons.sunset : LucideIcons.sunrise,
                            size: 16,
                            color: isCountingToIftar ? AppColors.warning : AppColors.info,
                          ),
                          const Gap(8),
                          Text(
                            countdownText,
                            style: AppTypography.bodySmall.copyWith(
                              color: isCountingToIftar ? AppColors.warning : AppColors.info,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05);
  }

  Widget _buildQuickActions(RamadanSeason season) {
    return Row(children: [
      Expanded(
        child: _actionCard(
          icon: LucideIcons.sunrise,
          label: 'Sehri',
          color: AppColors.info,
          onTap: () => _quickAddMeal(season, RamadanMealType.sehri),
        ),
      ),
      const Gap(8),
      Expanded(
        child: _actionCard(
          icon: LucideIcons.sunset,
          label: 'Iftar',
          color: AppColors.warning,
          onTap: () => _quickAddMeal(season, RamadanMealType.iftar),
        ),
      ),
      const Gap(8),
      Expanded(
        child: _actionCard(
          icon: LucideIcons.shoppingCart,
          label: 'Bazar',
          color: AppColors.bazarColor,
          onTap: () => _showAddBazarSheet(context, season),
        ),
      ),
    ]).animate(delay: 100.ms).fadeIn().slideY(begin: 0.05);
  }

  Widget _actionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: AppSpacing.accentCard(accent: color),
            child: Column(children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withValues(alpha: 0.25),
                      color.withValues(alpha: 0.0),
                    ],
                  ),
                ),
                child: Center(child: Icon(icon, color: color, size: 22)),
              ),
              const Gap(8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(color: color),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildTodayMeals(RamadanSeason season) {
    final todayMeals = ref
        .watch(ramadanMealsProvider.notifier)
        .getMealsForDate(season.id, DateTime.now());
    final hasSehri = todayMeals.any((m) => m.type == RamadanMealType.sehri);
    final hasIftar = todayMeals.any((m) => m.type == RamadanMealType.iftar);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: AppSpacing.accentCard(accent: AppColors.accent),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today's Status",
                style: AppTypography.titleSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              Row(children: [
                Expanded(child: _mealStatus('Sehri', LucideIcons.sunrise, hasSehri, AppColors.info)),
                const Gap(8),
                Expanded(child: _mealStatus('Iftar', LucideIcons.sunset, hasIftar, AppColors.warning)),
              ]),
            ],
          ),
        ),
      ),
    ).animate(delay: 200.ms).fadeIn();
  }

  Widget _mealStatus(String label, IconData icon, bool done, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: done ? color.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: done ? color.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            done ? LucideIcons.checkCircle : icon,
            color: done ? color : Colors.white.withValues(alpha: 0.3),
            size: 18,
          ),
          const Gap(4),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: done ? color : Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.3)],
            ),
          ),
        ),
        const Gap(8),
        Text(
          text,
          style: AppTypography.titleLarge.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceRow(RamadanBalance balance, List members, int index) {
    final member = members.firstWhere(
      (m) => m.id == balance.memberId,
      orElse: () => null,
    );
    if (member == null) return const SizedBox.shrink();

    final isPositive = balance.balance >= 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: AppSpacing.accentCard(accent: AppColors.accent),
            child: Row(children: [
              AppMemberAvatar(
                name: member.name,
                size: 36,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              ),
              const Gap(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.name, style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
                    Text(
                      '${balance.totalMeals} meals \u2022 \u09F3${balance.totalBazar.toStringAsFixed(0)} bazar',
                      style: AppTypography.labelSmall.copyWith(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                  ],
                ),
              ),
              Text(
                '${isPositive ? '+' : ''}\u09F3${balance.balance.toStringAsFixed(0)}',
                style: AppTypography.titleMedium.copyWith(
                  color: isPositive ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
          ),
        ),
      ),
    ).animate(delay: (60 * index).ms).fadeIn().slideX(begin: 0.02);
  }

  Widget _buildCreditDebtSection(List members) {
    final creditDebts = ref.watch(ramadanCreditDebtProvider);
    final isSettled = ref.watch(isRamadanSettledProvider);
    final season =
        ref.watch(activeRamadanSeasonProvider) ??
        ref.watch(ramadanSeasonNeedingSettlementProvider);

    if (creditDebts.isEmpty && isSettled) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: AppSpacing.accentCard(accent: AppColors.success),
            child: Row(children: [
              const Icon(LucideIcons.checkCircle, color: AppColors.success, size: 20),
              const Gap(8),
              Expanded(
                child: Text(
                  'All balances settled!',
                  style: TextStyle(color: AppColors.success),
                ),
              ),
              if (season != null && !season.isSettled)
                AppSecondaryButton(
                  text: 'Close Season',
                  color: AppColors.success,
                  onPressed: () => _markSettled(season.id),
                ),
            ]),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('WHO OWES WHOM'),
        const Gap(8),
        ...creditDebts.asMap().entries.map(
          (e) => _buildCreditDebtRow(e.value, members, e.key),
        ),
      ],
    );
  }

  Widget _buildCreditDebtRow(RamadanCreditDebt cd, List members, int index) {
    final from = members.firstWhere(
      (m) => m.id == cd.fromMemberId,
      orElse: () => null,
    );
    final to = members.firstWhere(
      (m) => m.id == cd.toMemberId,
      orElse: () => null,
    );
    if (from == null || to == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: AppSpacing.accentCard(accent: AppColors.accent),
            child: Row(children: [
              AppMemberAvatar(
                name: from.name,
                size: 32,
                backgroundColor: AppColors.error.withValues(alpha: 0.2),
              ),
              const Gap(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(from.name, style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(LucideIcons.arrowRight, size: 14, color: AppColors.warning.withValues(alpha: 0.7)),
                        ),
                        Text(to.name, style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
                      ],
                    ),
                    Text(
                      '\u09F3${cd.amount.toStringAsFixed(0)}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _markRamadanPayment(cd),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success.withValues(alpha: 0.1),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                  ),
                  child: const Center(
                    child: Icon(LucideIcons.checkCircle, color: AppColors.success, size: 18),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    ).animate(delay: (60 * index).ms).fadeIn().slideX(begin: 0.02);
  }

  void _markSettled(String seasonId) {
    ref.read(ramadanSeasonsProvider.notifier).markSeasonSettled(seasonId);
    showSuccessToast(context, 'Ramadan season closed \u2713');
  }

  void _markRamadanPayment(RamadanCreditDebt cd) {
    HapticService.success();

    // Record payment in RamadanPayments to filter from credit/debt list
    ref
        .read(ramadanPaymentsProvider.notifier)
        .addPayment(
          seasonId: cd.seasonId,
          fromMemberId: cd.fromMemberId,
          toMemberId: cd.toMemberId,
          amount: cd.amount,
        );

    // Also create a settled money transaction for the record
    final transaction = MoneyTransaction(
      id: 'ramadan_${DateTime.now().millisecondsSinceEpoch}',
      fromMemberId: cd.fromMemberId, // Debtor pays
      toMemberId: cd.toMemberId, // Creditor receives
      amount: cd.amount,
      description: 'Ramadan settlement',
      date: DateTime.now(),
      isSettled: true,
      settledAt: DateTime.now(),
    );

    ref.read(moneyTransactionsProvider.notifier).addTransaction(transaction);
    showSuccessToast(
      context,
      'Payment of \u09F3${cd.amount.toStringAsFixed(0)} recorded \u2713',
    );
  }

  void _quickAddMeal(RamadanSeason season, RamadanMealType type) {
    HapticService.buttonPress();
    final memberId = ref.read(currentMemberIdProvider);

    ref
        .read(ramadanMealsProvider.notifier)
        .addMeal(
          seasonId: season.id,
          memberId: memberId,
          date: DateTime.now(),
          type: type,
        );

    showSuccessToast(
      context,
      '${type == RamadanMealType.sehri ? 'Sehri' : 'Iftar'} added \u2713',
    );
  }

  void _showCreateSeasonSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _CreateSeasonSheet(),
    );
  }

  void _showAddMealSheet(BuildContext context, RamadanSeason season) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddRamadanMealSheet(season: season),
    );
  }

  void _showAddBazarSheet(BuildContext context, RamadanSeason season) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddRamadanBazarSheet(season: season),
    );
  }
}

// ==================== Add Ramadan Meal Sheet ====================

class _AddRamadanMealSheet extends ConsumerStatefulWidget {
  final RamadanSeason season;

  const _AddRamadanMealSheet({required this.season});

  @override
  ConsumerState<_AddRamadanMealSheet> createState() =>
      _AddRamadanMealSheetState();
}

class _AddRamadanMealSheetState extends ConsumerState<_AddRamadanMealSheet> {
  String? _selectedMemberId;
  RamadanMealType _mealType = RamadanMealType.iftar;
  double _portions = 1.0;
  int _guests = 0;

  @override
  void initState() {
    super.initState();
    _selectedMemberId = ref.read(currentMemberIdProvider);
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);

    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1520),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.6),
                    AppColors.secondary.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),
          const Gap(16),
          Text(
            'Add Ramadan Meal',
            style: AppTypography.headlineSmall.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),

          // Member Selector
          Text('Member', style: AppTypography.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.3))),
          const Gap(8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: members
                .map(
                  (m) => ChoiceChip(
                    label: Text(m.name),
                    selected: _selectedMemberId == m.id,
                    onSelected: (_) => setState(() => _selectedMemberId = m.id),
                  ),
                )
                .toList(),
          ),
          const Gap(16),

          // Meal Type
          Text('Meal Type', style: AppTypography.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.3))),
          const Gap(8),
          Row(children: [
            _mealTypeChip(RamadanMealType.sehri, LucideIcons.sunrise),
            const Gap(8),
            _mealTypeChip(RamadanMealType.iftar, LucideIcons.sunset),
          ]),
          const Gap(16),

          // Portions
          Row(children: [
            Expanded(
              child: Text('Portions', style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
            ),
            _cosmicStepperButton(
              icon: LucideIcons.minus,
              onTap: () {
                if (_portions > 0.5) setState(() => _portions -= 0.5);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '${_portions}x',
                style: AppTypography.titleMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _cosmicStepperButton(
              icon: LucideIcons.plus,
              onTap: () => setState(() => _portions += 0.5),
            ),
          ]),
          const Gap(12),

          // Guests
          Row(children: [
            Expanded(
              child: Text('Guests', style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
            ),
            _cosmicStepperButton(
              icon: LucideIcons.minus,
              onTap: () {
                if (_guests > 0) setState(() => _guests--);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '$_guests',
                style: AppTypography.titleMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _cosmicStepperButton(
              icon: LucideIcons.plus,
              onTap: () => setState(() => _guests++),
            ),
          ]),
          const Gap(24),

          AppPrimaryButton(
            text: 'Add Meal',
            icon: LucideIcons.check,
            onPressed: _submit,
          ),
          const Gap(16),
        ],
      ),
    );
  }

  Widget _cosmicStepperButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Center(
          child: Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.6)),
        ),
      ),
    );
  }

  Widget _mealTypeChip(RamadanMealType type, IconData icon) {
    final isSelected = _mealType == type;
    final label = type == RamadanMealType.sehri ? 'Sehri' : 'Iftar';
    return ChoiceChip(
      label: Row(children: [
        Icon(
          icon,
          size: 16,
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.9),
        ),
        const Gap(6),
        Text(
          label,
          style: TextStyle(color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.9)),
        ),
      ]),
      selected: isSelected,
      onSelected: (_) => setState(() => _mealType = type),
    );
  }

  void _submit() {
    if (_selectedMemberId == null) {
      showErrorToast(context, 'Select a member');
      return;
    }

    HapticService.success();
    ref
        .read(ramadanMealsProvider.notifier)
        .addMeal(
          seasonId: widget.season.id,
          memberId: _selectedMemberId!,
          date: DateTime.now(),
          type: _mealType,
          count: _portions.toInt(),
          guestCount: _guests,
          guestName: _guests > 0 ? 'Guest(s)' : null,
        );

    Navigator.pop(context);
    showSuccessToast(
      context,
      '${_mealType == RamadanMealType.sehri ? "Sehri" : "Iftar"} meal added \u2713',
    );
  }
}

// ==================== Add Ramadan Bazar Sheet ====================

class _AddRamadanBazarSheet extends ConsumerStatefulWidget {
  final RamadanSeason season;

  const _AddRamadanBazarSheet({required this.season});

  @override
  ConsumerState<_AddRamadanBazarSheet> createState() =>
      _AddRamadanBazarSheetState();
}

class _AddRamadanBazarSheetState extends ConsumerState<_AddRamadanBazarSheet> {
  final _itemController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedMemberId;

  @override
  void initState() {
    super.initState();
    _selectedMemberId = ref.read(currentMemberIdProvider);
  }

  @override
  void dispose() {
    _itemController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);

    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1520),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.6),
                    AppColors.secondary.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),
          const Gap(16),
          Text(
            'Add Ramadan Bazar',
            style: AppTypography.headlineSmall.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),

          // Member Selector
          Text('Paid By', style: AppTypography.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.3))),
          const Gap(8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: members
                .map(
                  (m) => ChoiceChip(
                    label: Text(m.name),
                    selected: _selectedMemberId == m.id,
                    onSelected: (_) => setState(() => _selectedMemberId = m.id),
                  ),
                )
                .toList(),
          ),
          const Gap(16),

          // Item Description
          TextField(
            controller: _itemController,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
            decoration: InputDecoration(
              labelText: 'Item Description',
              labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              hintText: 'e.g., Dates, Fruits, Iftar items',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
              prefixIcon: Icon(LucideIcons.shoppingBag, size: 18, color: Colors.white.withValues(alpha: 0.3)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
              ),
            ),
          ),
          const Gap(12),

          // Amount
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
            decoration: InputDecoration(
              labelText: 'Amount (\u09F3)',
              labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              hintText: '0',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
              prefixIcon: Icon(LucideIcons.banknote, size: 18, color: Colors.white.withValues(alpha: 0.3)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
              ),
            ),
          ),
          const Gap(24),

          AppPrimaryButton(
            text: 'Add Bazar Entry',
            icon: LucideIcons.check,
            onPressed: _submit,
          ),
          const Gap(16),
        ],
      ),
    );
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (_selectedMemberId == null) {
      showErrorToast(context, 'Select a member');
      return;
    }
    if (_itemController.text.isEmpty) {
      showErrorToast(context, 'Enter item description');
      return;
    }
    if (amount <= 0) {
      showErrorToast(context, 'Enter valid amount');
      return;
    }

    HapticService.success();
    ref
        .read(ramadanBazarProvider.notifier)
        .addBazar(
          seasonId: widget.season.id,
          memberId: _selectedMemberId!,
          amount: amount,
          description: _itemController.text,
        );

    Navigator.pop(context);
    showSuccessToast(context, 'Bazar entry added \u2713');
  }
}

// ==================== Create Season Sheet ====================

class _CreateSeasonSheet extends ConsumerStatefulWidget {
  const _CreateSeasonSheet();

  @override
  ConsumerState<_CreateSeasonSheet> createState() => _CreateSeasonSheetState();
}

class _CreateSeasonSheetState extends ConsumerState<_CreateSeasonSheet> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  final _yearController = TextEditingController(text: '1447');
  final Set<String> _selectedMembers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final members = ref.read(membersProvider);
      setState(() => _selectedMembers.addAll(members.map((m) => m.id)));
    });
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1520),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.6),
                    AppColors.secondary.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),
          const Gap(16),
          Text(
            'Create Ramadan Season',
            style: AppTypography.headlineSmall.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const Gap(16),

          // Hijri Year
          TextField(
            controller: _yearController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
            decoration: InputDecoration(
              labelText: 'Hijri Year',
              labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              prefixIcon: Icon(LucideIcons.calendar, size: 18, color: Colors.white.withValues(alpha: 0.3)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
              ),
            ),
          ),
          const Gap(12),

          // Date Range
          Row(children: [
            Expanded(
              child: _datePicker(
                'Start',
                _startDate,
                (d) => setState(() => _startDate = d),
              ),
            ),
            const Gap(8),
            Expanded(
              child: _datePicker(
                'End',
                _endDate,
                (d) => setState(() => _endDate = d),
              ),
            ),
          ]),
          const Gap(16),

          // Opt-in Members
          Text(
            'Opt-in Members',
            style: AppTypography.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.5)),
          ),
          const Gap(8),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: members.map((m) {
              final selected = _selectedMembers.contains(m.id);
              return FilterChip(
                selected: selected,
                label: Text(m.name),
                onSelected: (s) {
                  HapticService.selectionTick();
                  setState(() {
                    if (s) {
                      _selectedMembers.add(m.id);
                    } else {
                      _selectedMembers.remove(m.id);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const Gap(24),

          AppPrimaryButton(
            text: 'Create Season',
            icon: LucideIcons.check,
            onPressed: _create,
          ),
          const Gap(16),
        ],
      ),
    );
  }

  Widget _datePicker(
    String label,
    DateTime date,
    ValueChanged<DateTime> onChanged,
  ) {
    return GestureDetector(
      onTap: () async {
        HapticService.lightTap();
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now().subtract(const Duration(days: 30)),
          lastDate: DateTime.now().add(const Duration(days: 120)),
        );
        if (picked != null) onChanged(picked);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(color: Colors.white.withValues(alpha: 0.3)),
                ),
                const Gap(4),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _create() {
    if (_selectedMembers.isEmpty) {
      showErrorToast(context, 'Select at least one member');
      return;
    }

    HapticService.success();
    ref
        .read(ramadanSeasonsProvider.notifier)
        .createSeason(
          startDate: _startDate,
          endDate: _endDate,
          hijriYear: int.tryParse(_yearController.text) ?? 1447,
          optedInMemberIds: _selectedMembers.toList(),
        );

    Navigator.of(context).pop();
    showSuccessToast(context, 'Ramadan season created \u2713');
  }
}

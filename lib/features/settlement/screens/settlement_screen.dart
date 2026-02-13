import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/services/export_service.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/features/settlement/providers/settlement_provider.dart';
import 'package:mess_manager/features/settlement/providers/month_lock_provider.dart';
import 'package:mess_manager/core/models/settlement.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';
import 'package:mess_manager/features/settlement/widgets/audit_sheet.dart';
import 'package:mess_manager/features/settlement/widgets/penalty_settings_sheet.dart';
import 'package:mess_manager/core/providers/role_provider.dart';

/// Settlement Screen - Cosmic Bioluminescence Design
class SettlementScreen extends ConsumerWidget {
  const SettlementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balances = ref.watch(currentMonthBalancesProvider);
    final whoOwesWhom = ref.watch(whoOwesWhomProvider);
    final currentSettlement = ref.watch(currentMonthSettlementProvider);
    final members = ref.watch(membersProvider);
    final summary = ref.watch(balanceSummaryProvider);

    final now = DateTime.now();
    final monthName = _getMonthName(now.month);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // === Deep Space Background ===
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

          // Breathing accent orb (top-right) - settlement rose
          Positioned(
            top: -40,
            right: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.moneyNegative.withValues(alpha: 0.12),
                    AppColors.moneyNegative.withValues(alpha: 0.02),
                    Colors.transparent,
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.15, duration: 4.seconds),
          ),

          // Breathing accent orb (bottom-left) - violet
          Positioned(
            bottom: 120,
            left: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.9, end: 1.1, duration: 5.seconds),
          ),

          // === Main Content ===
          SafeArea(
            child: Column(
              children: [
                // Custom Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Gradient icon halo
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.moneyNegative
                                      .withValues(alpha: 0.3),
                                  AppColors.moneyNegative
                                      .withValues(alpha: 0.05),
                                ],
                              ),
                              border: Border.all(
                                color: AppColors.moneyNegative
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                            child: const Icon(
                              LucideIcons.receipt,
                              color: AppColors.moneyNegative,
                              size: 20,
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Settlement',
                                  style:
                                      AppTypography.headlineMedium.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '$monthName ${now.year}',
                                  style: AppTypography.bodySmall.copyWith(
                                    color:
                                        Colors.white.withValues(alpha: 0.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Action buttons row
                          _buildGlassIconButton(
                            icon: LucideIcons.clipboardList,
                            iconColor: AppColors.success,
                            onTap: () {
                              HapticService.buttonPress();
                              context.push('/month-summary');
                            },
                            tooltip: 'View Summary',
                          ),
                          const Gap(6),
                          _buildGlassIconButton(
                            icon: LucideIcons.shieldCheck,
                            iconColor: AppColors.info,
                            onTap: () => _showAuditSheet(context),
                            tooltip: 'Audit',
                          ),
                          const Gap(6),
                          _buildGlassIconButton(
                            icon: LucideIcons.percent,
                            iconColor: AppColors.error,
                            onTap: () => _showPenaltySettings(context),
                            tooltip: 'Penalty',
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: -0.1),
                      const Gap(10),
                      // Secondary action row
                      Row(
                        children: [
                          _buildGlassIconButton(
                            icon: LucideIcons.lock,
                            iconColor: AppColors.warning,
                            onTap: () => _showCloseMonthDialog(
                                context, ref, summary, whoOwesWhom),
                            tooltip: 'Close Month',
                          ),
                          const Gap(6),
                          _buildGlassIconButton(
                            icon: LucideIcons.fileText,
                            iconColor: AppColors.primary,
                            onTap: () {
                              HapticService.buttonPress();
                              _exportPdf(context, ref, balances, whoOwesWhom,
                                  members, summary);
                            },
                            tooltip: 'Export PDF',
                          ),
                          const Gap(6),
                          _buildGlassIconButton(
                            icon: LucideIcons.fileSpreadsheet,
                            iconColor: AppColors.bazarColor,
                            onTap: () {
                              HapticService.buttonPress();
                              _exportCsv(context, ref, balances, members);
                            },
                            tooltip: 'Export CSV',
                          ),
                          const Spacer(),
                          if (currentSettlement != null &&
                              ref.watch(isSuperAdminProvider) &&
                              currentSettlement.items
                                  .any((i) => !i.isPaid))
                            _buildGlassIconButton(
                              icon: LucideIcons.zap,
                              iconColor: AppColors.error,
                              onTap: () => _showForceSettleDialog(
                                  context, ref, currentSettlement.id),
                              tooltip: 'Force Settle',
                            ),
                          if (currentSettlement == null)
                            _buildFinalizeButton(
                                context, ref, whoOwesWhom),
                        ],
                      )
                          .animate(delay: 100.ms)
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: -0.05),
                    ],
                  ),
                ),

                const Gap(16),

                // Scrollable Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      // Month Hero Card
                      _buildMonthCard(monthName, now.year, summary),
                      const Gap(20),

                      // Settlement Status
                      if (currentSettlement != null) ...[
                        _buildStatusCard(currentSettlement),
                        const Gap(20),
                      ],

                      // Who Owes Whom Section
                      _buildSectionLabel('WHO OWES WHOM',
                          whoOwesWhom.isNotEmpty ? whoOwesWhom.length : null),
                      const Gap(10),
                      if (whoOwesWhom.isEmpty)
                        _buildEmptyState(
                            'All balanced! No payments needed.')
                      else if (members.isNotEmpty)
                        ...whoOwesWhom.asMap().entries.map((entry) {
                          final item = entry.value;
                          final fromMember =
                              members.cast<dynamic>().firstWhere(
                            (m) => m.id == item.fromMemberId,
                            orElse: () => null,
                          );
                          final toMember =
                              members.cast<dynamic>().firstWhere(
                            (m) => m.id == item.toMemberId,
                            orElse: () => null,
                          );
                          if (fromMember == null || toMember == null) {
                            return const SizedBox.shrink();
                          }
                          return _buildPaymentItem(
                            context,
                            ref,
                            fromMember.name,
                            toMember.name,
                            item.amount,
                            item.isPaid,
                            currentSettlement?.id,
                            item.fromMemberId,
                            item.toMemberId,
                            entry.key,
                          );
                        }),
                      const Gap(20),

                      // Balance Summary Section
                      _buildSectionLabel('MEMBER BALANCES',
                          balances.isNotEmpty ? balances.length : null),
                      const Gap(10),
                      if (members.isNotEmpty)
                        ...balances.asMap().entries.map((entry) {
                          final balance = entry.value;
                          final member =
                              members.cast<dynamic>().firstWhere(
                            (m) => m.id == balance.memberId,
                            orElse: () => null,
                          );
                          if (member == null) return const SizedBox.shrink();
                          return _buildBalanceItem(
                              member.name, balance, entry.key);
                        }),
                      const Gap(100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // GLASS ICON BUTTON
  // =====================================================================

  Widget _buildGlassIconButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
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
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Icon(
              icon,
              color: iconColor ?? Colors.white.withValues(alpha: 0.7),
              size: 18,
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

  // =====================================================================
  // FINALIZE BUTTON (glass style)
  // =====================================================================

  Widget _buildFinalizeButton(
      BuildContext context, WidgetRef ref, List whoOwesWhom) {
    return GestureDetector(
      onTap: () {
        HapticService.success();
        _createSettlement(context, ref, whoOwesWhom);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.moneyPositive.withValues(alpha: 0.3),
                  AppColors.moneyPositive.withValues(alpha: 0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.moneyPositive.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.check,
                    size: 16, color: AppColors.moneyPositive),
                const Gap(6),
                Text(
                  'Finalize',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.moneyPositive,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================================
  // MONTH HERO CARD (glassmorphism)
  // =====================================================================

  Widget _buildMonthCard(String monthName, int year, BalanceSummary summary) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.moneyNegative.withValues(alpha: 0.2),
                AppColors.moneyNegative.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: AppColors.moneyNegative.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settlement',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.5),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        '$monthName $year',
                        style: AppTypography.headlineSmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Icon(
                      LucideIcons.calculator,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 20,
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.08),
              ),
              const Gap(14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMonthStat(
                    'Total Bazar',
                    '\u09F3${summary.totalBazar.toStringAsFixed(0)}',
                  ),
                  // Vertical divider
                  Container(
                    width: 1,
                    height: 32,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  _buildMonthStat(
                    'Meal Rate',
                    '\u09F3${summary.mealRate.toStringAsFixed(1)}',
                  ),
                  Container(
                    width: 1,
                    height: 32,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  _buildMonthStat('Members', '${summary.memberCount}'),
                ],
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildMonthStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const Gap(2),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }

  // =====================================================================
  // STATUS CARD (glassmorphism)
  // =====================================================================

  Widget _buildStatusCard(dynamic settlement) {
    final status = settlement.status;
    final isCompleted = status.toString().contains('completed');
    final isPartial = status.toString().contains('partial');

    Color statusColor = Colors.white.withValues(alpha: 0.05);
    if (isCompleted) {
      statusColor = AppColors.moneyPositive;
    } else if (isPartial) {
      statusColor = AppColors.accentWarm;
    } else {
      statusColor = AppColors.primary;
    }

    String statusText = 'Pending';
    if (isCompleted) {
      statusText = 'Completed';
    } else if (isPartial) {
      statusText = 'Partially Paid';
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: statusColor.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor.withValues(alpha: 0.12),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  isCompleted
                      ? LucideIcons.checkCircle
                      : isPartial
                          ? LucideIcons.clock
                          : LucideIcons.alertCircle,
                  color: statusColor,
                  size: 20,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settlement Status',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    Text(
                      statusText,
                      style: AppTypography.titleMedium.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCompleted && settlement.settledAt != null)
                Text(
                  'Settled ${_formatDate(settlement.settledAt!)}',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
        ),
      ),
    ).animate(delay: 200.ms).fadeIn().slideX(begin: 0.03);
  }

  // =====================================================================
  // SECTION LABEL
  // =====================================================================

  Widget _buildSectionLabel(String text, int? count) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.moneyNegative,
                AppColors.accent,
              ],
            ),
          ),
        ),
        const Gap(8),
        Text(
          text,
          style: AppTypography.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.4),
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            fontSize: 11,
          ),
        ),
        if (count != null) ...[
          const Gap(8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.moneyNegative.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.moneyNegative.withValues(alpha: 0.15),
              ),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: AppColors.moneyNegative,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // =====================================================================
  // EMPTY STATE
  // =====================================================================

  Widget _buildEmptyState(String message) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Column(
            children: [
              Icon(
                LucideIcons.checkCircle,
                color: AppColors.moneyPositive.withValues(alpha: 0.7),
                size: 48,
              ),
              const Gap(12),
              Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: 300.ms).fadeIn().slideX(begin: 0.03);
  }

  // =====================================================================
  // PAYMENT ITEM (glassmorphism card)
  // =====================================================================

  Widget _buildPaymentItem(
    BuildContext context,
    WidgetRef ref,
    String fromName,
    String toName,
    double amount,
    bool isPaid,
    String? settlementId,
    String fromId,
    String toId,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: isPaid
                    ? AppColors.moneyPositive.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Row(
              children: [
                AppMemberAvatar(
                  name: fromName,
                  size: 36,
                  backgroundColor:
                      AppColors.moneyNegative.withValues(alpha: 0.2),
                ),
                const Gap(8),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            fromName,
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                          const Gap(4),
                          Icon(
                            LucideIcons.arrowRight,
                            color: isPaid
                                ? AppColors.moneyPositive
                                : AppColors.moneyNegative,
                            size: 16,
                          ),
                          const Gap(4),
                          Text(
                            toName,
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                      const Gap(2),
                      Text(
                        '\u09F3${amount.toStringAsFixed(0)}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isPaid
                              ? AppColors.moneyPositive
                              : Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                AppMemberAvatar(
                  name: toName,
                  size: 36,
                  backgroundColor:
                      AppColors.moneyPositive.withValues(alpha: 0.2),
                ),
                const Gap(8),
                if (!isPaid && settlementId != null)
                  GestureDetector(
                    onTap: () {
                      HapticService.success();
                      _markAsPaid(ref, settlementId, fromId, toId);
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.moneyPositive.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              AppColors.moneyPositive.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        LucideIcons.check,
                        size: 18,
                        color: AppColors.moneyPositive,
                      ),
                    ),
                  )
                else if (isPaid)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.moneyPositive.withValues(alpha: 0.08),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(
                        color:
                            AppColors.moneyPositive.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Icon(
                      LucideIcons.checkCircle,
                      color: AppColors.moneyPositive,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  // =====================================================================
  // BALANCE ITEM (glassmorphism card)
  // =====================================================================

  Widget _buildBalanceItem(String name, dynamic balance, int index) {
    final isPositive = balance.balance >= 0;
    final balanceColor =
        isPositive ? AppColors.moneyPositive : AppColors.moneyNegative;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Row(
              children: [
                AppMemberAvatar(
                  name: name,
                  size: 40,
                  backgroundColor: balanceColor.withValues(alpha: 0.2),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTypography.titleSmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        'Bazar: \u09F3${balance.totalBazar.toStringAsFixed(0)} | Meals: \u09F3${balance.mealCost.toStringAsFixed(0)}',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isPositive ? '+' : ''}\u09F3${balance.balance.toStringAsFixed(0)}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: balanceColor,
                      ),
                    ),
                    Text(
                      isPositive ? 'Credit' : 'Owes',
                      style: AppTypography.labelSmall.copyWith(
                        color: balanceColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: (60 * index).ms).fadeIn().slideX(begin: 0.02);
  }

  // =====================================================================
  // LOGIC METHODS (unchanged)
  // =====================================================================

  void _createSettlement(BuildContext context, WidgetRef ref, List items) {
    if (items.isEmpty) {
      showInfoToast(context, 'All balances are settled!');
      return;
    }

    final now = DateTime.now();
    ref
        .read(settlementsProvider.notifier)
        .createSettlement(
          year: now.year,
          month: now.month,
          items: items.cast(),
        );

    showSuccessToast(context, 'Settlement created!');
  }

  void _markAsPaid(
    WidgetRef ref,
    String settlementId,
    String fromId,
    String toId,
  ) {
    ref
        .read(settlementsProvider.notifier)
        .markItemPaid(settlementId, fromId, toId);
  }

  String _getMonthName(int month) {
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
    return months[month - 1];
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  Future<void> _exportPdf(
    BuildContext context,
    WidgetRef ref,
    List balances,
    List payments,
    List members,
    BalanceSummary summary,
  ) async {
    try {
      final now = DateTime.now();
      final pdfBytes = await ExportService.generateSettlementPdf(
        year: now.year,
        month: now.month,
        totalBazar: summary.totalBazar,
        mealRate: summary.mealRate,
        balances: balances.cast(),
        payments: payments.cast(),
        members: members.cast(),
      );
      await ExportService.sharePdf(
        pdfBytes,
        'settlement_${now.year}_${now.month}.pdf',
      );
    } catch (e) {
      if (context.mounted) showErrorToast(context, 'Export failed: $e');
    }
  }

  Future<void> _exportCsv(
    BuildContext context,
    WidgetRef ref,
    List balances,
    List members,
  ) async {
    try {
      final now = DateTime.now();
      final csv = ExportService.generateBalancesCsv(
        balances: balances.cast(),
        members: members.cast(),
      );
      await ExportService.shareCsv(
        csv,
        'balances_${now.year}_${now.month}.csv',
      );
    } catch (e) {
      if (context.mounted) showErrorToast(context, 'Export failed: $e');
    }
  }

  void _showCloseMonthDialog(
    BuildContext context,
    WidgetRef ref,
    BalanceSummary summary,
    List<SettlementItem> payments,
  ) {
    final now = DateTime.now();
    final isLocked =
        ref.read(monthLockProvider).isLocked(now.year, now.month);
    final isSuperAdmin = ref.read(isSuperAdminProvider);

    // If locked, show re-open option for Super Admins
    if (isLocked) {
      if (isSuperAdmin) {
        _showReopenMonthDialog(context, ref, now.year, now.month);
      } else {
        showErrorToast(context, 'This month is already closed');
      }
      return;
    }

    HapticService.modalOpen();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D1520),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        title: Row(
          children: [
            const Icon(LucideIcons.alertTriangle, color: AppColors.warning),
            const Gap(8),
            Text(
              'Close Month?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This will:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const Gap(8),
            _buildDialogCheckItem('Generate final PDF report'),
            const Gap(4),
            _buildDialogCheckItem('Lock all entries (read-only)'),
            const Gap(4),
            _buildDialogCheckItem(
                'Carry forward balances to next month'),
            const Gap(16),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.08),
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.15),
                ),
              ),
              child: Text(
                'This action cannot be undone!',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.warning,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await _closeMonth(context, ref, summary, payments);
            },
            child: const Text(
              'Close Month',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogCheckItem(String text) {
    return Row(
      children: [
        const Icon(LucideIcons.check, size: 16, color: AppColors.success),
        const Gap(8),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }

  /// Super Admin: Re-open a closed month
  void _showReopenMonthDialog(
    BuildContext context,
    WidgetRef ref,
    int year,
    int month,
  ) {
    HapticService.modalOpen();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D1520),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        title: Row(
          children: [
            const Icon(LucideIcons.unlock, color: AppColors.error),
            const Gap(8),
            Text(
              'Re-open Month?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SUPER ADMIN ACTION',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            Text(
              'This will unlock ${_getMonthName(month)} $year for editing.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const Gap(12),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Warning:',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    'Entries can be modified again',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  Text(
                    'Carry-forward balances may be affected',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  Text(
                    'Finalized reports will be invalidated',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(monthLockProvider.notifier)
                  .unlockMonth(year, month);
              HapticService.warning();
              showSuccessToast(context, 'Month unlocked for editing');
            },
            child: const Text(
              'Unlock Month',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _closeMonth(
    BuildContext context,
    WidgetRef ref,
    BalanceSummary summary,
    List<SettlementItem> payments,
  ) async {
    HapticService.buttonPress();

    final now = DateTime.now();
    final balances = ref.read(memberBalancesProvider);

    try {
      final result = await ref
          .read(monthLockProvider.notifier)
          .closeMonth(
            year: now.year,
            month: now.month,
            summary: summary,
            balances: balances,
            payments: payments,
          );

      if (result.success && result.pdfBytes != null) {
        HapticService.success();
        if (context.mounted) {
          showSuccessToast(context, 'Month closed! PDF generated.');
          // Share the PDF
          await ExportService.sharePdf(
            Uint8List.fromList(result.pdfBytes!),
            'settlement_${now.year}_${now.month}_final.pdf',
          );
        }
      } else {
        if (context.mounted) {
          showErrorToast(
              context, result.error ?? 'Failed to close month');
        }
      }
    } catch (e) {
      if (context.mounted) {
        showErrorToast(context, 'Error: $e');
      }
    }
  }

  void _showAuditSheet(BuildContext context) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AuditSheet(),
    );
  }

  void _showPenaltySettings(BuildContext context) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PenaltySettingsSheet(),
    );
  }

  /// Super Admin: Force settle all unpaid items
  void _showForceSettleDialog(
    BuildContext context,
    WidgetRef ref,
    String settlementId,
  ) {
    HapticService.modalOpen();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D1520),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        title: Row(
          children: [
            const Icon(LucideIcons.zap, color: AppColors.error),
            const Gap(8),
            Text(
              'Force Settle All?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SUPER ADMIN ACTION',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            Text(
              'This will mark ALL remaining payments as PAID.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const Gap(12),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.08),
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This should only be used when:',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  const Gap(4),
                  Text(
                    'Payments were made outside the app',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  Text(
                    'Members left with unsettled balance',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  Text(
                    'Admin manually verified all payments',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(settlementsProvider.notifier)
                  .forceSettleAll(settlementId);
              HapticService.success();
              showSuccessToast(
                  context, 'All payments marked as settled');
            },
            child: const Text(
              'Force Settle',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';
import 'package:printing/printing.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/services/export_service.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';
import 'package:mess_manager/features/settlement/providers/settlement_provider.dart';

/// Month-End Summary Screen - Cosmic Bioluminescence Design
class MonthSummaryScreen extends ConsumerWidget {
  const MonthSummaryScreen({super.key});

  static const _months = [
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final balances = ref.watch(memberBalancesProvider);
    final summary = ref.watch(balanceSummaryProvider);
    final members = ref.watch(membersProvider);
    final settlementBalances = ref.watch(currentMonthBalancesProvider);
    final payments = ref.watch(whoOwesWhomProvider);

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

          // Breathing accent orb (top-right) - primary blue
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
                    AppColors.primary.withValues(alpha: 0.12),
                    AppColors.primary.withValues(alpha: 0.02),
                    Colors.transparent,
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.15, duration: 4.seconds),
          ),

          // Breathing accent orb (bottom-left) - accent
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
                  child: Row(
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
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
                                  color:
                                      Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              child: Icon(
                                LucideIcons.arrowLeft,
                                color:
                                    Colors.white.withValues(alpha: 0.7),
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Gap(12),
                      // Gradient icon halo
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.primary.withValues(alpha: 0.3),
                              AppColors.primary.withValues(alpha: 0.05),
                            ],
                          ),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Icon(
                          LucideIcons.clipboardList,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Month-End Summary',
                              style: AppTypography.headlineMedium.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${_months[now.month - 1]} ${now.year}',
                              style: AppTypography.bodySmall.copyWith(
                                color:
                                    Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Export popup menu
                      PopupMenuButton<String>(
                        color: const Color(0xFF0D1520),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        icon: ClipRRect(
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
                                  color:
                                      Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              child: Icon(
                                LucideIcons.share2,
                                color:
                                    Colors.white.withValues(alpha: 0.7),
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        onSelected: (value) => _handleExport(
                          context,
                          ref,
                          value,
                          balances,
                          summary,
                          members,
                          settlementBalances,
                          payments,
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'print',
                            child: Row(
                              children: [
                                Icon(LucideIcons.printer,
                                    size: 16,
                                    color: Colors.white
                                        .withValues(alpha: 0.7)),
                                const Gap(10),
                                Text(
                                  'Print / PDF',
                                  style: TextStyle(
                                    color: Colors.white
                                        .withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'excel',
                            child: Row(
                              children: [
                                Icon(LucideIcons.fileSpreadsheet,
                                    size: 16,
                                    color: Colors.white
                                        .withValues(alpha: 0.7)),
                                const Gap(10),
                                Text(
                                  'Export Excel',
                                  style: TextStyle(
                                    color: Colors.white
                                        .withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: -0.1),
                ),

                const Gap(16),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header Card
                        _buildHeader(now, summary)
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .scale(
                                begin: const Offset(0.95, 0.95)),
                        const Gap(20),

                        // Balance Table
                        _buildSectionLabel('MEMBER BALANCES',
                            balances.isNotEmpty ? balances.length : null),
                        const Gap(10),
                        _buildBalanceTable(balances, summary)
                            .animate(delay: 100.ms)
                            .fadeIn(),
                        const Gap(20),

                        // Summary Stats
                        _buildSectionLabel('CALCULATION SUMMARY', null),
                        const Gap(10),
                        _buildSummaryStats(summary)
                            .animate(delay: 200.ms)
                            .fadeIn(),
                        const Gap(24),

                        // Signature Block
                        _buildSectionLabel('VERIFICATION', null),
                        const Gap(10),
                        _buildSignatureBlock()
                            .animate(delay: 300.ms)
                            .fadeIn(),
                        const Gap(100),
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
                AppColors.primary,
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
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: AppColors.primary,
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
  // HEADER CARD (glassmorphism)
  // =====================================================================

  Widget _buildHeader(DateTime now, BalanceSummary summary) {
    final monthName = _months[now.month - 1];
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.2),
                AppColors.primary.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            children: [
              Text(
                'Area51 Mess',
                style: AppTypography.headlineSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(4),
              Text(
                '$monthName ${now.year} - Financial Summary',
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
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
                  _buildHeaderStat(
                    'Total Bazar',
                    '\u09F3${summary.totalBazar.toStringAsFixed(0)}',
                  ),
                  Container(
                    width: 1,
                    height: 32,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  _buildHeaderStat(
                    'Meal Rate',
                    '\u09F3${summary.mealRate.toStringAsFixed(2)}',
                  ),
                  Container(
                    width: 1,
                    height: 32,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  _buildHeaderStat(
                    'Fixed Costs',
                    '\u09F3${summary.totalFixedExpenses.toStringAsFixed(0)}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
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
  // BALANCE TABLE (glass card with glass header)
  // =====================================================================

  Widget _buildBalanceTable(
    List<MemberBalance> balances,
    BalanceSummary summary,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Table Header (glass styled)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Member',
                            style: AppTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Meals',
                            textAlign: TextAlign.center,
                            style: AppTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Bazar',
                            textAlign: TextAlign.center,
                            style: AppTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Fixed',
                            textAlign: TextAlign.center,
                            style: AppTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Meal Cost',
                            textAlign: TextAlign.center,
                            style: AppTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Balance',
                            textAlign: TextAlign.center,
                            style: AppTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Table Rows
              ...balances.asMap().entries.map((entry) {
                final i = entry.key;
                final b = entry.value;
                final isEven = i % 2 == 0;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  color: isEven
                      ? Colors.transparent
                      : Colors.white.withValues(alpha: 0.02),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          b.name,
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          b.totalMeals.toStringAsFixed(1),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '\u09F3${b.totalBazar.toStringAsFixed(0)}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '\u09F3${b.fixedExpenseShare.toStringAsFixed(0)}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '\u09F3${b.mealCost.toStringAsFixed(0)}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${b.balance >= 0 ? '+' : ''}${b.balance.toStringAsFixed(0)}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: b.balance >= 0
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================================
  // SUMMARY STATS (glass card)
  // =====================================================================

  Widget _buildSummaryStats(BalanceSummary summary) {
    return ClipRRect(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calculation Summary',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const Gap(AppSpacing.sm),
              _buildStatRow(
                  'Total Meals', summary.totalMeals.toStringAsFixed(1)),
              _buildStatRow(
                'Total Bazar',
                '\u09F3${summary.totalBazar.toStringAsFixed(2)}',
              ),
              _buildStatRow(
                'Meal Rate',
                '\u09F3${summary.mealRate.toStringAsFixed(2)} per meal',
              ),
              _buildStatRow(
                'Fixed Expenses',
                '\u09F3${summary.totalFixedExpenses.toStringAsFixed(0)}',
              ),
              _buildStatRow(
                'Per-Member Fixed Share',
                '\u09F3${summary.perMemberFixedShare.toStringAsFixed(2)}',
              ),
              _buildStatRow('Members', '${summary.memberCount}'),
              _buildStatRow(
                'Calculation Mode',
                summary.calculationMode.toUpperCase(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // SIGNATURE BLOCK (glass card, cosmic dark)
  // =====================================================================

  Widget _buildSignatureBlock() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Column(
            children: [
              Text(
                'Verification & Signatures',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const Gap(AppSpacing.lg),
              Row(
                children: [
                  Expanded(child: _buildSignatureLine('Manager')),
                  const Gap(AppSpacing.lg),
                  Expanded(child: _buildSignatureLine('Member Rep.')),
                ],
              ),
              const Gap(AppSpacing.md),
              Text(
                'Date: _____________________',
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignatureLine(String role) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          height: 1,
          color: Colors.white.withValues(alpha: 0.15),
        ),
        const Gap(4),
        Text(
          role,
          style: AppTypography.labelSmall.copyWith(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }

  // =====================================================================
  // EXPORT LOGIC (unchanged)
  // =====================================================================

  Future<void> _handleExport(
    BuildContext context,
    WidgetRef ref,
    String type,
    List<MemberBalance> balances,
    BalanceSummary summary,
    List members,
    List settlementBalances,
    List payments,
  ) async {
    final now = DateTime.now();
    try {
      if (type == 'print') {
        final pdfBytes = await ExportService.generateSettlementPdf(
          year: now.year,
          month: now.month,
          totalBazar: summary.totalBazar,
          mealRate: summary.mealRate,
          balances: settlementBalances.cast(),
          payments: payments.cast(),
          members: members.cast(),
        );
        await Printing.layoutPdf(onLayout: (_) => pdfBytes);
      } else if (type == 'excel') {
        final xlsxBytes = ExportService.generateBalancesXlsx(
          year: now.year,
          month: now.month,
          totalBazar: summary.totalBazar,
          mealRate: summary.mealRate,
          balances: settlementBalances.cast(),
          members: members.cast(),
        );
        await ExportService.shareXlsx(
          xlsxBytes,
          'summary_${now.year}_${now.month}.xlsx',
        );
      }
    } catch (e) {
      if (context.mounted) {
        showErrorToast(context, 'Export failed: $e');
      }
    }
  }
}

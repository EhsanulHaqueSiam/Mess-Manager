import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/models/duty.dart';
import 'package:mess_manager/core/models/money_transaction.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/core/widgets/animated_widgets.dart';
import 'package:mess_manager/features/money/providers/money_provider.dart';
import 'package:mess_manager/features/money/widgets/add_transaction_sheet.dart';
import 'package:mess_manager/features/duties/providers/duty_provider.dart';
import 'package:mess_manager/core/providers/role_provider.dart';

/// Money Screen - Cosmic Bioluminescence Design
class MoneyScreen extends ConsumerWidget {
  const MoneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalBalance = ref.watch(currentPersonalBalanceProvider);
    final pendingTx = ref.watch(pendingTransactionsProvider);
    final settledTx = ref.watch(settledTransactionsProvider);
    final members = ref.watch(membersProvider);
    final dutyDebts = ref.watch(dutyDebtsProvider);
    final currentMemberId = ref.watch(currentMemberIdProvider);

    final myDutyDebts = dutyDebts
        .where((d) => d.debtorId == currentMemberId && !d.isSettled)
        .toList();
    final myDutyCredits = dutyDebts
        .where((d) => d.creditorId == currentMemberId && !d.isSettled)
        .toList();

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

          // Warm accent orb (top-right)
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
                    AppColors.accentWarm.withValues(alpha: 0.12),
                    AppColors.accentWarm.withValues(alpha: 0.02),
                    Colors.transparent,
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.15, duration: 4.seconds),
          ),

          // Teal orb (bottom-left)
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
                    AppColors.primary.withValues(alpha: 0.08),
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
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.accentWarm.withValues(alpha: 0.3),
                              AppColors.accentWarm.withValues(alpha: 0.05),
                            ],
                          ),
                          border: Border.all(
                            color: AppColors.accentWarm.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Icon(
                          LucideIcons.arrowLeftRight,
                          color: AppColors.accentWarm,
                          size: 20,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Money',
                              style: AppTypography.headlineMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${pendingTx.length} pending transactions',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildGlassIconButton(
                        icon: LucideIcons.plus,
                        onTap: () => _showAddSheet(context),
                      ),
                    ],
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1),
                ),

                const Gap(16),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Personal Balance Hero Card
                        if (personalBalance != null)
                          _buildPersonalBalanceCard(personalBalance)
                              .animate()
                              .fadeIn(delay: 200.ms)
                              .slideY(begin: 0.05),
                        const Gap(20),

                        // Pending Transactions
                        if (pendingTx.isNotEmpty) ...[
                          _buildSectionLabel('PENDING', pendingTx.length),
                          const Gap(10),
                          ...pendingTx.asMap().entries.map(
                                (e) => _buildTransactionCard(
                                  context,
                                  ref,
                                  e.value,
                                  members,
                                  e.key,
                                  false,
                                ),
                              ),
                          const Gap(20),
                        ],

                        // Duty Debts
                        if (myDutyDebts.isNotEmpty ||
                            myDutyCredits.isNotEmpty) ...[
                          _buildSectionLabel('DUTY BALANCE', null),
                          const Gap(10),
                          _buildDutyDebtsCard(
                              context, myDutyDebts, myDutyCredits, members),
                          const Gap(20),
                        ],

                        // Settled Transactions
                        if (settledTx.isNotEmpty) ...[
                          _buildSectionLabel('SETTLED', settledTx.length),
                          const Gap(10),
                          ...settledTx.take(5).toList().asMap().entries.map(
                                (e) => _buildTransactionCard(
                                  context,
                                  ref,
                                  e.value,
                                  members,
                                  e.key,
                                  true,
                                ),
                              ),
                        ],

                        if (pendingTx.isEmpty && settledTx.isEmpty)
                          EmptyStateWidget(
                            icon: LucideIcons.wallet,
                            title: 'No transactions yet',
                            subtitle:
                                'Track money given or received between members',
                            action: ShimmerCTAButton(
                              text: 'Add Transaction',
                              icon: LucideIcons.plus,
                              onPressed: () => _showAddSheet(context),
                            ),
                          ),

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
      floatingActionButton: _buildCosmicFAB(context),
    );
  }

  Widget _buildGlassIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
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
            child: Icon(icon,
                color: Colors.white.withValues(alpha: 0.7), size: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text, int? count) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.accentWarm, AppColors.primary],
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
              color: AppColors.accentWarm.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.accentWarm.withValues(alpha: 0.15),
              ),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: AppColors.accentWarm,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPersonalBalanceCard(PersonalBalance balance) {
    final isPositive = balance.netBalance >= 0;
    final accentColor = isPositive ? AppColors.success : AppColors.error;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accentColor.withValues(alpha: 0.15),
                accentColor.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accentColor.withValues(alpha: 0.3),
                          accentColor.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                    child: Icon(
                      isPositive
                          ? LucideIcons.trendingUp
                          : LucideIcons.trendingDown,
                      color: accentColor,
                      size: 20,
                    ),
                  ),
                  const Gap(12),
                  Text(
                    isPositive ? 'You are owed' : 'You owe',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              const Gap(12),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: balance.netBalance.abs()),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) => Text(
                  '৳${value.toStringAsFixed(0)}',
                  style: AppTypography.headlineLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'JetBrains Mono',
                  ),
                ),
              ),
              const Gap(16),
              // Gradient divider
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const Gap(12),
              Row(
                children: [
                  _buildMiniStat(
                      'Given', '৳${balance.amountOwedTo.toStringAsFixed(0)}',
                      AppColors.success),
                  const Gap(24),
                  _buildMiniStat(
                      'Received', '৳${balance.amountOwed.toStringAsFixed(0)}',
                      AppColors.error),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.35),
            fontSize: 11,
          ),
        ),
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
            fontFamily: 'JetBrains Mono',
          ),
        ),
      ],
    );
  }

  Widget _buildDutyDebtsCard(
    BuildContext context,
    List<DutyDebt> debts,
    List<DutyDebt> credits,
    List members,
  ) {
    String getMemberName(String id) {
      for (final m in members) {
        if (m.id == id) return m.name;
      }
      return 'Unknown';
    }

    String getDutyName(DutyType type) {
      switch (type) {
        case DutyType.roomCleaning:
          return 'Room Cleaning';
        case DutyType.diningCleanup:
          return 'Dining Cleanup';
        case DutyType.bazarDuty:
          return 'Bazar Duty';
        case DutyType.garbageDisposal:
          return 'Garbage';
        case DutyType.cooking:
          return 'Cooking';
      }
    }

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
              if (credits.isNotEmpty) ...[
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.moneyPositive.withValues(alpha: 0.3),
                            AppColors.moneyPositive.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: const Icon(LucideIcons.trendingUp,
                          color: AppColors.moneyPositive, size: 12),
                    ),
                    const Gap(8),
                    Text(
                      'Others Owe You',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.moneyPositive,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                ...credits.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(left: 32, bottom: 4),
                    child: Text(
                      '• ${getMemberName(c.debtorId)} owes 1 ${getDutyName(c.dutyType)}',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                if (debts.isNotEmpty) const Gap(12),
              ],
              if (debts.isNotEmpty) ...[
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.moneyNegative.withValues(alpha: 0.3),
                            AppColors.moneyNegative.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: const Icon(LucideIcons.trendingDown,
                          color: AppColors.moneyNegative, size: 12),
                    ),
                    const Gap(8),
                    Text(
                      'You Owe',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.moneyNegative,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                ...debts.map(
                  (d) => Padding(
                    padding: const EdgeInsets.only(left: 32, bottom: 4),
                    child: Text(
                      '• You owe ${getMemberName(d.creditorId)} 1 ${getDutyName(d.dutyType)}',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: -0.03);
  }

  Widget _buildTransactionCard(
    BuildContext context,
    WidgetRef ref,
    dynamic tx,
    List members,
    int index,
    bool isSettled,
  ) {
    if (members.isEmpty) return const SizedBox.shrink();
    final from = members.cast<dynamic>().firstWhere(
      (m) => m.id == tx.fromMemberId,
      orElse: () => null,
    );
    final to = members.cast<dynamic>().firstWhere(
      (m) => m.id == tx.toMemberId,
      orElse: () => null,
    );
    if (from == null || to == null) return const SizedBox.shrink();

    final currentMemberId = ref.read(currentMemberIdProvider);
    final isReceiver = tx.toMemberId == currentMemberId;
    final isSender = tx.fromMemberId == currentMemberId;

    Color statusBorderColor = Colors.white.withValues(alpha: 0.05);
    switch (tx.status) {
      case TransactionStatus.pending:
        statusBorderColor = AppColors.warning.withValues(alpha: 0.2);
      case TransactionStatus.accepted:
        statusBorderColor = AppColors.info.withValues(alpha: 0.2);
      case TransactionStatus.rejected:
        statusBorderColor = AppColors.error.withValues(alpha: 0.2);
      case TransactionStatus.settled:
        statusBorderColor = Colors.white.withValues(alpha: 0.05);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: statusBorderColor),
            ),
            child: Column(
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accentWarm.withValues(alpha: 0.2),
                        ),
                      ),
                      child: AppMemberAvatar(
                        name: from.name,
                        size: 36,
                        backgroundColor:
                            AppColors.accentWarm.withValues(alpha: 0.1),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                from.name.toString(),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(
                                  LucideIcons.arrowRight,
                                  size: 14,
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                              ),
                              Text(
                                to.name.toString(),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          if (tx.description != null &&
                              tx.description!.isNotEmpty)
                            Text(
                              tx.description!,
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.35),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '৳${tx.amount.toStringAsFixed(0)}',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.accentWarm,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'JetBrains Mono',
                          ),
                        ),
                        if (tx.requiresPhotoProof)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                tx.hasPhotoProof
                                    ? LucideIcons.checkCircle
                                    : LucideIcons.camera,
                                size: 12,
                                color: tx.hasPhotoProof
                                    ? AppColors.success
                                    : AppColors.warning,
                              ),
                              const Gap(4),
                              Text(
                                tx.hasPhotoProof ? 'Proof' : 'No proof',
                                style: TextStyle(
                                  color: tx.hasPhotoProof
                                      ? AppColors.success
                                      : AppColors.warning,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),

                // Status + Actions
                const Gap(10),
                Row(
                  children: [
                    _buildStatusBadge(tx.status),
                    const Spacer(),
                    ..._buildActionButtons(
                        context, ref, tx, isReceiver, isSender),
                  ],
                ),

                // Rejection note
                if (tx.responseNote != null && tx.responseNote!.isNotEmpty) ...[
                  const Gap(10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.messageCircle,
                            size: 14, color: AppColors.error),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            tx.responseNote!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.error.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: (80 * index).ms).fadeIn().slideX(begin: 0.03);
  }

  Widget _buildStatusBadge(TransactionStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case TransactionStatus.pending:
        color = AppColors.warning;
        text = 'Pending';
        icon = LucideIcons.clock;
        break;
      case TransactionStatus.accepted:
        color = AppColors.info;
        text = 'Accepted';
        icon = LucideIcons.thumbsUp;
        break;
      case TransactionStatus.rejected:
        color = AppColors.error;
        text = 'Rejected';
        icon = LucideIcons.thumbsDown;
        break;
      case TransactionStatus.settled:
        color = AppColors.success;
        text = 'Settled';
        icon = LucideIcons.checkCircle;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const Gap(4),
          Text(text,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    MoneyTransaction tx,
    bool isReceiver,
    bool isSender,
  ) {
    final buttons = <Widget>[];

    if (tx.status == TransactionStatus.pending && isReceiver) {
      buttons.addAll([
        GestureDetector(
          onTap: () => _acceptTransaction(context, ref, tx),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.2)),
            ),
            child: const Text('Accept',
                style: TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
        ),
        const Gap(8),
        GestureDetector(
          onTap: () => _showRejectDialog(context, ref, tx),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: AppColors.error.withValues(alpha: 0.15)),
            ),
            child: const Text('Reject',
                style: TextStyle(
                    color: AppColors.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
        ),
      ]);
    }

    if (tx.status == TransactionStatus.accepted && isSender) {
      buttons.add(
        GestureDetector(
          onTap: () => _settleTransaction(context, ref, tx),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.2)),
            ),
            child: const Text('Mark Paid',
                style: TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
        ),
      );
    }

    final isAdmin = ref.read(isAdminProvider);
    if (isAdmin && tx.status != TransactionStatus.settled) {
      buttons.add(
        GestureDetector(
          onTap: () {
            HapticService.buttonPress();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) =>
                  AddTransactionSheet(existingTransaction: tx),
            );
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.04),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            child: Icon(
              LucideIcons.edit2,
              size: 13,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  Widget _buildCosmicFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentWarm.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          HapticService.buttonPress();
          _showAddSheet(context);
        },
        icon: const Icon(LucideIcons.plus, size: 20),
        label: const Text('Add Transaction'),
        backgroundColor: AppColors.accentWarm,
        foregroundColor: Colors.white,
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 2.seconds,
          color: Colors.white.withValues(alpha: 0.15),
        );
  }

  void _acceptTransaction(
    BuildContext context,
    WidgetRef ref,
    MoneyTransaction tx,
  ) {
    final currentId = ref.read(currentMemberIdProvider);
    final result = ref
        .read(moneyTransactionsProvider.notifier)
        .acceptTransaction(tx.id, currentId);

    _showResultSnackbar(context, result, 'Transaction accepted!');
  }

  void _showRejectDialog(
    BuildContext context,
    WidgetRef ref,
    MoneyTransaction tx,
  ) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D1520),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        title: Text('Reject Transaction',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
        content: TextField(
          controller: reasonController,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
          decoration: InputDecoration(
            labelText: 'Reason (optional)',
            labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
            hintText: 'Why are you rejecting?',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.03),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide:
                  BorderSide(color: Colors.white.withValues(alpha: 0.06)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide:
                  BorderSide(color: Colors.white.withValues(alpha: 0.06)),
            ),
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style:
                    TextStyle(color: Colors.white.withValues(alpha: 0.4))),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(ctx);
              final currentId = ref.read(currentMemberIdProvider);
              final result = ref
                  .read(moneyTransactionsProvider.notifier)
                  .rejectTransaction(
                    tx.id,
                    currentId,
                    reason: reasonController.text,
                  );
              _showResultSnackbar(context, result, 'Transaction rejected');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: const Text('Reject',
                  style: TextStyle(
                      color: AppColors.error, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  void _settleTransaction(
    BuildContext context,
    WidgetRef ref,
    MoneyTransaction tx,
  ) {
    final currentId = ref.read(currentMemberIdProvider);
    final result = ref
        .read(moneyTransactionsProvider.notifier)
        .settleTransaction(tx.id, currentId);

    _showResultSnackbar(context, result, 'Transaction settled!');
  }

  void _showResultSnackbar(
    BuildContext context,
    TransactionResult result,
    String successMessage,
  ) {
    String message;
    Color color;

    switch (result) {
      case TransactionResult.success:
        HapticService.success();
        message = successMessage;
        color = AppColors.success;
        break;
      case TransactionResult.unauthorized:
        HapticService.error();
        message = 'You are not authorized to perform this action';
        color = AppColors.error;
        break;
      case TransactionResult.alreadyProcessed:
        HapticService.warning();
        message = 'This transaction has already been processed';
        color = AppColors.warning;
        break;
      case TransactionResult.notAccepted:
        HapticService.error();
        message = 'Transaction must be accepted before settling';
        color = AppColors.error;
        break;
      case TransactionResult.requiresPhotoProof:
        HapticService.error();
        message = 'Transactions over ৳500 require photo proof';
        color = AppColors.error;
        break;
      case TransactionResult.notFound:
        HapticService.error();
        message = 'Transaction not found';
        color = AppColors.error;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: color));
  }

  void _showAddSheet(BuildContext context) {
    HapticService.modalOpen();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionSheet(),
    );
  }
}

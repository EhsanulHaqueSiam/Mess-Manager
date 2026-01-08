import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/features/settlement/providers/settlement_provider.dart';

/// Late payment penalty settings
class PenaltySettings {
  final bool isEnabled;
  final double penaltyPercent; // e.g., 5.0 for 5%
  final int gracePeriodDays; // Days before penalty applies
  final double maxPenaltyPercent; // Cap on total penalty
  final bool compoundDaily; // If true, compounds daily after grace period

  const PenaltySettings({
    this.isEnabled = false,
    this.penaltyPercent = 5.0,
    this.gracePeriodDays = 7,
    this.maxPenaltyPercent = 20.0,
    this.compoundDaily = false,
  });

  PenaltySettings copyWith({
    bool? isEnabled,
    double? penaltyPercent,
    int? gracePeriodDays,
    double? maxPenaltyPercent,
    bool? compoundDaily,
  }) {
    return PenaltySettings(
      isEnabled: isEnabled ?? this.isEnabled,
      penaltyPercent: penaltyPercent ?? this.penaltyPercent,
      gracePeriodDays: gracePeriodDays ?? this.gracePeriodDays,
      maxPenaltyPercent: maxPenaltyPercent ?? this.maxPenaltyPercent,
      compoundDaily: compoundDaily ?? this.compoundDaily,
    );
  }
}

/// Penalty settings provider
final penaltySettingsProvider =
    NotifierProvider<PenaltySettingsNotifier, PenaltySettings>(
      PenaltySettingsNotifier.new,
    );

class PenaltySettingsNotifier extends Notifier<PenaltySettings> {
  static const _enabledKey = 'penalty_enabled';
  static const _percentKey = 'penalty_percent';
  static const _graceDaysKey = 'penalty_grace_days';
  static const _maxPercentKey = 'penalty_max_percent';
  static const _compoundKey = 'penalty_compound';

  @override
  PenaltySettings build() {
    final enabled = IsarService.getSetting(_enabledKey);
    final percent = IsarService.getSetting(_percentKey);
    final graceDays = IsarService.getSetting(_graceDaysKey);
    final maxPercent = IsarService.getSetting(_maxPercentKey);
    final compound = IsarService.getSetting(_compoundKey);

    return PenaltySettings(
      isEnabled: enabled == 'true',
      penaltyPercent: double.tryParse(percent ?? '') ?? 5.0,
      gracePeriodDays: int.tryParse(graceDays ?? '') ?? 7,
      maxPenaltyPercent: double.tryParse(maxPercent ?? '') ?? 20.0,
      compoundDaily: compound == 'true',
    );
  }

  void _save() {
    IsarService.saveSetting(_enabledKey, state.isEnabled.toString());
    IsarService.saveSetting(_percentKey, state.penaltyPercent.toString());
    IsarService.saveSetting(_graceDaysKey, state.gracePeriodDays.toString());
    IsarService.saveSetting(_maxPercentKey, state.maxPenaltyPercent.toString());
    IsarService.saveSetting(_compoundKey, state.compoundDaily.toString());
  }

  void setEnabled(bool enabled) {
    state = state.copyWith(isEnabled: enabled);
    _save();
  }

  void setPenaltyPercent(double percent) {
    state = state.copyWith(penaltyPercent: percent.clamp(0.1, 50.0));
    _save();
  }

  void setGracePeriodDays(int days) {
    state = state.copyWith(gracePeriodDays: days.clamp(1, 30));
    _save();
  }

  void setMaxPenaltyPercent(double percent) {
    state = state.copyWith(maxPenaltyPercent: percent.clamp(1.0, 100.0));
    _save();
  }

  void setCompoundDaily(bool compound) {
    state = state.copyWith(compoundDaily: compound);
    _save();
  }
}

/// Calculated penalty for a settlement item
class PenaltyCalculation {
  final String fromMemberId;
  final String toMemberId;
  final double originalAmount;
  final double penaltyAmount;
  final double totalDue;
  final int daysOverdue;
  final bool isPastGracePeriod;

  const PenaltyCalculation({
    required this.fromMemberId,
    required this.toMemberId,
    required this.originalAmount,
    required this.penaltyAmount,
    required this.totalDue,
    required this.daysOverdue,
    required this.isPastGracePeriod,
  });
}

/// Provider for current month's penalty calculations
final penaltyCalculationsProvider = Provider<List<PenaltyCalculation>>((ref) {
  final settings = ref.watch(penaltySettingsProvider);
  final settlement = ref.watch(currentMonthSettlementProvider);

  if (!settings.isEnabled || settlement == null) {
    return [];
  }

  final now = DateTime.now();
  final calculations = <PenaltyCalculation>[];

  for (final item in settlement.items) {
    if (item.isPaid) continue; // Skip paid items

    // Calculate days since settlement was created
    final daysSinceSettlement = now.difference(settlement.calculatedAt).inDays;
    final daysOverdue = daysSinceSettlement - settings.gracePeriodDays;
    final isPastGracePeriod = daysOverdue > 0;

    double penaltyAmount = 0.0;

    if (isPastGracePeriod) {
      if (settings.compoundDaily) {
        // Compound daily: penalty = amount * (1 + rate)^days - amount
        final rate = settings.penaltyPercent / 100;
        final compounded =
            item.amount *
            (1 + rate / 30).clamp(1.0, 1.0 + settings.maxPenaltyPercent / 100);
        penaltyAmount = (compounded - item.amount) * daysOverdue / 30;
      } else {
        // Simple percentage after grace period
        penaltyAmount = item.amount * (settings.penaltyPercent / 100);
      }

      // Cap at max penalty
      final maxPenalty = item.amount * (settings.maxPenaltyPercent / 100);
      penaltyAmount = penaltyAmount.clamp(0, maxPenalty);
    }

    calculations.add(
      PenaltyCalculation(
        fromMemberId: item.fromMemberId,
        toMemberId: item.toMemberId,
        originalAmount: item.amount,
        penaltyAmount: penaltyAmount,
        totalDue: item.amount + penaltyAmount,
        daysOverdue: daysOverdue.clamp(0, 365),
        isPastGracePeriod: isPastGracePeriod,
      ),
    );
  }

  return calculations;
});

/// Total penalty amount this month
final totalPenaltyAmountProvider = Provider<double>((ref) {
  final calculations = ref.watch(penaltyCalculationsProvider);
  return calculations.fold(0.0, (sum, c) => sum + c.penaltyAmount);
});

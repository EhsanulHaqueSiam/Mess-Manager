import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/duty.dart';
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/core/providers/members_provider.dart';

/// Duty schedules provider
final dutySchedulesProvider =
    NotifierProvider<DutySchedulesNotifier, List<DutySchedule>>(
      DutySchedulesNotifier.new,
    );

class DutySchedulesNotifier extends Notifier<List<DutySchedule>> {
  @override
  List<DutySchedule> build() {
    return IsarService.getAllDutySchedules();
  }

  void _save() {
    IsarService.saveDutySchedules(state);
  }

  /// Create a predefined duty schedule
  Future<void> createSchedule({
    required DutyType type,
    required List<String> memberIds,
    int rotationDays = 1,
  }) async {
    final schedule = DutySchedule(
      id: 'sched_${DateTime.now().millisecondsSinceEpoch}',
      messId: 'default',
      type: type,
      rotationOrder: memberIds,
      rotationIntervalDays: rotationDays,
      lastRotatedAt: DateTime.now(),
    );
    state = [...state, schedule];
    _save();
  }

  /// Create a custom-named duty (any member can create)
  Future<DutySchedule> createCustomDuty({
    required String name,
    required String createdByMemberId,
    int rotationDays = 1,
  }) async {
    final schedule = DutySchedule(
      id: 'sched_${DateTime.now().millisecondsSinceEpoch}',
      messId: 'default',
      type: DutyType.custom,
      name: name,
      createdByMemberId: createdByMemberId,
      rotationOrder: [createdByMemberId], // Creator auto-subscribes
      rotationIntervalDays: rotationDays,
      lastRotatedAt: DateTime.now(),
    );
    state = [...state, schedule];
    _save();
    return schedule;
  }

  /// Subscribe a member to a duty (opt-in)
  Future<void> subscribe(String scheduleId, String memberId) async {
    state = state.map((s) {
      if (s.id == scheduleId && !s.rotationOrder.contains(memberId)) {
        return s.copyWith(rotationOrder: [...s.rotationOrder, memberId]);
      }
      return s;
    }).toList();
    _save();
  }

  /// Unsubscribe a member from a duty (opt-out)
  Future<void> unsubscribe(String scheduleId, String memberId) async {
    state = state.map((s) {
      if (s.id == scheduleId) {
        return s.copyWith(
          rotationOrder: s.rotationOrder.where((id) => id != memberId).toList(),
        );
      }
      return s;
    }).toList();
    _save();
  }

  Future<void> updateRotationOrder(
    String scheduleId,
    List<String> newOrder,
  ) async {
    state = state.map((s) {
      if (s.id == scheduleId) {
        return s.copyWith(rotationOrder: newOrder);
      }
      return s;
    }).toList();
    _save();
  }

  Future<void> toggleScheduleActive(String scheduleId) async {
    state = state.map((s) {
      if (s.id == scheduleId) {
        return s.copyWith(isActive: !s.isActive);
      }
      return s;
    }).toList();
    _save();
  }

  Future<void> deleteSchedule(String scheduleId) async {
    state = state.where((s) => s.id != scheduleId).toList();
    _save();
  }
}

/// Duty assignments provider
final dutyAssignmentsProvider =
    NotifierProvider<DutyAssignmentsNotifier, List<DutyAssignment>>(
      DutyAssignmentsNotifier.new,
    );

class DutyAssignmentsNotifier extends Notifier<List<DutyAssignment>> {
  @override
  List<DutyAssignment> build() {
    return IsarService.getAllDutyAssignments();
  }

  void _save() {
    IsarService.saveDutyAssignments(state);
  }

  /// Get today's duties
  List<DutyAssignment> getTodayDuties() {
    final now = DateTime.now();
    return state
        .where(
          (d) =>
              d.date.year == now.year &&
              d.date.month == now.month &&
              d.date.day == now.day,
        )
        .toList();
  }

  /// Get duties for a specific date
  List<DutyAssignment> getDutiesForDate(DateTime date) {
    return state
        .where(
          (d) =>
              d.date.year == date.year &&
              d.date.month == date.month &&
              d.date.day == date.day,
        )
        .toList();
  }

  /// Create assignment
  Future<void> createAssignment({
    required String memberId,
    required DutyType type,
    required DateTime date,
  }) async {
    final assignment = DutyAssignment(
      id: 'duty_${DateTime.now().millisecondsSinceEpoch}',
      messId: 'default',
      memberId: memberId,
      type: type,
      date: date,
    );
    state = [...state, assignment];
    _save();
  }

  /// Mark duty as complete (optionally with photo proof)
  Future<void> markComplete(String dutyId, {String? proofImagePath}) async {
    state = state.map((d) {
      if (d.id == dutyId) {
        return d.copyWith(
          status: DutyStatus.completed,
          completedAt: DateTime.now(),
          proofImagePath: proofImagePath,
        );
      }
      return d;
    }).toList();
    _save();
  }

  /// Skip duty with reason
  Future<void> skipDuty(String dutyId, String reason) async {
    state = state.map((d) {
      if (d.id == dutyId) {
        return d.copyWith(status: DutyStatus.skipped, note: reason);
      }
      return d;
    }).toList();
    _save();
  }

  /// Swap duty with another member
  Future<void> swapDuty(String dutyId, String withMemberId) async {
    state = state.map((d) {
      if (d.id == dutyId) {
        return d.copyWith(
          memberId: withMemberId,
          status: DutyStatus.swapped,
          swappedWithMemberId: d.memberId,
        );
      }
      return d;
    }).toList();
    _save();
  }

  /// Generate duties for next week based on schedules.
  /// Uses fairness-based rotation: assigns to the subscriber
  /// with the fewest actual completions for this duty.
  Future<void> generateWeeklyDuties() async {
    final schedules = ref.read(dutySchedulesProvider);
    final now = DateTime.now();

    for (final schedule in schedules.where((s) => s.isActive)) {
      if (schedule.rotationOrder.isEmpty) continue;

      for (int day = 0; day < 7; day++) {
        final date = now.add(Duration(days: day));

        // Check if duty already exists for this date + this schedule
        final exists = state.any(
          (d) =>
              d.type == schedule.type &&
              (schedule.type != DutyType.custom ||
                  d.note == schedule.name) &&
              d.date.year == date.year &&
              d.date.month == date.month &&
              d.date.day == date.day,
        );

        if (!exists) {
          // Fairness rotation: pick the subscriber with the
          // fewest ACTUAL completions (on-behalf doesn't count
          // for the person who skipped)
          final memberId = _pickFairestMember(schedule);

          final assignment = DutyAssignment(
            id: 'duty_${DateTime.now().millisecondsSinceEpoch}_$day',
            messId: 'default',
            memberId: memberId,
            type: schedule.type,
            date: date,
            // Store custom duty name in note for matching
            note: schedule.type == DutyType.custom ? schedule.name : null,
          );
          state = [...state, assignment];
        }
      }
    }
    _save();
  }

  /// Pick the subscriber with the fewest actual completions.
  /// "Actual" means they personally did it — on-behalf by others
  /// does NOT count for the person who skipped.
  String _pickFairestMember(DutySchedule schedule) {
    final subscribers = schedule.rotationOrder;
    if (subscribers.length == 1) return subscribers.first;

    // Count actual completions per subscriber
    final counts = <String, int>{};
    for (final id in subscribers) {
      counts[id] = 0;
    }

    for (final d in state) {
      if (d.type != schedule.type) continue;
      if (schedule.type == DutyType.custom && d.note != schedule.name) continue;
      if (d.status != DutyStatus.completed &&
          d.status != DutyStatus.approved) continue;

      // Who actually did the work?
      final actualDoer = d.completedByMemberId ?? d.memberId;
      if (counts.containsKey(actualDoer)) {
        counts[actualDoer] = counts[actualDoer]! + 1;
      }
    }

    // Pick subscriber with lowest count (ties broken by rotation order)
    final sorted = subscribers.toList()
      ..sort((a, b) => (counts[a] ?? 0).compareTo(counts[b] ?? 0));
    return sorted.first;
  }

  // ===== DISPUTE & APPROVAL METHODS =====

  /// Dispute a completed duty (by another member)
  Future<void> disputeDuty({
    required String dutyId,
    required String disputedBy,
    required String reason,
    String? disputePhotoPath,
  }) async {
    state = state.map((d) {
      if (d.id == dutyId && d.status == DutyStatus.completed) {
        return d.copyWith(
          status: DutyStatus.disputed,
          disputedBy: disputedBy,
          disputeReason: reason,
          disputePhotoPath: disputePhotoPath,
          disputedAt: DateTime.now(),
        );
      }
      return d;
    }).toList();
    _save();
  }

  /// Admin approves a duty (completed or disputed)
  Future<void> approveDuty({
    required String dutyId,
    required String reviewedBy,
    String? adminNotes,
  }) async {
    state = state.map((d) {
      if (d.id == dutyId) {
        return d.copyWith(
          status: DutyStatus.approved,
          reviewedBy: reviewedBy,
          reviewedAt: DateTime.now(),
          adminNotes: adminNotes,
        );
      }
      return d;
    }).toList();
    _save();
  }

  /// Admin rejects a duty completion
  Future<void> rejectDuty({
    required String dutyId,
    required String reviewedBy,
    String? adminNotes,
  }) async {
    state = state.map((d) {
      if (d.id == dutyId) {
        return d.copyWith(
          status: DutyStatus.rejected,
          reviewedBy: reviewedBy,
          reviewedAt: DateTime.now(),
          adminNotes: adminNotes,
        );
      }
      return d;
    }).toList();
    _save();
  }

  /// Mark duty as completed by substitute (someone else did it)
  /// This creates a duty debt for the original assignee
  Future<void> markCompletedBySubstitute({
    required String dutyId,
    required String completedByMemberId,
    String? proofImagePath,
  }) async {
    final duty = state.firstWhere((d) => d.id == dutyId);

    state = state.map((d) {
      if (d.id == dutyId) {
        return d.copyWith(
          status: DutyStatus.completed,
          completedAt: DateTime.now(),
          completedByMemberId: completedByMemberId,
          proofImagePath: proofImagePath,
        );
      }
      return d;
    }).toList();
    _save();

    // Create duty debt
    await ref
        .read(dutyDebtsProvider.notifier)
        .createDebt(
          debtorId: duty.memberId,
          creditorId: completedByMemberId,
          dutyType: duty.type,
          originalDutyId: dutyId,
        );
  }

  /// Get disputed duties (for admin review)
  List<DutyAssignment> getDisputedDuties() {
    return state.where((d) => d.status == DutyStatus.disputed).toList();
  }

  /// Get duties awaiting approval
  List<DutyAssignment> getPendingApproval() {
    return state
        .where(
          (d) =>
              d.status == DutyStatus.completed ||
              d.status == DutyStatus.disputed,
        )
        .toList();
  }
}

// ===== DUTY DEBTS PROVIDER =====

/// Provider for duty debts (substitute tracking)
final dutyDebtsProvider = NotifierProvider<DutyDebtsNotifier, List<DutyDebt>>(
  DutyDebtsNotifier.new,
);

class DutyDebtsNotifier extends Notifier<List<DutyDebt>> {
  @override
  List<DutyDebt> build() {
    return IsarService.getAllDutyDebts();
  }

  void _save() {
    IsarService.saveDutyDebts(state);
  }

  /// Create a new duty debt
  Future<void> createDebt({
    required String debtorId,
    required String creditorId,
    required DutyType dutyType,
    required String originalDutyId,
  }) async {
    final debt = DutyDebt(
      id: 'debt_${DateTime.now().millisecondsSinceEpoch}',
      debtorId: debtorId,
      creditorId: creditorId,
      dutyType: dutyType,
      date: DateTime.now(),
      originalDutyId: originalDutyId,
    );
    state = [...state, debt];
    _save();
  }

  /// Settle a debt (when debtor does creditor's duty)
  Future<void> settleDebt(String debtId, String settledByDutyId) async {
    state = state.map((d) {
      if (d.id == debtId) {
        return d.copyWith(
          isSettled: true,
          settledAt: DateTime.now(),
          settledByDutyId: settledByDutyId,
        );
      }
      return d;
    }).toList();
    _save();
  }

  /// Get unsettled debts for a member
  List<DutyDebt> getDebtsForMember(String memberId) {
    return state.where((d) => d.debtorId == memberId && !d.isSettled).toList();
  }

  /// Get credits for a member (duties they did for others)
  List<DutyDebt> getCreditsForMember(String memberId) {
    return state
        .where((d) => d.creditorId == memberId && !d.isSettled)
        .toList();
  }
}

/// Auto-generate upcoming duties if none exist for today
/// Call this from app startup or a periodic timer
final dutyAutoGenerateProvider = FutureProvider<void>((ref) async {
  final assignments = ref.watch(dutyAssignmentsProvider);
  final now = DateTime.now();

  // Check if today has any duties assigned
  final todayExists = assignments.any(
    (d) =>
        d.date.year == now.year &&
        d.date.month == now.month &&
        d.date.day == now.day,
  );

  if (!todayExists) {
    // Auto-generate for the next 7 days
    await ref.read(dutyAssignmentsProvider.notifier).generateWeeklyDuties();
  }
});

/// Today's duties provider
final todayDutiesProvider = Provider<List<DutyAssignment>>((ref) {
  final duties = ref.watch(dutyAssignmentsProvider);
  final now = DateTime.now();
  return duties
      .where(
        (d) =>
            d.date.year == now.year &&
            d.date.month == now.month &&
            d.date.day == now.day,
      )
      .toList();
});

/// Current member's pending duties
final myPendingDutiesProvider = Provider<List<DutyAssignment>>((ref) {
  final duties = ref.watch(dutyAssignmentsProvider);
  final memberId = ref.watch(currentMemberIdProvider);

  return duties
      .where((d) => d.memberId == memberId && d.status == DutyStatus.pending)
      .toList();
});

/// Duty completion stats for the week
final weeklyDutyStatsProvider = Provider<Map<String, int>>((ref) {
  final duties = ref.watch(dutyAssignmentsProvider);
  final now = DateTime.now();
  final weekStart = now.subtract(Duration(days: now.weekday - 1));

  final weekDuties = duties
      .where(
        (d) =>
            d.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
            d.date.isBefore(weekStart.add(const Duration(days: 7))),
      )
      .toList();

  return {
    'total': weekDuties.length,
    'completed': weekDuties
        .where((d) => d.status == DutyStatus.completed)
        .length,
    'pending': weekDuties.where((d) => d.status == DutyStatus.pending).length,
    'skipped': weekDuties.where((d) => d.status == DutyStatus.skipped).length,
  };
});

// ═══════════════════════════════════════════════════════════════
// FAIRNESS SCOREBOARD
// ═══════════════════════════════════════════════════════════════

/// Per-member actual completion count for a specific duty schedule.
/// "Actual" means they personally did the work.
/// On-behalf by someone else does NOT count for the skipper.
class DutyScoreEntry {
  final String memberId;
  final int actualCompletions; // Times they personally did it
  final int onBehalfDone; // Times someone else did it for them
  final int owedDuties; // Unsettled debts (times they skipped)

  const DutyScoreEntry({
    required this.memberId,
    required this.actualCompletions,
    required this.onBehalfDone,
    required this.owedDuties,
  });
}

/// Fairness scoreboard for a specific duty schedule.
/// Shows actual completions per subscriber — everyone's count should be equal.
final dutyScoreboardProvider =
    Provider.family<List<DutyScoreEntry>, String>((ref, scheduleId) {
  final schedules = ref.watch(dutySchedulesProvider);
  final duties = ref.watch(dutyAssignmentsProvider);
  final debts = ref.watch(dutyDebtsProvider);

  final schedule = schedules.where((s) => s.id == scheduleId).firstOrNull;
  if (schedule == null) return [];

  return schedule.rotationOrder.map((memberId) {
    // Count duties where this member actually did the work
    int actualCompletions = 0;
    int onBehalfDone = 0;

    for (final d in duties) {
      if (d.type != schedule.type) continue;
      if (schedule.type == DutyType.custom && d.note != schedule.name) continue;
      if (d.status != DutyStatus.completed &&
          d.status != DutyStatus.approved) continue;

      final actualDoer = d.completedByMemberId ?? d.memberId;

      if (actualDoer == memberId) {
        actualCompletions++;
      }
      // Assigned to this member but someone else did it
      if (d.memberId == memberId && d.completedByMemberId != null) {
        onBehalfDone++;
      }
    }

    // Count unsettled debts
    final owedDuties = debts
        .where((debt) =>
            debt.debtorId == memberId &&
            debt.dutyType == schedule.type &&
            !debt.isSettled)
        .length;

    return DutyScoreEntry(
      memberId: memberId,
      actualCompletions: actualCompletions,
      onBehalfDone: onBehalfDone,
      owedDuties: owedDuties,
    );
  }).toList();
});

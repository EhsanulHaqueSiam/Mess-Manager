import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/duty.dart';
import 'package:mess_manager/core/services/storage_service.dart';
import 'package:mess_manager/core/providers/members_provider.dart';

/// Duty schedules provider
final dutySchedulesProvider =
    NotifierProvider<DutySchedulesNotifier, List<DutySchedule>>(
      DutySchedulesNotifier.new,
    );

class DutySchedulesNotifier extends Notifier<List<DutySchedule>> {
  @override
  List<DutySchedule> build() {
    return StorageService.loadList<DutySchedule>(
      boxName: 'duty_schedules',
      fromJson: DutySchedule.fromJson,
    );
  }

  Future<void> _save() async {
    await StorageService.saveList(
      boxName: 'duty_schedules',
      items: state,
      toJson: (s) => s.toJson(),
    );
  }

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
    await _save();
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
    await _save();
  }

  Future<void> toggleScheduleActive(String scheduleId) async {
    state = state.map((s) {
      if (s.id == scheduleId) {
        return s.copyWith(isActive: !s.isActive);
      }
      return s;
    }).toList();
    await _save();
  }

  Future<void> deleteSchedule(String scheduleId) async {
    state = state.where((s) => s.id != scheduleId).toList();
    await _save();
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
    return StorageService.loadList<DutyAssignment>(
      boxName: 'duty_assignments',
      fromJson: DutyAssignment.fromJson,
    );
  }

  Future<void> _save() async {
    await StorageService.saveList(
      boxName: 'duty_assignments',
      items: state,
      toJson: (a) => a.toJson(),
    );
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
    await _save();
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
    await _save();
  }

  /// Skip duty with reason
  Future<void> skipDuty(String dutyId, String reason) async {
    state = state.map((d) {
      if (d.id == dutyId) {
        return d.copyWith(status: DutyStatus.skipped, note: reason);
      }
      return d;
    }).toList();
    await _save();
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
    await _save();
  }

  /// Generate duties for next week based on schedules
  Future<void> generateWeeklyDuties() async {
    final schedules = ref.read(dutySchedulesProvider);
    final now = DateTime.now();

    for (final schedule in schedules.where((s) => s.isActive)) {
      if (schedule.rotationOrder.isEmpty) continue;

      for (int day = 0; day < 7; day++) {
        final date = now.add(Duration(days: day));

        // Check if duty already exists for this date/type
        final exists = state.any(
          (d) =>
              d.type == schedule.type &&
              d.date.year == date.year &&
              d.date.month == date.month &&
              d.date.day == date.day,
        );

        if (!exists) {
          // Determine whose turn it is based on rotation
          final daysSinceStart = date
              .difference(schedule.lastRotatedAt ?? now)
              .inDays;
          final memberIndex =
              (daysSinceStart ~/ schedule.rotationIntervalDays) %
              schedule.rotationOrder.length;
          final memberId = schedule.rotationOrder[memberIndex];

          await createAssignment(
            memberId: memberId,
            type: schedule.type,
            date: date,
          );
        }
      }
    }
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
    await _save();
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
    await _save();
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
    await _save();
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
    await _save();

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
    return StorageService.loadList<DutyDebt>(
      boxName: 'duty_debts',
      fromJson: DutyDebt.fromJson,
    );
  }

  Future<void> _save() async {
    await StorageService.saveList(
      boxName: 'duty_debts',
      items: state,
      toJson: (d) => d.toJson(),
    );
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
    await _save();
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
    await _save();
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

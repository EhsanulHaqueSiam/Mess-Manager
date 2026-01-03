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

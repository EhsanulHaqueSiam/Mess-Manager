import 'dart:convert';
import 'package:isar_plus/isar_plus.dart';
import '../../models/duty.dart';

part 'duty_collection.g.dart';

/// Isar collection for DutyAssignment data
@collection
class DutyAssignmentCollection {
  late int id;

  @Index()
  late String assignmentId;

  late String messId;

  @Index()
  late String memberId;

  /// DutyType as int index
  late int typeIndex;

  @Index()
  late DateTime date;

  /// DutyStatus as int index
  late int statusIndex;

  DateTime? completedAt;
  String? proofImagePath;
  String? note;
  String? swappedWithMemberId;
  String? disputedBy;
  String? disputePhotoPath;
  String? disputeReason;
  DateTime? disputedAt;
  String? adminNotes;
  String? reviewedBy;
  DateTime? reviewedAt;
  String? completedByMemberId;

  // ─────────────────────────────────────────────────────────────────────────
  // Model Converters
  // ─────────────────────────────────────────────────────────────────────────

  DutyAssignment toModel() {
    return DutyAssignment(
      id: assignmentId,
      messId: messId,
      memberId: memberId,
      type: DutyType.values[typeIndex],
      date: date,
      status: DutyStatus.values[statusIndex],
      completedAt: completedAt,
      proofImagePath: proofImagePath,
      note: note,
      swappedWithMemberId: swappedWithMemberId,
      disputedBy: disputedBy,
      disputePhotoPath: disputePhotoPath,
      disputeReason: disputeReason,
      disputedAt: disputedAt,
      adminNotes: adminNotes,
      reviewedBy: reviewedBy,
      reviewedAt: reviewedAt,
      completedByMemberId: completedByMemberId,
    );
  }

  static DutyAssignmentCollection fromModel(DutyAssignment d) {
    return DutyAssignmentCollection()
      ..assignmentId = d.id
      ..messId = d.messId
      ..memberId = d.memberId
      ..typeIndex = d.type.index
      ..date = d.date
      ..statusIndex = d.status.index
      ..completedAt = d.completedAt
      ..proofImagePath = d.proofImagePath
      ..note = d.note
      ..swappedWithMemberId = d.swappedWithMemberId
      ..disputedBy = d.disputedBy
      ..disputePhotoPath = d.disputePhotoPath
      ..disputeReason = d.disputeReason
      ..disputedAt = d.disputedAt
      ..adminNotes = d.adminNotes
      ..reviewedBy = d.reviewedBy
      ..reviewedAt = d.reviewedAt
      ..completedByMemberId = d.completedByMemberId;
  }
}

/// Isar collection for DutySchedule data
@collection
class DutyScheduleCollection {
  late int id;

  @Index()
  late String scheduleId;

  late String messId;

  late int typeIndex;

  /// Rotation order as JSON array of member IDs
  late String rotationOrderJson;

  late int rotationIntervalDays;

  DateTime? lastRotatedAt;

  late bool isActive;

  // ─────────────────────────────────────────────────────────────────────────
  // Model Converters
  // ─────────────────────────────────────────────────────────────────────────

  DutySchedule toModel() {
    List<String> rotationOrder = [];
    try {
      rotationOrder = List<String>.from(jsonDecode(rotationOrderJson));
    } catch (_) {}

    return DutySchedule(
      id: scheduleId,
      messId: messId,
      type: DutyType.values[typeIndex],
      rotationOrder: rotationOrder,
      rotationIntervalDays: rotationIntervalDays,
      lastRotatedAt: lastRotatedAt,
      isActive: isActive,
    );
  }

  static DutyScheduleCollection fromModel(DutySchedule s) {
    return DutyScheduleCollection()
      ..scheduleId = s.id
      ..messId = s.messId
      ..typeIndex = s.type.index
      ..rotationOrderJson = jsonEncode(s.rotationOrder)
      ..rotationIntervalDays = s.rotationIntervalDays
      ..lastRotatedAt = s.lastRotatedAt
      ..isActive = s.isActive;
  }
}

/// Isar collection for DutyDebt data
@collection
class DutyDebtCollection {
  late int id;

  @Index()
  late String debtId;

  @Index()
  late String debtorId;

  @Index()
  late String creditorId;

  late int dutyTypeIndex;

  late DateTime date;

  late String originalDutyId;

  late bool isSettled;

  DateTime? settledAt;

  String? settledByDutyId;

  // ─────────────────────────────────────────────────────────────────────────
  // Model Converters
  // ─────────────────────────────────────────────────────────────────────────

  DutyDebt toModel() {
    return DutyDebt(
      id: debtId,
      debtorId: debtorId,
      creditorId: creditorId,
      dutyType: DutyType.values[dutyTypeIndex],
      date: date,
      originalDutyId: originalDutyId,
      isSettled: isSettled,
      settledAt: settledAt,
      settledByDutyId: settledByDutyId,
    );
  }

  static DutyDebtCollection fromModel(DutyDebt d) {
    return DutyDebtCollection()
      ..debtId = d.id
      ..debtorId = d.debtorId
      ..creditorId = d.creditorId
      ..dutyTypeIndex = d.dutyType.index
      ..date = d.date
      ..originalDutyId = d.originalDutyId
      ..isSettled = d.isSettled
      ..settledAt = d.settledAt
      ..settledByDutyId = d.settledByDutyId;
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'duty.freezed.dart';
part 'duty.g.dart';

/// Duty types available in a mess
enum DutyType {
  roomCleaning, // Clean rooms
  diningCleanup, // Clean dining area after meals
  bazarDuty, // Go for bazar shopping
  garbageDisposal, // Take out garbage
  cooking, // Cooking duty (if applicable)
}

/// Status of a duty assignment
enum DutyStatus {
  pending, // Not yet started
  completed, // Marked as done
  skipped, // Skipped (with reason)
  swapped, // Swapped with another member
}

/// A single duty assignment
@freezed
sealed class DutyAssignment with _$DutyAssignment {
  const factory DutyAssignment({
    required String id,
    required String messId,
    required String memberId,
    required DutyType type,
    required DateTime date,
    @Default(DutyStatus.pending) DutyStatus status,
    DateTime? completedAt,
    String? proofImagePath, // Photo proof
    String? note,
    String? swappedWithMemberId, // If swapped
  }) = _DutyAssignment;

  factory DutyAssignment.fromJson(Map<String, dynamic> json) =>
      _$DutyAssignmentFromJson(json);
}

/// Weekly duty schedule configuration
@freezed
sealed class DutySchedule with _$DutySchedule {
  const factory DutySchedule({
    required String id,
    required String messId,
    required DutyType type,
    required List<String> rotationOrder, // Member IDs in rotation order
    @Default(1) int rotationIntervalDays, // Days per assignment
    DateTime? lastRotatedAt,
    @Default(true) bool isActive,
  }) = _DutySchedule;

  factory DutySchedule.fromJson(Map<String, dynamic> json) =>
      _$DutyScheduleFromJson(json);
}

/// Swap request between members
@freezed
sealed class DutySwapRequest with _$DutySwapRequest {
  const factory DutySwapRequest({
    required String id,
    required String dutyId,
    required String fromMemberId,
    required String toMemberId,
    required DateTime requestedAt,
    @Default(false) bool isApproved,
    DateTime? respondedAt,
    String? message,
  }) = _DutySwapRequest;

  factory DutySwapRequest.fromJson(Map<String, dynamic> json) =>
      _$DutySwapRequestFromJson(json);
}

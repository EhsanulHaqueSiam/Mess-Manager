// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'duty.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DutyAssignment _$DutyAssignmentFromJson(Map<String, dynamic> json) =>
    _DutyAssignment(
      id: json['id'] as String,
      messId: json['messId'] as String,
      memberId: json['memberId'] as String,
      type: $enumDecode(_$DutyTypeEnumMap, json['type']),
      date: DateTime.parse(json['date'] as String),
      status:
          $enumDecodeNullable(_$DutyStatusEnumMap, json['status']) ??
          DutyStatus.pending,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      proofImagePath: json['proofImagePath'] as String?,
      note: json['note'] as String?,
      swappedWithMemberId: json['swappedWithMemberId'] as String?,
      disputedBy: json['disputedBy'] as String?,
      disputePhotoPath: json['disputePhotoPath'] as String?,
      disputeReason: json['disputeReason'] as String?,
      disputedAt: json['disputedAt'] == null
          ? null
          : DateTime.parse(json['disputedAt'] as String),
      adminNotes: json['adminNotes'] as String?,
      reviewedBy: json['reviewedBy'] as String?,
      reviewedAt: json['reviewedAt'] == null
          ? null
          : DateTime.parse(json['reviewedAt'] as String),
      completedByMemberId: json['completedByMemberId'] as String?,
    );

Map<String, dynamic> _$DutyAssignmentToJson(_DutyAssignment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'messId': instance.messId,
      'memberId': instance.memberId,
      'type': _$DutyTypeEnumMap[instance.type]!,
      'date': instance.date.toIso8601String(),
      'status': _$DutyStatusEnumMap[instance.status]!,
      'completedAt': instance.completedAt?.toIso8601String(),
      'proofImagePath': instance.proofImagePath,
      'note': instance.note,
      'swappedWithMemberId': instance.swappedWithMemberId,
      'disputedBy': instance.disputedBy,
      'disputePhotoPath': instance.disputePhotoPath,
      'disputeReason': instance.disputeReason,
      'disputedAt': instance.disputedAt?.toIso8601String(),
      'adminNotes': instance.adminNotes,
      'reviewedBy': instance.reviewedBy,
      'reviewedAt': instance.reviewedAt?.toIso8601String(),
      'completedByMemberId': instance.completedByMemberId,
    };

const _$DutyTypeEnumMap = {
  DutyType.roomCleaning: 'roomCleaning',
  DutyType.diningCleanup: 'diningCleanup',
  DutyType.bazarDuty: 'bazarDuty',
  DutyType.garbageDisposal: 'garbageDisposal',
  DutyType.cooking: 'cooking',
};

const _$DutyStatusEnumMap = {
  DutyStatus.pending: 'pending',
  DutyStatus.completed: 'completed',
  DutyStatus.disputed: 'disputed',
  DutyStatus.approved: 'approved',
  DutyStatus.rejected: 'rejected',
  DutyStatus.skipped: 'skipped',
  DutyStatus.swapped: 'swapped',
};

_DutySchedule _$DutyScheduleFromJson(Map<String, dynamic> json) =>
    _DutySchedule(
      id: json['id'] as String,
      messId: json['messId'] as String,
      type: $enumDecode(_$DutyTypeEnumMap, json['type']),
      rotationOrder: (json['rotationOrder'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      rotationIntervalDays:
          (json['rotationIntervalDays'] as num?)?.toInt() ?? 1,
      lastRotatedAt: json['lastRotatedAt'] == null
          ? null
          : DateTime.parse(json['lastRotatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$DutyScheduleToJson(_DutySchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'messId': instance.messId,
      'type': _$DutyTypeEnumMap[instance.type]!,
      'rotationOrder': instance.rotationOrder,
      'rotationIntervalDays': instance.rotationIntervalDays,
      'lastRotatedAt': instance.lastRotatedAt?.toIso8601String(),
      'isActive': instance.isActive,
    };

_DutySwapRequest _$DutySwapRequestFromJson(Map<String, dynamic> json) =>
    _DutySwapRequest(
      id: json['id'] as String,
      dutyId: json['dutyId'] as String,
      fromMemberId: json['fromMemberId'] as String,
      toMemberId: json['toMemberId'] as String,
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      isApproved: json['isApproved'] as bool? ?? false,
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$DutySwapRequestToJson(_DutySwapRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dutyId': instance.dutyId,
      'fromMemberId': instance.fromMemberId,
      'toMemberId': instance.toMemberId,
      'requestedAt': instance.requestedAt.toIso8601String(),
      'isApproved': instance.isApproved,
      'respondedAt': instance.respondedAt?.toIso8601String(),
      'message': instance.message,
    };

_DutyDebt _$DutyDebtFromJson(Map<String, dynamic> json) => _DutyDebt(
  id: json['id'] as String,
  debtorId: json['debtorId'] as String,
  creditorId: json['creditorId'] as String,
  dutyType: $enumDecode(_$DutyTypeEnumMap, json['dutyType']),
  date: DateTime.parse(json['date'] as String),
  originalDutyId: json['originalDutyId'] as String,
  isSettled: json['isSettled'] as bool? ?? false,
  settledAt: json['settledAt'] == null
      ? null
      : DateTime.parse(json['settledAt'] as String),
  settledByDutyId: json['settledByDutyId'] as String?,
);

Map<String, dynamic> _$DutyDebtToJson(_DutyDebt instance) => <String, dynamic>{
  'id': instance.id,
  'debtorId': instance.debtorId,
  'creditorId': instance.creditorId,
  'dutyType': _$DutyTypeEnumMap[instance.dutyType]!,
  'date': instance.date.toIso8601String(),
  'originalDutyId': instance.originalDutyId,
  'isSettled': instance.isSettled,
  'settledAt': instance.settledAt?.toIso8601String(),
  'settledByDutyId': instance.settledByDutyId,
};

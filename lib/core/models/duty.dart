/// Duty types available in a mess
/// Use [custom] with DutySchedule.name for user-created duties
enum DutyType {
  roomCleaning, // Clean rooms
  diningCleanup, // Clean dining area after meals
  bazarDuty, // Go for bazar shopping
  garbageDisposal, // Take out garbage
  cooking, // Cooking duty (if applicable)
  custom, // User-defined duty — name stored in DutySchedule.name
}

/// Status of a duty assignment
enum DutyStatus {
  pending, // Not yet started
  completed, // Marked as done (awaiting verification)
  disputed, // Another user disputed completion
  approved, // Admin verified as complete
  rejected, // Admin rejected completion
  skipped, // Skipped (with reason)
  swapped, // Swapped with another member
}

/// A single duty assignment
class DutyAssignment {
  final String id;
  final String messId;
  final String memberId;
  final DutyType type;
  final DateTime date;
  final DutyStatus status;
  final DateTime? completedAt;
  final String? proofImagePath; // Photo proof when completing
  final String? note;
  final String? swappedWithMemberId; // If swapped
  // Dispute fields
  final String? disputedBy; // Member ID who disputed
  final String? disputePhotoPath; // Counter-evidence photo
  final String? disputeReason; // Reason for dispute
  final DateTime? disputedAt;
  // Admin review
  final String? adminNotes;
  final String? reviewedBy; // Admin who reviewed
  final DateTime? reviewedAt;
  // Substitute tracking
  final String? completedByMemberId; // If someone else did this duty

  const DutyAssignment({
    required this.id,
    required this.messId,
    required this.memberId,
    required this.type,
    required this.date,
    this.status = DutyStatus.pending,
    this.completedAt,
    this.proofImagePath,
    this.note,
    this.swappedWithMemberId,
    this.disputedBy,
    this.disputePhotoPath,
    this.disputeReason,
    this.disputedAt,
    this.adminNotes,
    this.reviewedBy,
    this.reviewedAt,
    this.completedByMemberId,
  });

  DutyAssignment copyWith({
    String? id,
    String? messId,
    String? memberId,
    DutyType? type,
    DateTime? date,
    DutyStatus? status,
    DateTime? completedAt,
    String? proofImagePath,
    String? note,
    String? swappedWithMemberId,
    String? disputedBy,
    String? disputePhotoPath,
    String? disputeReason,
    DateTime? disputedAt,
    String? adminNotes,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? completedByMemberId,
  }) {
    return DutyAssignment(
      id: id ?? this.id,
      messId: messId ?? this.messId,
      memberId: memberId ?? this.memberId,
      type: type ?? this.type,
      date: date ?? this.date,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      proofImagePath: proofImagePath ?? this.proofImagePath,
      note: note ?? this.note,
      swappedWithMemberId: swappedWithMemberId ?? this.swappedWithMemberId,
      disputedBy: disputedBy ?? this.disputedBy,
      disputePhotoPath: disputePhotoPath ?? this.disputePhotoPath,
      disputeReason: disputeReason ?? this.disputeReason,
      disputedAt: disputedAt ?? this.disputedAt,
      adminNotes: adminNotes ?? this.adminNotes,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      completedByMemberId: completedByMemberId ?? this.completedByMemberId,
    );
  }

  factory DutyAssignment.fromJson(Map<String, dynamic> json) {
    return DutyAssignment(
      id: json['id'] as String? ?? '',
      messId: json['messId'] as String? ?? '',
      memberId: json['memberId'] as String? ?? '',
      type: _dutyTypeFromJson(json['type']),
      date: DateTime.parse(json['date'] as String),
      status: _dutyStatusFromJson(json['status']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      proofImagePath: json['proofImagePath'] as String?,
      note: json['note'] as String?,
      swappedWithMemberId: json['swappedWithMemberId'] as String?,
      disputedBy: json['disputedBy'] as String?,
      disputePhotoPath: json['disputePhotoPath'] as String?,
      disputeReason: json['disputeReason'] as String?,
      disputedAt: json['disputedAt'] != null
          ? DateTime.parse(json['disputedAt'] as String)
          : null,
      adminNotes: json['adminNotes'] as String?,
      reviewedBy: json['reviewedBy'] as String?,
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'] as String)
          : null,
      completedByMemberId: json['completedByMemberId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messId': messId,
      'memberId': memberId,
      'type': type.name,
      'date': date.toIso8601String(),
      'status': status.name,
      'completedAt': completedAt?.toIso8601String(),
      'proofImagePath': proofImagePath,
      'note': note,
      'swappedWithMemberId': swappedWithMemberId,
      'disputedBy': disputedBy,
      'disputePhotoPath': disputePhotoPath,
      'disputeReason': disputeReason,
      'disputedAt': disputedAt?.toIso8601String(),
      'adminNotes': adminNotes,
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt?.toIso8601String(),
      'completedByMemberId': completedByMemberId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DutyAssignment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          messId == other.messId &&
          memberId == other.memberId &&
          type == other.type &&
          date == other.date &&
          status == other.status &&
          completedAt == other.completedAt &&
          proofImagePath == other.proofImagePath &&
          note == other.note &&
          swappedWithMemberId == other.swappedWithMemberId &&
          disputedBy == other.disputedBy &&
          disputePhotoPath == other.disputePhotoPath &&
          disputeReason == other.disputeReason &&
          disputedAt == other.disputedAt &&
          adminNotes == other.adminNotes &&
          reviewedBy == other.reviewedBy &&
          reviewedAt == other.reviewedAt &&
          completedByMemberId == other.completedByMemberId;

  @override
  int get hashCode => Object.hash(
        id,
        messId,
        memberId,
        type,
        date,
        status,
        completedAt,
        proofImagePath,
        note,
        swappedWithMemberId,
        disputedBy,
        disputePhotoPath,
        disputeReason,
        disputedAt,
        adminNotes,
        reviewedBy,
        reviewedAt,
        completedByMemberId,
      );

  @override
  String toString() =>
      'DutyAssignment(id: $id, messId: $messId, memberId: $memberId, type: $type, date: $date, status: $status)';
}

/// Duty schedule configuration
/// Members subscribe to duties and rotate among subscribers.
/// Rotation is fairness-based: next turn goes to member with fewest completions.
class DutySchedule {
  final String id;
  final String messId;
  final DutyType type;
  final String? name; // Custom name (used when type == custom)
  final String? createdByMemberId; // Who created this duty
  final List<String> rotationOrder; // Subscribed member IDs
  final int rotationIntervalDays; // Days per assignment
  final DateTime? lastRotatedAt;
  final bool isActive;

  const DutySchedule({
    required this.id,
    required this.messId,
    required this.type,
    this.name,
    this.createdByMemberId,
    required this.rotationOrder,
    this.rotationIntervalDays = 1,
    this.lastRotatedAt,
    this.isActive = true,
  });

  /// Display name: custom name or enum name
  String get displayName => name ?? type.name;

  DutySchedule copyWith({
    String? id,
    String? messId,
    DutyType? type,
    String? name,
    String? createdByMemberId,
    List<String>? rotationOrder,
    int? rotationIntervalDays,
    DateTime? lastRotatedAt,
    bool? isActive,
  }) {
    return DutySchedule(
      id: id ?? this.id,
      messId: messId ?? this.messId,
      type: type ?? this.type,
      name: name ?? this.name,
      createdByMemberId: createdByMemberId ?? this.createdByMemberId,
      rotationOrder: rotationOrder ?? this.rotationOrder,
      rotationIntervalDays: rotationIntervalDays ?? this.rotationIntervalDays,
      lastRotatedAt: lastRotatedAt ?? this.lastRotatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  factory DutySchedule.fromJson(Map<String, dynamic> json) {
    return DutySchedule(
      id: json['id'] as String? ?? '',
      messId: json['messId'] as String? ?? '',
      type: _dutyTypeFromJson(json['type']),
      name: json['name'] as String?,
      createdByMemberId: json['createdByMemberId'] as String?,
      rotationOrder: List<String>.from(json['rotationOrder'] ?? []),
      rotationIntervalDays: (json['rotationIntervalDays'] ?? 1) as int,
      lastRotatedAt: json['lastRotatedAt'] != null
          ? DateTime.parse(json['lastRotatedAt'] as String)
          : null,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messId': messId,
      'type': type.name,
      'name': name,
      'createdByMemberId': createdByMemberId,
      'rotationOrder': rotationOrder,
      'rotationIntervalDays': rotationIntervalDays,
      'lastRotatedAt': lastRotatedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DutySchedule &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          messId == other.messId &&
          type == other.type &&
          name == other.name &&
          rotationIntervalDays == other.rotationIntervalDays &&
          lastRotatedAt == other.lastRotatedAt &&
          isActive == other.isActive;

  @override
  int get hashCode => Object.hash(
        id,
        messId,
        type,
        name,
        rotationIntervalDays,
        lastRotatedAt,
        isActive,
      );

  @override
  String toString() =>
      'DutySchedule(id: $id, messId: $messId, type: $type, isActive: $isActive)';
}

/// Swap request between members
class DutySwapRequest {
  final String id;
  final String dutyId;
  final String fromMemberId;
  final String toMemberId;
  final DateTime requestedAt;
  final bool isApproved;
  final DateTime? respondedAt;
  final String? message;

  const DutySwapRequest({
    required this.id,
    required this.dutyId,
    required this.fromMemberId,
    required this.toMemberId,
    required this.requestedAt,
    this.isApproved = false,
    this.respondedAt,
    this.message,
  });

  DutySwapRequest copyWith({
    String? id,
    String? dutyId,
    String? fromMemberId,
    String? toMemberId,
    DateTime? requestedAt,
    bool? isApproved,
    DateTime? respondedAt,
    String? message,
  }) {
    return DutySwapRequest(
      id: id ?? this.id,
      dutyId: dutyId ?? this.dutyId,
      fromMemberId: fromMemberId ?? this.fromMemberId,
      toMemberId: toMemberId ?? this.toMemberId,
      requestedAt: requestedAt ?? this.requestedAt,
      isApproved: isApproved ?? this.isApproved,
      respondedAt: respondedAt ?? this.respondedAt,
      message: message ?? this.message,
    );
  }

  factory DutySwapRequest.fromJson(Map<String, dynamic> json) {
    return DutySwapRequest(
      id: json['id'] as String? ?? '',
      dutyId: json['dutyId'] as String? ?? '',
      fromMemberId: json['fromMemberId'] as String? ?? '',
      toMemberId: json['toMemberId'] as String? ?? '',
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      isApproved: json['isApproved'] ?? false,
      respondedAt: json['respondedAt'] != null
          ? DateTime.parse(json['respondedAt'] as String)
          : null,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dutyId': dutyId,
      'fromMemberId': fromMemberId,
      'toMemberId': toMemberId,
      'requestedAt': requestedAt.toIso8601String(),
      'isApproved': isApproved,
      'respondedAt': respondedAt?.toIso8601String(),
      'message': message,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DutySwapRequest &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          dutyId == other.dutyId &&
          fromMemberId == other.fromMemberId &&
          toMemberId == other.toMemberId &&
          requestedAt == other.requestedAt &&
          isApproved == other.isApproved &&
          respondedAt == other.respondedAt &&
          message == other.message;

  @override
  int get hashCode => Object.hash(
        id,
        dutyId,
        fromMemberId,
        toMemberId,
        requestedAt,
        isApproved,
        respondedAt,
        message,
      );

  @override
  String toString() =>
      'DutySwapRequest(id: $id, dutyId: $dutyId, from: $fromMemberId, to: $toMemberId, approved: $isApproved)';
}

/// Tracks duty debts when someone does another's assigned duty
class DutyDebt {
  final String id;
  final String debtorId; // Who owes the duty
  final String creditorId; // Who did the work
  final DutyType dutyType;
  final DateTime date;
  final String originalDutyId; // Link to original assignment
  final bool isSettled;
  final DateTime? settledAt;
  final String? settledByDutyId; // When debtor does creditor's duty

  const DutyDebt({
    required this.id,
    required this.debtorId,
    required this.creditorId,
    required this.dutyType,
    required this.date,
    required this.originalDutyId,
    this.isSettled = false,
    this.settledAt,
    this.settledByDutyId,
  });

  DutyDebt copyWith({
    String? id,
    String? debtorId,
    String? creditorId,
    DutyType? dutyType,
    DateTime? date,
    String? originalDutyId,
    bool? isSettled,
    DateTime? settledAt,
    String? settledByDutyId,
  }) {
    return DutyDebt(
      id: id ?? this.id,
      debtorId: debtorId ?? this.debtorId,
      creditorId: creditorId ?? this.creditorId,
      dutyType: dutyType ?? this.dutyType,
      date: date ?? this.date,
      originalDutyId: originalDutyId ?? this.originalDutyId,
      isSettled: isSettled ?? this.isSettled,
      settledAt: settledAt ?? this.settledAt,
      settledByDutyId: settledByDutyId ?? this.settledByDutyId,
    );
  }

  factory DutyDebt.fromJson(Map<String, dynamic> json) {
    return DutyDebt(
      id: json['id'] as String? ?? '',
      debtorId: json['debtorId'] as String? ?? '',
      creditorId: json['creditorId'] as String? ?? '',
      dutyType: _dutyTypeFromJson(json['dutyType']),
      date: DateTime.parse(json['date'] as String),
      originalDutyId: json['originalDutyId'] as String? ?? '',
      isSettled: json['isSettled'] ?? false,
      settledAt: json['settledAt'] != null
          ? DateTime.parse(json['settledAt'] as String)
          : null,
      settledByDutyId: json['settledByDutyId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'debtorId': debtorId,
      'creditorId': creditorId,
      'dutyType': dutyType.name,
      'date': date.toIso8601String(),
      'originalDutyId': originalDutyId,
      'isSettled': isSettled,
      'settledAt': settledAt?.toIso8601String(),
      'settledByDutyId': settledByDutyId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DutyDebt &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          debtorId == other.debtorId &&
          creditorId == other.creditorId &&
          dutyType == other.dutyType &&
          date == other.date &&
          originalDutyId == other.originalDutyId &&
          isSettled == other.isSettled &&
          settledAt == other.settledAt &&
          settledByDutyId == other.settledByDutyId;

  @override
  int get hashCode => Object.hash(
        id,
        debtorId,
        creditorId,
        dutyType,
        date,
        originalDutyId,
        isSettled,
        settledAt,
        settledByDutyId,
      );

  @override
  String toString() =>
      'DutyDebt(id: $id, debtor: $debtorId, creditor: $creditorId, type: $dutyType, settled: $isSettled)';
}

// Helper functions for enum parsing
DutyType _dutyTypeFromJson(dynamic value) {
  if (value == null) return DutyType.roomCleaning;
  try {
    return DutyType.values.byName(value as String);
  } catch (_) {
    return DutyType.roomCleaning;
  }
}

DutyStatus _dutyStatusFromJson(dynamic value) {
  if (value == null) return DutyStatus.pending;
  try {
    return DutyStatus.values.byName(value as String);
  } catch (_) {
    return DutyStatus.pending;
  }
}

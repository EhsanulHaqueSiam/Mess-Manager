import 'package:isar_plus/isar_plus.dart';
import '../../models/member.dart';

part 'pending_approval_collection.g.dart';

/// Approval status enum
enum ApprovalStatus { pending, approved, rejected }

/// Isar collection for Pending Approval requests
@collection
class PendingApprovalCollection {
  /// Auto-incrementing ID - Isar assigns this automatically
  late int id;

  @Index(unique: true)
  late String approvalId;

  late String name;
  late String email;
  String? phone;
  String? inviteCode;

  late DateTime requestedAt;

  /// Role stored as int (enum index)
  late int requestedRoleIndex;

  String? notes;

  /// Status stored as int (enum index)
  late int statusIndex;

  DateTime? reviewedAt;
  String? reviewedBy;
  String? rejectionReason;

  // ─────────────────────────────────────────────────────────────────────────
  // Model Converters
  // ─────────────────────────────────────────────────────────────────────────

  /// Convert to PendingApproval model
  PendingApproval toModel() {
    return PendingApproval(
      id: approvalId,
      name: name,
      email: email,
      phone: phone,
      inviteCode: inviteCode,
      requestedAt: requestedAt,
      requestedRole: MemberRole.values[requestedRoleIndex],
      notes: notes,
      status: ApprovalStatus.values[statusIndex],
      reviewedAt: reviewedAt,
      reviewedBy: reviewedBy,
      rejectionReason: rejectionReason,
    );
  }

  /// Create from PendingApproval model
  static PendingApprovalCollection fromModel(PendingApproval approval) {
    return PendingApprovalCollection()
      ..approvalId = approval.id
      ..name = approval.name
      ..email = approval.email
      ..phone = approval.phone
      ..inviteCode = approval.inviteCode
      ..requestedAt = approval.requestedAt
      ..requestedRoleIndex = approval.requestedRole.index
      ..notes = approval.notes
      ..statusIndex = approval.status.index
      ..reviewedAt = approval.reviewedAt
      ..reviewedBy = approval.reviewedBy
      ..rejectionReason = approval.rejectionReason;
  }
}

/// Pending member approval request model
class PendingApproval {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? inviteCode;
  final DateTime requestedAt;
  final MemberRole requestedRole;
  final String? notes;
  final ApprovalStatus status;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final String? rejectionReason;

  const PendingApproval({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.inviteCode,
    required this.requestedAt,
    this.requestedRole = MemberRole.member,
    this.notes,
    this.status = ApprovalStatus.pending,
    this.reviewedAt,
    this.reviewedBy,
    this.rejectionReason,
  });

  PendingApproval copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? inviteCode,
    DateTime? requestedAt,
    MemberRole? requestedRole,
    String? notes,
    ApprovalStatus? status,
    DateTime? reviewedAt,
    String? reviewedBy,
    String? rejectionReason,
  }) {
    return PendingApproval(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      inviteCode: inviteCode ?? this.inviteCode,
      requestedAt: requestedAt ?? this.requestedAt,
      requestedRole: requestedRole ?? this.requestedRole,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'inviteCode': inviteCode,
    'requestedAt': requestedAt.toIso8601String(),
    'requestedRole': requestedRole.name,
    'notes': notes,
    'status': status.name,
    'reviewedAt': reviewedAt?.toIso8601String(),
    'reviewedBy': reviewedBy,
    'rejectionReason': rejectionReason,
  };

  factory PendingApproval.fromJson(Map<String, dynamic> json) =>
      PendingApproval(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        inviteCode: json['inviteCode'],
        requestedAt: DateTime.parse(json['requestedAt']),
        requestedRole: MemberRole.values.firstWhere(
          (r) => r.name == json['requestedRole'],
          orElse: () => MemberRole.member,
        ),
        notes: json['notes'],
        status: ApprovalStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => ApprovalStatus.pending,
        ),
        reviewedAt: json['reviewedAt'] != null
            ? DateTime.parse(json['reviewedAt'])
            : null,
        reviewedBy: json['reviewedBy'],
        rejectionReason: json['rejectionReason'],
      );
}

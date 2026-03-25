import 'member.dart';

/// Approval status enum
enum ApprovalStatus { pending, approved, rejected }

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

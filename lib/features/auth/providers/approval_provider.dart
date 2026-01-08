import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/core/database/collections/pending_approval_collection.dart';

// Re-export for convenience
export 'package:mess_manager/core/database/collections/pending_approval_collection.dart'
    show PendingApproval, ApprovalStatus;

/// Approval state
class ApprovalState {
  final List<PendingApproval> pending;
  final bool isLoading;
  final String? error;

  const ApprovalState({
    this.pending = const [],
    this.isLoading = false,
    this.error,
  });

  ApprovalState copyWith({
    List<PendingApproval>? pending,
    bool? isLoading,
    String? error,
  }) {
    return ApprovalState(
      pending: pending ?? this.pending,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Approval provider
final approvalProvider = NotifierProvider<ApprovalNotifier, ApprovalState>(
  ApprovalNotifier.new,
);

class ApprovalNotifier extends Notifier<ApprovalState> {
  @override
  ApprovalState build() {
    // Load pending approvals from Isar
    _loadPendingApprovals();
    return const ApprovalState();
  }

  void _loadPendingApprovals() {
    try {
      final pending = IsarService.getPendingApprovalsByStatus(
        ApprovalStatus.pending,
      );
      state = state.copyWith(pending: pending, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// Create a new approval request (called during signup)
  Future<void> createRequest({
    required String email,
    required String name,
    String? phone,
    String? inviteCode,
    MemberRole requestedRole = MemberRole.member,
    String? notes,
  }) async {
    final approval = PendingApproval(
      id: 'approval_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      phone: phone,
      inviteCode: inviteCode,
      requestedAt: DateTime.now(),
      requestedRole: requestedRole,
      notes: notes,
      status: ApprovalStatus.pending,
    );

    IsarService.savePendingApproval(approval);
    _loadPendingApprovals();
  }

  /// Approve a pending request
  Future<void> approve(String id, {MemberRole? role}) async {
    state = state.copyWith(isLoading: true);

    try {
      final request = state.pending.firstWhere((p) => p.id == id);

      // Update approval status
      final updatedApproval = request.copyWith(
        status: ApprovalStatus.approved,
        reviewedAt: DateTime.now(),
      );
      IsarService.savePendingApproval(updatedApproval);

      // Create new member with email for auth linking
      final newMember = Member(
        id: 'member_${DateTime.now().millisecondsSinceEpoch}',
        name: request.name,
        phone: request.phone,
        email: request.email, // Link to auth user
        role: role ?? request.requestedRole,
        isActive: true,
        joinedAt: DateTime.now(),
        preferences: [],
      );

      // Add to members
      ref.read(membersProvider.notifier).addMember(newMember);

      // Reload pending list
      _loadPendingApprovals();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Reject a pending request
  Future<void> reject(String id, {String? reason}) async {
    state = state.copyWith(isLoading: true);

    try {
      final request = state.pending.firstWhere((p) => p.id == id);

      // Update approval status
      final updatedApproval = request.copyWith(
        status: ApprovalStatus.rejected,
        reviewedAt: DateTime.now(),
        rejectionReason: reason,
      );
      IsarService.savePendingApproval(updatedApproval);

      // Reload pending list
      _loadPendingApprovals();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Refresh pending approvals
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    _loadPendingApprovals();
  }

  /// Delete an approval record entirely
  void deleteApproval(String id) {
    IsarService.deletePendingApproval(id);
    _loadPendingApprovals();
  }
}

/// Count of pending approvals (for badge)
final pendingApprovalCountProvider = Provider<int>((ref) {
  return ref.watch(approvalProvider).pending.length;
});

/// Check if a specific email has a pending approval
final hasPendingApprovalProvider = Provider.family<PendingApproval?, String>((
  ref,
  email,
) {
  return IsarService.getPendingApprovalByEmail(email);
});

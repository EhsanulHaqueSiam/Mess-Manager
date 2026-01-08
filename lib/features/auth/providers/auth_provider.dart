import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/auth_user.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/core/services/firestore_service.dart';
import 'package:mess_manager/features/auth/providers/approval_provider.dart';
import 'package:mess_manager/core/providers/members_provider.dart';

/// Auth state
enum AuthStatus { initial, authenticated, unauthenticated, pendingApproval }

/// Auth state class
class AuthState {
  final AuthStatus status;
  final AuthUser? user;
  final Mess? currentMess;
  final List<Mess> availableMesses;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.currentMess,
    this.availableMesses = const [],
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    Mess? currentMess,
    List<Mess>? availableMesses,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      currentMess: currentMess ?? this.currentMess,
      availableMesses: availableMesses ?? this.availableMesses,
      error: error,
    );
  }
}

/// Auth provider
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Defer auth check to next frame to avoid accessing state before initialization
    Future.microtask(() => _checkAuth());
    return const AuthState();
  }

  void _checkAuth() {
    try {
      final userData = IsarService.getSetting<Map<String, dynamic>>(
        'current_user',
      );
      if (userData != null) {
        try {
          final user = AuthUser.fromJson(userData);
          final messes = _loadMesses();
          final currentMess = messes.firstWhere(
            (m) => m.id == user.currentMessId,
            orElse: () =>
                messes.isNotEmpty ? messes.first : _createDefaultMess(),
          );

          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            currentMess: currentMess,
            availableMesses: messes,
          );
        } catch (_) {
          state = state.copyWith(status: AuthStatus.unauthenticated);
        }
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      // On web or any error, default to unauthenticated
      debugPrint('AuthProvider._checkAuth error: $e');
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  List<Mess> _loadMesses() {
    final messesJson = IsarService.getSetting<List<dynamic>>('messes');
    if (messesJson == null) return [];
    return messesJson
        .map((m) => Mess.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }

  void _saveMesses(List<Mess> messes) {
    IsarService.saveSetting('messes', messes.map((m) => m.toJson()).toList());
  }

  Mess _createDefaultMess() {
    return Mess(
      id: 'default',
      name: 'Area51',
      address: 'Dhaka, Bangladesh',
      createdById: 'system',
      createdAt: DateTime.now(),
    );
  }

  /// Sign up with email and password
  /// Creates a pending approval request instead of direct authentication
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? inviteCode,
  }) async {
    try {
      // Create user record (but mark as pending)
      final user = AuthUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        phone: phone,
        createdAt: DateTime.now(),
      );

      // Save user data for later (when approved)
      IsarService.saveSetting('current_user', user.toJson());

      // Create pending approval request
      ref
          .read(approvalProvider.notifier)
          .createRequest(
            email: email,
            name: name,
            phone: phone,
            inviteCode: inviteCode,
          );

      // Set state to pending approval (not fully authenticated)
      state = state.copyWith(
        status: AuthStatus.pendingApproval,
        user: user,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Sign in with email and password
  Future<bool> signIn({required String email, required String password}) async {
    try {
      // For local auth, just load user by email (simulate login)
      final userData = IsarService.getSetting<Map<String, dynamic>>(
        'current_user',
      );
      if (userData != null) {
        final user = AuthUser.fromJson(userData);
        if (user.email == email) {
          final messes = _loadMesses();
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            availableMesses: messes,
            currentMess: messes.isNotEmpty
                ? messes.first
                : _createDefaultMess(),
            error: null,
          );
          return true;
        }
      }

      // Demo: Auto-login with any credentials
      final user = AuthUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: email.split('@').first,
        createdAt: DateTime.now(),
      );
      IsarService.saveSetting('current_user', user.toJson());

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        currentMess: _createDefaultMess(),
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    IsarService.removeSetting('current_user');
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? avatarUrl,
  }) async {
    if (state.user == null) return;

    final updatedUser = AuthUser(
      id: state.user!.id,
      email: state.user!.email,
      name: name ?? state.user!.name,
      phone: phone ?? state.user!.phone,
      avatarUrl: avatarUrl ?? state.user!.avatarUrl,
      createdAt: state.user!.createdAt,
      currentMessId: state.user!.currentMessId,
    );

    IsarService.saveSetting('current_user', updatedUser.toJson());
    state = state.copyWith(user: updatedUser);
  }

  /// Create a new mess
  Future<Mess> createMess({
    required String name,
    required String address,
  }) async {
    final mess = Mess(
      id: 'mess_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      address: address,
      createdById: state.user!.id,
      createdAt: DateTime.now(),
      memberIds: [state.user!.id],
      inviteCode: _generateInviteCode(),
    );

    final messes = [...state.availableMesses, mess];
    _saveMesses(messes);

    // Update user's current mess
    final updatedUser = AuthUser(
      id: state.user!.id,
      email: state.user!.email,
      name: state.user!.name,
      phone: state.user!.phone,
      avatarUrl: state.user!.avatarUrl,
      createdAt: state.user!.createdAt,
      currentMessId: mess.id,
    );
    IsarService.saveSetting('current_user', updatedUser.toJson());

    state = state.copyWith(
      user: updatedUser,
      currentMess: mess,
      availableMesses: messes,
    );

    return mess;
  }

  /// Update current mess settings
  Future<void> updateMess({required String name, String? address}) async {
    if (state.currentMess == null) return;

    final updatedMess = Mess(
      id: state.currentMess!.id,
      name: name,
      address: address ?? state.currentMess!.address,
      createdById: state.currentMess!.createdById,
      createdAt: state.currentMess!.createdAt,
      memberIds: state.currentMess!.memberIds,
      inviteCode: state.currentMess!.inviteCode,
    );

    // Update in the available messes list
    final messes = state.availableMesses
        .map((m) => m.id == updatedMess.id ? updatedMess : m)
        .toList();
    _saveMesses(messes);

    state = state.copyWith(currentMess: updatedMess, availableMesses: messes);
  }

  /// Select a mess
  Future<void> selectMess(String messId) async {
    final mess = state.availableMesses.firstWhere((m) => m.id == messId);
    final updatedUser = AuthUser(
      id: state.user!.id,
      email: state.user!.email,
      name: state.user!.name,
      phone: state.user!.phone,
      avatarUrl: state.user!.avatarUrl,
      createdAt: state.user!.createdAt,
      currentMessId: messId,
    );
    IsarService.saveSetting('current_user', updatedUser.toJson());

    state = state.copyWith(user: updatedUser, currentMess: mess);
  }

  /// Join mess by invite code
  /// Tries local lookup first, then falls back to Firestore for remote messes
  Future<bool> joinMess(String inviteCode) async {
    final normalizedCode = inviteCode.toUpperCase().trim();

    // 1. Try local lookup first
    final localMess = state.availableMesses
        .where((m) => m.inviteCode?.toUpperCase() == normalizedCode)
        .firstOrNull;

    if (localMess != null) {
      // Local mess found - add user to members
      final updatedMess = Mess(
        id: localMess.id,
        name: localMess.name,
        address: localMess.address,
        createdById: localMess.createdById,
        createdAt: localMess.createdAt,
        memberIds: [...localMess.memberIds, state.user!.id],
        inviteCode: localMess.inviteCode,
      );

      final messes = state.availableMesses.map((m) {
        return m.id == localMess.id ? updatedMess : m;
      }).toList();

      _saveMesses(messes);
      await selectMess(localMess.id);
      _createMemberProfile();
      return true;
    }

    // 2. Fallback to Firestore for remote mess lookup
    try {
      final messId = await FirestoreService.joinMess(normalizedCode);
      if (messId == null) {
        throw Exception('Invalid invite code');
      }

      // Fetch the mess data from Firestore
      final messData = await FirestoreService.getMess(messId);
      if (messData == null) {
        throw Exception('Could not load mess data');
      }

      // Convert Firestore data to Mess model
      final remoteMess = Mess(
        id: messId,
        name: messData['name'] as String? ?? 'Unnamed Mess',
        address: messData['address'] as String? ?? '',
        createdById: messData['ownerId'] as String? ?? '',
        createdAt:
            (messData['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
        memberIds: List<String>.from(messData['members'] ?? []),
        inviteCode: messData['inviteCode'] as String?,
      );

      // Add to local messes
      final messes = [...state.availableMesses, remoteMess];
      _saveMesses(messes);

      // Select the new mess
      state = state.copyWith(availableMesses: messes);
      await selectMess(messId);

      // Create Member profile for the user in the new mess
      _createMemberProfile();

      debugPrint('Joined remote mess via Firestore: ${remoteMess.name}');
      return true;
    } catch (e) {
      debugPrint('Firestore joinMess failed: $e');
      throw Exception('Invalid invite code');
    }
  }

  /// Create a Member profile for the current user in the current mess
  void _createMemberProfile() {
    if (state.user == null || state.currentMess == null) return;

    // Check if member already exists
    final members = ref.read(membersProvider);
    final exists = members.any((m) => m.id == state.user!.id);
    if (exists) return;

    // Create new member profile
    final member = Member(
      id: state.user!.id,
      name: state.user!.name,
      phone: state.user!.phone ?? '',
      email: state.user!.email,
      joinedAt: DateTime.now(),
      isActive: true,
    );

    ref.read(membersProvider.notifier).addMember(member);
    debugPrint('Created Member profile: ${member.name}');
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      6,
      (i) => chars[(DateTime.now().millisecond + i) % chars.length],
    ).join();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

/// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).status == AuthStatus.authenticated;
});

/// Current user
final currentUserProvider = Provider<AuthUser?>((ref) {
  return ref.watch(authProvider).user;
});

/// Current mess
final currentMessProvider = Provider<Mess?>((ref) {
  return ref.watch(authProvider).currentMess;
});

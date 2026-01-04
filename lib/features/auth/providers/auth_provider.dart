import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/auth_user.dart';
import 'package:mess_manager/core/database/isar_service.dart';

/// Auth state
enum AuthStatus { initial, authenticated, unauthenticated }

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
    // Check if user is already logged in
    _checkAuth();
    return const AuthState();
  }

  void _checkAuth() {
    final userData = IsarService.getSetting<Map<String, dynamic>>(
      'current_user',
    );
    if (userData != null) {
      try {
        final user = AuthUser.fromJson(userData);
        final messes = _loadMesses();
        final currentMess = messes.firstWhere(
          (m) => m.id == user.currentMessId,
          orElse: () => messes.isNotEmpty ? messes.first : _createDefaultMess(),
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
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      // For local auth, just create user
      final user = AuthUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        phone: phone,
        createdAt: DateTime.now(),
      );

      IsarService.saveSetting('current_user', user.toJson());

      state = state.copyWith(
        status: AuthStatus.authenticated,
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
  Future<bool> joinMess(String inviteCode) async {
    final mess = state.availableMesses.firstWhere(
      (m) => m.inviteCode == inviteCode,
      orElse: () => throw Exception('Invalid invite code'),
    );

    final updatedMess = Mess(
      id: mess.id,
      name: mess.name,
      address: mess.address,
      createdById: mess.createdById,
      createdAt: mess.createdAt,
      memberIds: [...mess.memberIds, state.user!.id],
      inviteCode: mess.inviteCode,
    );

    final messes = state.availableMesses.map((m) {
      return m.id == mess.id ? updatedMess : m;
    }).toList();

    _saveMesses(messes);

    await selectMess(mess.id);
    return true;
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

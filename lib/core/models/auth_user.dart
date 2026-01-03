import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// User model for authentication
@freezed
sealed class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String email,
    required String name,
    String? phone,
    String? avatarUrl,
    required DateTime createdAt,
    String? currentMessId,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}

/// Mess model for mess selection
@freezed
sealed class Mess with _$Mess {
  const factory Mess({
    required String id,
    required String name,
    required String address,
    required String createdById,
    required DateTime createdAt,
    @Default([]) List<String> memberIds,
    String? inviteCode,
  }) = _Mess;

  factory Mess.fromJson(Map<String, dynamic> json) => _$MessFromJson(json);
}

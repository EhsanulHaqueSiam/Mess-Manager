import 'package:flutter/foundation.dart';
import '../database/isar_service.dart';

/// Storage service for persisting app data using Isar
/// This is a compatibility layer that wraps IsarService
///
/// NOTE: Most usage should migrate directly to IsarService.
/// This wrapper is kept temporarily for backward compatibility.
class StorageService {
  /// Initialize Isar (replaces Hive initialization)
  static Future<void> init() async {
    await IsarService.init();
    debugPrint('StorageService (Isar) initialized');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // GENERIC JSON STORAGE (Settings-based)
  // ─────────────────────────────────────────────────────────────────────────

  /// Save a single JSON object
  static void saveJson(String key, Map<String, dynamic> data) {
    IsarService.saveSetting(key, data);
  }

  /// Load a single JSON object
  static Map<String, dynamic>? loadJson(String key) {
    return IsarService.getSetting<Map<String, dynamic>>(key);
  }

  /// Delete a single JSON object
  static void deleteJson(String key) {
    IsarService.removeSetting(key);
  }

  /// Save a list of items as JSON
  static void saveList<T>({
    required String boxName,
    required List<T> items,
    required Map<String, dynamic> Function(T) toJson,
  }) {
    final jsonList = items.map(toJson).toList();
    IsarService.saveSetting('list_$boxName', jsonList);
  }

  /// Load a list of items from JSON
  static List<T> loadList<T>({
    required String boxName,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    final jsonList = IsarService.getSetting<List<dynamic>>('list_$boxName');
    if (jsonList == null) return [];

    return jsonList.map((e) => fromJson(Map<String, dynamic>.from(e))).toList();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SETTINGS (Key-Value Store)
  // ─────────────────────────────────────────────────────────────────────────

  static void saveSetting(String key, dynamic value) {
    IsarService.saveSetting(key, value);
  }

  static T? getSetting<T>(String key, {T? defaultValue}) {
    return IsarService.getSetting<T>(key, defaultValue: defaultValue);
  }

  static void removeSetting(String key) {
    IsarService.removeSetting(key);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // THEME
  // ─────────────────────────────────────────────────────────────────────────

  static void saveThemeMode(bool isDark) {
    IsarService.saveSetting('theme_mode', isDark);
  }

  static bool loadThemeMode() {
    return IsarService.getSetting<bool>('theme_mode', defaultValue: false) ??
        false;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CURRENT MEMBER
  // ─────────────────────────────────────────────────────────────────────────

  static void saveCurrentMemberId(String id) {
    IsarService.saveSetting('current_member_id', id);
  }

  static String? loadCurrentMemberId() {
    return IsarService.getSetting<String>('current_member_id');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CLEAR ALL
  // ─────────────────────────────────────────────────────────────────────────

  static void clearAll() {
    IsarService.clearAll();
  }
}

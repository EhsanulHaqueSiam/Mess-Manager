import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../models/member.dart';
import '../models/meal.dart';
import '../models/bazar_entry.dart';
import '../models/money_transaction.dart';
import '../models/duty.dart';
import '../models/unified_entry.dart';
import '../models/settlement.dart';
import '../models/ramadan.dart';
import '../models/app_notification.dart';
import '../models/pending_approval.dart';

/// SQLite-backed Database Service (drop-in replacement for Isar)
/// Uses an in-memory cache for synchronous reads, with fire-and-forget writes to SQLite.
/// Note: Disabled on web (uses Firebase/in-memory instead)
class IsarService {
  static Database? _db;
  static bool _isWebPlatform = false;

  // ─── In-memory cache ──────────────────────────────────────────────────────
  // _cache['members']['member-id-123'] = { ...member json... }
  static final Map<String, Map<String, Map<String, dynamic>>> _cache = {};
  static final Map<String, Map<String, dynamic>> _settingsCache = {};

  // ─── Notification change stream ───────────────────────────────────────────
  static final StreamController<List<AppNotification>>
      _notificationsController =
      StreamController<List<AppNotification>>.broadcast();

  /// Stream of notifications (replacement for Isar's reactive watch)
  static Stream<List<AppNotification>> watchNotifications() {
    return _notificationsController.stream;
  }

  /// Fire the current notifications into the stream
  static void _emitNotifications() {
    if (!isAvailable) return;
    final list = _cache['notifications']!
        .values
        .map((json) =>
            AppNotification.fromJson(Map<String, dynamic>.from(json)))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    _notificationsController.add(list);
  }

  // ─── Table names ──────────────────────────────────────────────────────────
  static const _tables = [
    'members',
    'meals',
    'bazar_entries',
    'transactions',
    'duty_assignments',
    'duty_schedules',
    'duty_debts',
    'unified_entries',
    'settlements',
    'ramadan_seasons',
    'ramadan_meals',
    'ramadan_bazars',
    'notifications',
    'pending_approvals',
  ];

  /// Check if database is available (not on web)
  static bool get isAvailable => !_isWebPlatform && _db != null;

  /// Initialize the database
  static Future<void> init() async {
    if (kIsWeb) {
      _isWebPlatform = true;
      debugPrint(
        'IsarService: Skipped on web platform (using in-memory/Firebase)',
      );
      return;
    }

    if (_db != null) return;

    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'mess_manager.db');

    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        for (final table in _tables) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $table (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              entity_id TEXT UNIQUE,
              data TEXT NOT NULL
            )
          ''');
        }
        await db.execute('''
          CREATE TABLE IF NOT EXISTS settings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            key TEXT UNIQUE,
            value_json TEXT,
            value_type TEXT NOT NULL
          )
        ''');
      },
    );

    // Load all data into memory cache
    for (final table in _tables) {
      _cache[table] = {};
      final rows = await _db!.query(table);
      for (final row in rows) {
        _cache[table]![row['entity_id'] as String] =
            jsonDecode(row['data'] as String) as Map<String, dynamic>;
      }
    }

    // Load settings
    _settingsCache.clear();
    final settingsRows = await _db!.query('settings');
    for (final row in settingsRows) {
      _settingsCache[row['key'] as String] = {
        'value_json': row['value_json'],
        'value_type': row['value_type'],
      };
    }

    debugPrint('IsarService initialized at ${dir.path}');
  }

  /// Close the database
  static void close() {
    _db?.close();
    _db = null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERNAL HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  static void _put(String table, String entityId, Map<String, dynamic> json) {
    _cache[table]![entityId] = json;
    _db?.insert(
      table,
      {'entity_id': entityId, 'data': jsonEncode(json)},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static void _remove(String table, String entityId) {
    _cache[table]!.remove(entityId);
    _db?.delete(table, where: 'entity_id = ?', whereArgs: [entityId]);
  }

  static List<T> _getAll<T>(
    String table,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (!isAvailable) return [];
    return _cache[table]!
        .values
        .map((json) => fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  static T? _getById<T>(
    String table,
    String entityId,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (!isAvailable) return null;
    final json = _cache[table]?[entityId];
    if (json == null) return null;
    return fromJson(Map<String, dynamic>.from(json));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SETTINGS (Key-Value Store)
  // ═══════════════════════════════════════════════════════════════════════════

  static void saveSetting<T>(String key, T value) {
    if (!isAvailable) return;

    final String valueJson;
    final String valueType;

    if (value is String) {
      valueJson = value;
      valueType = 'string';
    } else if (value is int) {
      valueJson = value.toString();
      valueType = 'int';
    } else if (value is double) {
      valueJson = value.toString();
      valueType = 'double';
    } else if (value is bool) {
      valueJson = value.toString();
      valueType = 'bool';
    } else {
      valueJson = jsonEncode(value);
      valueType = 'json';
    }

    _settingsCache[key] = {
      'value_json': valueJson,
      'value_type': valueType,
    };
    _db?.insert(
      'settings',
      {'key': key, 'value_json': valueJson, 'value_type': valueType},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static T? getSetting<T>(String key, {T? defaultValue}) {
    if (!isAvailable) return defaultValue;

    final setting = _settingsCache[key];
    if (setting == null || setting['value_json'] == null) {
      return defaultValue;
    }

    final valueJson = setting['value_json'] as String;
    final valueType = setting['value_type'] as String;

    try {
      switch (valueType) {
        case 'string':
          return valueJson as T;
        case 'int':
          return int.parse(valueJson) as T;
        case 'double':
          return double.parse(valueJson) as T;
        case 'bool':
          return (valueJson == 'true') as T;
        case 'json':
          return jsonDecode(valueJson) as T;
        default:
          return defaultValue;
      }
    } catch (e) {
      debugPrint('Error parsing setting $key: $e');
      return defaultValue;
    }
  }

  static void removeSetting(String key) {
    if (!isAvailable) return;
    _settingsCache.remove(key);
    _db?.delete('settings', where: 'key = ?', whereArgs: [key]);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MEMBERS
  // ═══════════════════════════════════════════════════════════════════════════

  static List<Member> getAllMembers() {
    return _getAll('members', Member.fromJson);
  }

  static Member? getMemberById(String memberId) {
    return _getById('members', memberId, Member.fromJson);
  }

  static void saveMember(Member member) {
    if (!isAvailable) return;
    _put('members', member.id, member.toJson());
  }

  static void saveMembers(List<Member> members) {
    for (final member in members) {
      saveMember(member);
    }
  }

  static void deleteMember(String memberId) {
    if (!isAvailable) return;
    _remove('members', memberId);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MEALS
  // ═══════════════════════════════════════════════════════════════════════════

  static List<Meal> getAllMeals() {
    return _getAll('meals', Meal.fromJson);
  }

  static List<Meal> getMealsByDate(DateTime date) {
    if (!isAvailable) return [];
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return _cache['meals']!.values.map((json) {
      return Meal.fromJson(Map<String, dynamic>.from(json));
    }).where((meal) {
      return !meal.date.isBefore(startOfDay) && meal.date.isBefore(endOfDay);
    }).toList();
  }

  static List<Meal> getMealsByMember(String memberId) {
    if (!isAvailable) return [];
    return _cache['meals']!.values.map((json) {
      return Meal.fromJson(Map<String, dynamic>.from(json));
    }).where((meal) => meal.memberId == memberId).toList();
  }

  static void saveMeal(Meal meal) {
    if (!isAvailable) return;
    _put('meals', meal.id, meal.toJson());
  }

  static void saveMeals(List<Meal> meals) {
    for (final meal in meals) {
      saveMeal(meal);
    }
  }

  static void deleteMeal(String mealId) {
    if (!isAvailable) return;
    _remove('meals', mealId);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BAZAR ENTRIES
  // ═══════════════════════════════════════════════════════════════════════════

  static List<BazarEntry> getAllBazarEntries() {
    return _getAll('bazar_entries', BazarEntry.fromJson);
  }

  static void saveBazarEntry(BazarEntry entry) {
    if (!isAvailable) return;
    _put('bazar_entries', entry.id, entry.toJson());
  }

  static void saveBazarEntries(List<BazarEntry> entries) {
    for (final entry in entries) {
      saveBazarEntry(entry);
    }
  }

  static void deleteBazarEntry(String entryId) {
    if (!isAvailable) return;
    _remove('bazar_entries', entryId);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TRANSACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  static List<MoneyTransaction> getAllTransactions() {
    return _getAll('transactions', MoneyTransaction.fromJson);
  }

  static void saveTransaction(MoneyTransaction transaction) {
    if (!isAvailable) return;
    _put('transactions', transaction.id, transaction.toJson());
  }

  static void saveTransactions(List<MoneyTransaction> transactions) {
    for (final t in transactions) {
      saveTransaction(t);
    }
  }

  static void deleteTransaction(String transactionId) {
    if (!isAvailable) return;
    _remove('transactions', transactionId);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DUTY SCHEDULES
  // ═══════════════════════════════════════════════════════════════════════════

  static List<DutySchedule> getAllDutySchedules() {
    return _getAll('duty_schedules', DutySchedule.fromJson);
  }

  static void saveDutySchedule(DutySchedule schedule) {
    if (!isAvailable) return;
    _put('duty_schedules', schedule.id, schedule.toJson());
  }

  static void saveDutySchedules(List<DutySchedule> schedules) {
    for (final s in schedules) {
      saveDutySchedule(s);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DUTY ASSIGNMENTS
  // ═══════════════════════════════════════════════════════════════════════════

  static List<DutyAssignment> getAllDutyAssignments() {
    return _getAll('duty_assignments', DutyAssignment.fromJson);
  }

  static void saveDutyAssignment(DutyAssignment assignment) {
    if (!isAvailable) return;
    _put('duty_assignments', assignment.id, assignment.toJson());
  }

  static void saveDutyAssignments(List<DutyAssignment> assignments) {
    for (final a in assignments) {
      saveDutyAssignment(a);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DUTY DEBTS
  // ═══════════════════════════════════════════════════════════════════════════

  static List<DutyDebt> getAllDutyDebts() {
    return _getAll('duty_debts', DutyDebt.fromJson);
  }

  static void saveDutyDebt(DutyDebt debt) {
    if (!isAvailable) return;
    _put('duty_debts', debt.id, debt.toJson());
  }

  static void saveDutyDebts(List<DutyDebt> debts) {
    for (final d in debts) {
      saveDutyDebt(d);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UNIFIED ENTRIES
  // ═══════════════════════════════════════════════════════════════════════════

  static List<UnifiedEntry> getAllUnifiedEntries() {
    return _getAll('unified_entries', UnifiedEntry.fromJson);
  }

  static void saveUnifiedEntry(UnifiedEntry entry) {
    if (!isAvailable) return;
    _put('unified_entries', entry.id, entry.toJson());
  }

  static void saveUnifiedEntries(List<UnifiedEntry> entries) {
    for (final e in entries) {
      saveUnifiedEntry(e);
    }
  }

  static void deleteUnifiedEntry(String entryId) {
    if (!isAvailable) return;
    _remove('unified_entries', entryId);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SETTLEMENTS
  // ═══════════════════════════════════════════════════════════════════════════

  static List<Settlement> getAllSettlements() {
    return _getAll('settlements', Settlement.fromJson);
  }

  static void saveSettlement(Settlement settlement) {
    if (!isAvailable) return;
    _put('settlements', settlement.id, settlement.toJson());
  }

  static void saveSettlements(List<Settlement> settlements) {
    for (final s in settlements) {
      saveSettlement(s);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RAMADAN SEASONS
  // ═══════════════════════════════════════════════════════════════════════════

  static List<RamadanSeason> getAllRamadanSeasons() {
    return _getAll('ramadan_seasons', RamadanSeason.fromJson);
  }

  static void saveRamadanSeason(RamadanSeason season) {
    if (!isAvailable) return;
    _put('ramadan_seasons', season.id, season.toJson());
  }

  static void saveRamadanSeasons(List<RamadanSeason> seasons) {
    for (final s in seasons) {
      saveRamadanSeason(s);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RAMADAN MEALS
  // ═══════════════════════════════════════════════════════════════════════════

  static List<RamadanMeal> getAllRamadanMeals() {
    return _getAll('ramadan_meals', RamadanMeal.fromJson);
  }

  static void saveRamadanMeal(RamadanMeal meal) {
    if (!isAvailable) return;
    _put('ramadan_meals', meal.id, meal.toJson());
  }

  static void saveRamadanMeals(List<RamadanMeal> meals) {
    for (final m in meals) {
      saveRamadanMeal(m);
    }
  }

  static void deleteRamadanMeal(String mealId) {
    if (!isAvailable) return;
    _remove('ramadan_meals', mealId);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RAMADAN BAZAR
  // ═══════════════════════════════════════════════════════════════════════════

  static List<RamadanBazar> getAllRamadanBazar() {
    return _getAll('ramadan_bazars', RamadanBazar.fromJson);
  }

  static void saveRamadanBazar(RamadanBazar bazar) {
    if (!isAvailable) return;
    _put('ramadan_bazars', bazar.id, bazar.toJson());
  }

  static void saveRamadanBazars(List<RamadanBazar> bazars) {
    for (final b in bazars) {
      saveRamadanBazar(b);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RAMADAN PAYMENTS (stored as JSON in settings)
  // ═══════════════════════════════════════════════════════════════════════════

  static List<RamadanPayment> getAllRamadanPayments() {
    if (!isAvailable) return [];
    final json = getSetting<List<dynamic>>(
      'ramadan_payments',
      defaultValue: [],
    );
    if (json == null || json.isEmpty) return [];
    return json
        .map((e) => RamadanPayment.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static void saveRamadanPayments(List<RamadanPayment> payments) {
    if (!isAvailable) return;
    final json = payments.map((p) => p.toJson()).toList();
    saveSetting('ramadan_payments', json);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NOTIFICATIONS (Collection Pattern)
  // ═══════════════════════════════════════════════════════════════════════════

  static List<AppNotification> getAllNotifications() {
    if (!isAvailable) return [];
    return _cache['notifications']!
        .values
        .map((json) =>
            AppNotification.fromJson(Map<String, dynamic>.from(json)))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  static void saveNotification(AppNotification notification) {
    if (!isAvailable) return;
    _put('notifications', notification.id, notification.toJson());
    _emitNotifications();
  }

  static void saveNotifications(List<AppNotification> notifications) {
    if (!isAvailable) return;
    if (notifications.isEmpty) return;
    for (final n in notifications) {
      _put('notifications', n.id, n.toJson());
    }
    _emitNotifications();
  }

  static void deleteNotification(String id) {
    if (!isAvailable) return;
    _remove('notifications', id);
    _emitNotifications();
  }

  static void markAllNotificationsAsRead() {
    if (!isAvailable) return;
    bool changed = false;
    for (final entry in _cache['notifications']!.entries.toList()) {
      final json = entry.value;
      if (json['isRead'] != true) {
        json['isRead'] = true;
        _put('notifications', entry.key, json);
        changed = true;
      }
    }
    if (changed) _emitNotifications();
  }

  static void clearNotifications() {
    if (!isAvailable) return;
    _cache['notifications']!.clear();
    _db?.delete('notifications');
    _emitNotifications();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PENDING APPROVALS
  // ═══════════════════════════════════════════════════════════════════════════

  static List<PendingApproval> getAllPendingApprovals() {
    if (!isAvailable) return [];
    return _cache['pending_approvals']!
        .values
        .map((json) =>
            PendingApproval.fromJson(Map<String, dynamic>.from(json)))
        .toList()
      ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));
  }

  static List<PendingApproval> getPendingApprovalsByStatus(
    ApprovalStatus status,
  ) {
    if (!isAvailable) return [];
    return _cache['pending_approvals']!
        .values
        .map((json) =>
            PendingApproval.fromJson(Map<String, dynamic>.from(json)))
        .where((a) => a.status == status)
        .toList()
      ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));
  }

  static PendingApproval? getPendingApprovalByEmail(String email) {
    if (!isAvailable) return null;
    for (final json in _cache['pending_approvals']!.values) {
      if (json['email'] == email) {
        return PendingApproval.fromJson(Map<String, dynamic>.from(json));
      }
    }
    return null;
  }

  static PendingApproval? getPendingApprovalById(String approvalId) {
    return _getById(
        'pending_approvals', approvalId, PendingApproval.fromJson);
  }

  static void savePendingApproval(PendingApproval approval) {
    if (!isAvailable) return;
    _put('pending_approvals', approval.id, approval.toJson());
  }

  static void deletePendingApproval(String approvalId) {
    if (!isAvailable) return;
    _remove('pending_approvals', approvalId);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CLEAR ALL DATA
  // ═══════════════════════════════════════════════════════════════════════════

  static void clearAll() {
    if (!isAvailable) return;
    for (final table in _tables) {
      _cache[table]!.clear();
      _db?.delete(table);
    }
    _settingsCache.clear();
    _db?.delete('settings');
    _emitNotifications();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SYNC TIME TRACKING
  // ═══════════════════════════════════════════════════════════════════════════

  static const String _syncTimeKey = 'last_sync_time';

  /// Save the last sync time
  static void saveSyncTime(DateTime time) {
    if (!isAvailable) return;
    saveSetting(_syncTimeKey, time.millisecondsSinceEpoch);
  }

  /// Load the last sync time
  static Future<DateTime?> loadSyncTime() async {
    if (!isAvailable) return null;
    final millis = getSetting<int>(_syncTimeKey);
    if (millis != null) {
      return DateTime.fromMillisecondsSinceEpoch(millis);
    }
    return null;
  }
}

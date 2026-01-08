import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'collections/member_collection.dart';
import 'collections/meal_collection.dart';
import 'collections/bazar_collection.dart';
import 'collections/transaction_collection.dart';
import 'collections/settings_collection.dart';
import 'collections/duty_collection.dart';
import 'collections/unified_entry_collection.dart';
import 'collections/settlement_collection.dart';
import 'collections/ramadan_collection.dart';
import 'collections/pending_approval_collection.dart';

import '../models/member.dart';
import '../models/meal.dart';
import '../models/bazar_entry.dart';
import '../models/money_transaction.dart';
import '../models/duty.dart';
import '../models/unified_entry.dart';
import '../models/settlement.dart';
import '../models/ramadan.dart';
import 'collections/app_notification_collection.dart';
import '../models/app_notification.dart';

/// Isar Database Service
/// Provides local persistence using Isar Plus with type-safe model methods
/// Note: Isar is disabled on web (uses Firebase/in-memory instead)
class IsarService {
  static Isar? _isar;
  static bool _isWebPlatform = false;

  /// Get the Isar instance
  static Isar get instance {
    if (_isWebPlatform) {
      throw StateError(
        'IsarService is not available on web. Use Firebase or in-memory storage.',
      );
    }
    if (_isar == null) {
      throw StateError(
        'IsarService not initialized. Call IsarService.init() first.',
      );
    }
    return _isar!;
  }

  /// Check if Isar is available (not on web)
  static bool get isAvailable => !_isWebPlatform && _isar != null;

  /// Initialize the Isar database
  static Future<void> init() async {
    // Isar uses path_provider which is not supported on web
    if (kIsWeb) {
      _isWebPlatform = true;
      debugPrint(
        'IsarService: Skipped on web platform (using in-memory/Firebase)',
      );
      return;
    }

    if (_isar != null) return;

    final dir = await getApplicationDocumentsDirectory();

    _isar = Isar.open(
      schemas: [
        MemberCollectionSchema,
        MealCollectionSchema,
        BazarEntryCollectionSchema,
        TransactionCollectionSchema,
        SettingsCollectionSchema,
        DutyAssignmentCollectionSchema,
        DutyScheduleCollectionSchema,
        DutyDebtCollectionSchema,
        UnifiedEntryCollectionSchema,
        SettlementCollectionSchema,
        RamadanSeasonCollectionSchema,
        RamadanMealCollectionSchema,
        RamadanBazarCollectionSchema,
        RamadanMealCollectionSchema,
        RamadanBazarCollectionSchema,
        AppNotificationCollectionSchema,
        PendingApprovalCollectionSchema,
      ],
      directory: dir.path,
      name: 'mess_manager_db',
    );

    debugPrint('IsarService initialized at ${dir.path}');
  }

  /// Close the database
  static void close() {
    _isar?.close();
    _isar = null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SETTINGS (Key-Value Store)
  // ═══════════════════════════════════════════════════════════════════════════

  static void saveSetting<T>(String key, T value) {
    if (!isAvailable) return; // Skip on web

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

    // Delete existing setting with same key
    final existing = instance.settingsCollections
        .where()
        .keyEqualTo(key)
        .findFirst();
    if (existing != null) {
      instance.settingsCollections.delete(existing.id);
    }

    instance.settingsCollections.put(
      SettingsCollection()
        ..key = key
        ..valueJson = valueJson
        ..valueType = valueType,
    );
  }

  static T? getSetting<T>(String key, {T? defaultValue}) {
    if (!isAvailable) return defaultValue; // Skip on web

    final setting = instance.settingsCollections
        .where()
        .keyEqualTo(key)
        .findFirst();

    if (setting == null || setting.valueJson == null) {
      return defaultValue;
    }

    final valueJson = setting.valueJson!;
    final valueType = setting.valueType;

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
    if (!isAvailable) return; // Skip on web

    final existing = instance.settingsCollections
        .where()
        .keyEqualTo(key)
        .findFirst();
    if (existing != null) {
      instance.settingsCollections.delete(existing.id);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MEMBERS
  // ═══════════════════════════════════════════════════════════════════════════

  static List<Member> getAllMembers() {
    if (!isAvailable) return []; // Web fallback
    return instance.memberCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static Member? getMemberById(String memberId) {
    if (!isAvailable) return null; // Web fallback
    final collection = instance.memberCollections
        .where()
        .memberIdEqualTo(memberId)
        .findFirst();
    return collection?.toModel();
  }

  static void saveMember(Member member) {
    if (!isAvailable) return; // Web fallback
    final collection = MemberCollection.fromModel(member);
    final existing = instance.memberCollections
        .where()
        .memberIdEqualTo(member.id)
        .findFirst();
    if (existing != null) {
      collection.id = existing.id;
    }
    instance.memberCollections.put(collection);
  }

  static void saveMembers(List<Member> members) {
    for (final member in members) {
      saveMember(member);
    }
  }

  static void deleteMember(String memberId) {
    if (!isAvailable) return; // Web fallback
    final existing = instance.memberCollections
        .where()
        .memberIdEqualTo(memberId)
        .findFirst();
    if (existing != null) {
      instance.memberCollections.delete(existing.id);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MEALS
  // ═══════════════════════════════════════════════════════════════════════════

  static List<Meal> getAllMeals() {
    if (!isAvailable) return []; // Web fallback
    return instance.mealCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static List<Meal> getMealsByDate(DateTime date) {
    if (!isAvailable) return []; // Web fallback
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return instance.mealCollections
        .where()
        .dateBetween(startOfDay, endOfDay)
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static List<Meal> getMealsByMember(String memberId) {
    if (!isAvailable) return []; // Web fallback
    return instance.mealCollections
        .where()
        .memberIdEqualTo(memberId)
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveMeal(Meal meal) {
    if (!isAvailable) return; // Web fallback
    final collection = MealCollection.fromModel(meal);
    final existing = instance.mealCollections
        .where()
        .mealIdEqualTo(meal.id)
        .findFirst();
    if (existing != null) {
      collection.id = existing.id;
    }
    instance.mealCollections.put(collection);
  }

  static void saveMeals(List<Meal> meals) {
    for (final meal in meals) {
      saveMeal(meal);
    }
  }

  static void deleteMeal(String mealId) {
    if (!isAvailable) return; // Web fallback
    final existing = instance.mealCollections
        .where()
        .mealIdEqualTo(mealId)
        .findFirst();
    if (existing != null) {
      instance.mealCollections.delete(existing.id);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BAZAR ENTRIES
  // ═══════════════════════════════════════════════════════════════════════════

  static List<BazarEntry> getAllBazarEntries() {
    if (!isAvailable) return []; // Web fallback
    return instance.bazarEntryCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveBazarEntry(BazarEntry entry) {
    if (!isAvailable) return; // Web fallback
    final collection = BazarEntryCollection.fromModel(entry);
    final existing = instance.bazarEntryCollections
        .where()
        .entryIdEqualTo(entry.id)
        .findFirst();
    if (existing != null) {
      collection.id = existing.id;
    }
    instance.bazarEntryCollections.put(collection);
  }

  static void saveBazarEntries(List<BazarEntry> entries) {
    for (final entry in entries) {
      saveBazarEntry(entry);
    }
  }

  static void deleteBazarEntry(String entryId) {
    if (!isAvailable) return; // Web fallback
    final existing = instance.bazarEntryCollections
        .where()
        .entryIdEqualTo(entryId)
        .findFirst();
    if (existing != null) {
      instance.bazarEntryCollections.delete(existing.id);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TRANSACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  static List<MoneyTransaction> getAllTransactions() {
    if (!isAvailable) return []; // Web fallback
    return instance.transactionCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveTransaction(MoneyTransaction transaction) {
    if (!isAvailable) return; // Web fallback
    final collection = TransactionCollection.fromModel(transaction);
    final existing = instance.transactionCollections
        .where()
        .transactionIdEqualTo(transaction.id)
        .findFirst();
    if (existing != null) {
      collection.id = existing.id;
    }
    instance.transactionCollections.put(collection);
  }

  static void saveTransactions(List<MoneyTransaction> transactions) {
    for (final t in transactions) {
      saveTransaction(t);
    }
  }

  static void deleteTransaction(String transactionId) {
    if (!isAvailable) return; // Web fallback
    final existing = instance.transactionCollections
        .where()
        .transactionIdEqualTo(transactionId)
        .findFirst();
    if (existing != null) {
      instance.transactionCollections.delete(existing.id);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DUTY SCHEDULES
  // ═══════════════════════════════════════════════════════════════════════════

  static List<DutySchedule> getAllDutySchedules() {
    if (!isAvailable) return []; // Web fallback
    return instance.dutyScheduleCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveDutySchedule(DutySchedule schedule) {
    if (!isAvailable) return; // Web fallback
    final collection = DutyScheduleCollection.fromModel(schedule);
    final existing = instance.dutyScheduleCollections
        .where()
        .scheduleIdEqualTo(schedule.id)
        .findFirst();
    if (existing != null) {
      collection.id = existing.id;
    }
    instance.dutyScheduleCollections.put(collection);
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
    if (!isAvailable) return []; // Web fallback
    return instance.dutyAssignmentCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveDutyAssignment(DutyAssignment assignment) {
    if (!isAvailable) return; // Web fallback
    final collection = DutyAssignmentCollection.fromModel(assignment);
    final existing = instance.dutyAssignmentCollections
        .where()
        .assignmentIdEqualTo(assignment.id)
        .findFirst();
    if (existing != null) {
      collection.id = existing.id;
    }
    instance.dutyAssignmentCollections.put(collection);
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
    if (!isAvailable) return []; // Web fallback
    return instance.dutyDebtCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveDutyDebt(DutyDebt debt) {
    if (!isAvailable) return; // Web fallback
    final collection = DutyDebtCollection.fromModel(debt);
    final existing = instance.dutyDebtCollections
        .where()
        .debtIdEqualTo(debt.id)
        .findFirst();
    if (existing != null) {
      collection.id = existing.id;
    }
    instance.dutyDebtCollections.put(collection);
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
    if (!isAvailable) return []; // Web fallback
    return instance.unifiedEntryCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveUnifiedEntry(UnifiedEntry entry) {
    if (!isAvailable) return; // Web fallback
    final collection = UnifiedEntryCollection.fromModel(entry);
    final existing = instance.unifiedEntryCollections
        .where()
        .entryIdEqualTo(entry.id)
        .findFirst();
    if (existing != null) {
      collection.id = existing.id;
    }
    instance.unifiedEntryCollections.put(collection);
  }

  static void saveUnifiedEntries(List<UnifiedEntry> entries) {
    for (final e in entries) {
      saveUnifiedEntry(e);
    }
  }

  static void deleteUnifiedEntry(String entryId) {
    if (!isAvailable) return; // Web fallback
    final existing = instance.unifiedEntryCollections
        .where()
        .entryIdEqualTo(entryId)
        .findFirst();
    if (existing != null) {
      instance.unifiedEntryCollections.delete(existing.id);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SETTLEMENTS
  // ═══════════════════════════════════════════════════════════════════════════

  static List<Settlement> getAllSettlements() {
    if (!isAvailable) return []; // Web fallback
    return instance.settlementCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveSettlement(Settlement settlement) {
    if (!isAvailable) return; // Web fallback
    final collection = SettlementCollection.fromModel(settlement);
    final existing = instance.settlementCollections
        .where()
        .settlementIdEqualTo(settlement.id)
        .findFirst();
    if (existing != null) {
      collection.id = existing.id;
    }
    instance.settlementCollections.put(collection);
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
    if (!isAvailable) return []; // Web fallback
    return instance.ramadanSeasonCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveRamadanSeason(RamadanSeason season) {
    if (!isAvailable) return; // Web fallback
    final collection = RamadanSeasonCollection.fromModel(season);
    final existing = instance.ramadanSeasonCollections
        .where()
        .seasonIdEqualTo(season.id)
        .findFirst();
    if (existing != null) {
      collection.id = existing.id;
    }
    instance.ramadanSeasonCollections.put(collection);
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
    if (!isAvailable) return []; // Web fallback
    return instance.ramadanMealCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveRamadanMeal(RamadanMeal meal) {
    if (!isAvailable) return; // Web fallback
    final collection = RamadanMealCollection.fromModel(meal);
    final existing = instance.ramadanMealCollections
        .where()
        .mealIdEqualTo(meal.id)
        .findFirst();
    if (existing != null) {
      collection.id = existing.id;
    }
    instance.ramadanMealCollections.put(collection);
  }

  static void saveRamadanMeals(List<RamadanMeal> meals) {
    for (final m in meals) {
      saveRamadanMeal(m);
    }
  }

  static void deleteRamadanMeal(String mealId) {
    if (!isAvailable) return; // Web fallback
    final existing = instance.ramadanMealCollections
        .where()
        .mealIdEqualTo(mealId)
        .findFirst();
    if (existing != null) {
      instance.ramadanMealCollections.delete(existing.id);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RAMADAN BAZAR
  // ═══════════════════════════════════════════════════════════════════════════

  static List<RamadanBazar> getAllRamadanBazar() {
    if (!isAvailable) return []; // Web fallback
    return instance.ramadanBazarCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveRamadanBazar(RamadanBazar bazar) {
    if (!isAvailable) return; // Web fallback
    final collection = RamadanBazarCollection.fromModel(bazar);
    final existing = instance.ramadanBazarCollections
        .where()
        .bazarIdEqualTo(bazar.id)
        .findFirst();
    if (existing != null) {
      collection.id = existing.id;
    }
    instance.ramadanBazarCollections.put(collection);
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
    if (!isAvailable) return []; // Web fallback
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
    if (!isAvailable) return; // Web fallback
    final json = payments.map((p) => p.toJson()).toList();
    saveSetting('ramadan_payments', json);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NOTIFICATIONS (Collection Pattern)
  // ═══════════════════════════════════════════════════════════════════════════

  static List<AppNotification> getAllNotifications() {
    if (!isAvailable) return []; // Web fallback
    return instance.appNotificationCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  static void saveNotification(AppNotification notification) {
    if (!isAvailable) return; // Web fallback
    instance.appNotificationCollections.put(
      AppNotificationCollection.fromModel(notification),
    );
  }

  static void saveNotifications(List<AppNotification> notifications) {
    if (!isAvailable) return; // Web fallback
    if (notifications.isEmpty) return;
    final cols = notifications
        .map((n) => AppNotificationCollection.fromModel(n))
        .toList();
    instance.appNotificationCollections.putAll(cols);
  }

  static void deleteNotification(String id) {
    if (!isAvailable) return; // Web fallback
    final existing = instance.appNotificationCollections
        .where()
        .notificationIdEqualTo(id)
        .findFirst();

    if (existing != null) {
      instance.appNotificationCollections.delete(existing.id);
    }
  }

  static void markAllNotificationsAsRead() {
    if (!isAvailable) return; // Web fallback
    final all = instance.appNotificationCollections.where().findAll();
    final unread = all.where((e) => !e.isRead).toList();
    if (unread.isEmpty) return;

    for (var c in unread) {
      c.isRead = true;
    }

    instance.appNotificationCollections.putAll(unread);
  }

  static void clearNotifications() {
    if (!isAvailable) return; // Web fallback
    instance.appNotificationCollections.clear();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PENDING APPROVALS
  // ═══════════════════════════════════════════════════════════════════════════

  static List<PendingApproval> getAllPendingApprovals() {
    if (!isAvailable) return []; // Web fallback
    return instance.pendingApprovalCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList()
      ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));
  }

  static List<PendingApproval> getPendingApprovalsByStatus(
    ApprovalStatus status,
  ) {
    if (!isAvailable) return []; // Web fallback
    return instance.pendingApprovalCollections
        .where()
        .statusIndexEqualTo(status.index)
        .findAll()
        .map((c) => c.toModel())
        .toList()
      ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));
  }

  static PendingApproval? getPendingApprovalByEmail(String email) {
    if (!isAvailable) return null; // Web fallback
    final collection = instance.pendingApprovalCollections
        .where()
        .findAll()
        .where((c) => c.email == email)
        .firstOrNull;
    return collection?.toModel();
  }

  static PendingApproval? getPendingApprovalById(String approvalId) {
    if (!isAvailable) return null; // Web fallback
    final collection = instance.pendingApprovalCollections
        .where()
        .approvalIdEqualTo(approvalId)
        .findFirst();
    return collection?.toModel();
  }

  static void savePendingApproval(PendingApproval approval) {
    if (!isAvailable) return; // Web fallback
    final collection = PendingApprovalCollection.fromModel(approval);
    final existing = instance.pendingApprovalCollections
        .where()
        .approvalIdEqualTo(approval.id)
        .findFirst();
    if (existing != null) {
      collection.id = existing.id;
    }
    instance.pendingApprovalCollections.put(collection);
  }

  static void deletePendingApproval(String approvalId) {
    if (!isAvailable) return; // Web fallback
    final existing = instance.pendingApprovalCollections
        .where()
        .approvalIdEqualTo(approvalId)
        .findFirst();
    if (existing != null) {
      instance.pendingApprovalCollections.delete(existing.id);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CLEAR ALL DATA
  // ═══════════════════════════════════════════════════════════════════════════

  static void clearAll() {
    if (!isAvailable) return; // Web fallback
    instance.appNotificationCollections.clear();
    instance.clear();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SYNC TIME TRACKING
  // ═══════════════════════════════════════════════════════════════════════════

  static const String _syncTimeKey = 'last_sync_time';

  /// Save the last sync time
  static void saveSyncTime(DateTime time) {
    if (!isAvailable) return;
    final settings = instance.settingsCollections
        .where()
        .keyEqualTo(_syncTimeKey)
        .findFirst();
    final collection = SettingsCollection()
      ..key = _syncTimeKey
      ..valueJson = time.millisecondsSinceEpoch.toString()
      ..valueType = 'int';
    if (settings != null) {
      collection.id = settings.id;
    }
    instance.settingsCollections.put(collection);
  }

  /// Load the last sync time
  static Future<DateTime?> loadSyncTime() async {
    if (!isAvailable) return null;
    final settings = instance.settingsCollections
        .where()
        .keyEqualTo(_syncTimeKey)
        .findFirst();
    if (settings?.valueJson != null) {
      final millis = int.tryParse(settings!.valueJson!);
      if (millis != null) {
        return DateTime.fromMillisecondsSinceEpoch(millis);
      }
    }
    return null;
  }
}

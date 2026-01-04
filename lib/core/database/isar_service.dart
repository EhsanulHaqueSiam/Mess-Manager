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

import '../models/member.dart';
import '../models/meal.dart';
import '../models/bazar_entry.dart';
import '../models/money_transaction.dart';
import '../models/duty.dart';
import '../models/unified_entry.dart';
import '../models/settlement.dart';
import '../models/ramadan.dart';

/// Isar Database Service
/// Provides local persistence using Isar Plus with type-safe model methods
class IsarService {
  static Isar? _isar;

  /// Get the Isar instance
  static Isar get instance {
    if (_isar == null) {
      throw StateError(
        'IsarService not initialized. Call IsarService.init() first.',
      );
    }
    return _isar!;
  }

  /// Initialize the Isar database
  static Future<void> init() async {
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
    return instance.memberCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static Member? getMemberById(String memberId) {
    final collection = instance.memberCollections
        .where()
        .memberIdEqualTo(memberId)
        .findFirst();
    return collection?.toModel();
  }

  static void saveMember(Member member) {
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
    return instance.mealCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static List<Meal> getMealsByDate(DateTime date) {
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
    return instance.mealCollections
        .where()
        .memberIdEqualTo(memberId)
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveMeal(Meal meal) {
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
    return instance.bazarEntryCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveBazarEntry(BazarEntry entry) {
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
    return instance.transactionCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveTransaction(MoneyTransaction transaction) {
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
    return instance.dutyScheduleCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveDutySchedule(DutySchedule schedule) {
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
    return instance.dutyAssignmentCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveDutyAssignment(DutyAssignment assignment) {
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
    return instance.dutyDebtCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveDutyDebt(DutyDebt debt) {
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
    return instance.unifiedEntryCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveUnifiedEntry(UnifiedEntry entry) {
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
    return instance.settlementCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveSettlement(Settlement settlement) {
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
    return instance.ramadanSeasonCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveRamadanSeason(RamadanSeason season) {
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
    return instance.ramadanMealCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveRamadanMeal(RamadanMeal meal) {
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
    return instance.ramadanBazarCollections
        .where()
        .findAll()
        .map((c) => c.toModel())
        .toList();
  }

  static void saveRamadanBazar(RamadanBazar bazar) {
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
  // CLEAR ALL DATA
  // ═══════════════════════════════════════════════════════════════════════════

  static void clearAll() {
    instance.clear();
  }
}

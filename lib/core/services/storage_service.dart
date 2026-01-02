import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

/// Storage service for persisting app data using Hive
class StorageService {
  static const String _membersBox = 'members';
  static const String _mealsBox = 'meals';
  static const String _bazarBox = 'bazar';
  static const String _bazarListBox = 'bazar_list';
  static const String _transactionsBox = 'transactions';
  static const String _scheduleBox = 'schedules';
  static const String _settingsBox = 'settings';
  static const String _ramadanSeasonsBox = 'ramadan_seasons';
  static const String _ramadanMealsBox = 'ramadan_meals';
  static const String _ramadanBazarBox = 'ramadan_bazar';
  static const String _settlementsBox = 'settlements';

  /// Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();

    // Open all boxes
    await Hive.openBox<String>(_membersBox);
    await Hive.openBox<String>(_mealsBox);
    await Hive.openBox<String>(_bazarBox);
    await Hive.openBox<String>(_bazarListBox);
    await Hive.openBox<String>(_transactionsBox);
    await Hive.openBox<String>(_scheduleBox);
    await Hive.openBox<dynamic>(_settingsBox);
    // Ramadan & Settlement
    await Hive.openBox<String>(_ramadanSeasonsBox);
    await Hive.openBox<String>(_ramadanMealsBox);
    await Hive.openBox<String>(_ramadanBazarBox);
    await Hive.openBox<String>(_settlementsBox);
  }

  // ============ Generic JSON Storage ============

  /// Save a list of items as JSON
  static Future<void> saveList<T>({
    required String boxName,
    required List<T> items,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    final box = Hive.box<String>(boxName);
    await box.clear();
    for (var i = 0; i < items.length; i++) {
      await box.put(i.toString(), jsonEncode(toJson(items[i])));
    }
  }

  /// Load a list of items from JSON
  static List<T> loadList<T>({
    required String boxName,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    final box = Hive.box<String>(boxName);
    final items = <T>[];
    for (final key in box.keys) {
      final json = box.get(key);
      if (json != null) {
        try {
          items.add(fromJson(jsonDecode(json) as Map<String, dynamic>));
        } catch (e) {
          // Skip corrupted entries
        }
      }
    }
    return items;
  }

  // ============ Members ============

  static Future<void> saveMembers(List<dynamic> members) async {
    await saveList(
      boxName: _membersBox,
      items: members,
      toJson: (m) => m.toJson(),
    );
  }

  static List<Map<String, dynamic>> loadMembersJson() {
    final box = Hive.box<String>(_membersBox);
    final items = <Map<String, dynamic>>[];
    for (final key in box.keys) {
      final json = box.get(key);
      if (json != null) {
        try {
          items.add(jsonDecode(json) as Map<String, dynamic>);
        } catch (e) {
          // Skip corrupted
        }
      }
    }
    return items;
  }

  // ============ Meals ============

  static Future<void> saveMeals(List<dynamic> meals) async {
    await saveList(boxName: _mealsBox, items: meals, toJson: (m) => m.toJson());
  }

  static List<Map<String, dynamic>> loadMealsJson() {
    final box = Hive.box<String>(_mealsBox);
    final items = <Map<String, dynamic>>[];
    for (final key in box.keys) {
      final json = box.get(key);
      if (json != null) {
        try {
          items.add(jsonDecode(json) as Map<String, dynamic>);
        } catch (e) {
          // Skip
        }
      }
    }
    return items;
  }

  // ============ Bazar ============

  static Future<void> saveBazarEntries(List<dynamic> entries) async {
    await saveList(
      boxName: _bazarBox,
      items: entries,
      toJson: (e) => e.toJson(),
    );
  }

  static List<Map<String, dynamic>> loadBazarEntriesJson() {
    final box = Hive.box<String>(_bazarBox);
    final items = <Map<String, dynamic>>[];
    for (final key in box.keys) {
      final json = box.get(key);
      if (json != null) {
        try {
          items.add(jsonDecode(json) as Map<String, dynamic>);
        } catch (e) {
          // Skip
        }
      }
    }
    return items;
  }

  // ============ Bazar List ============

  static Future<void> saveBazarList(List<dynamic> items) async {
    await saveList(
      boxName: _bazarListBox,
      items: items,
      toJson: (i) => i.toJson(),
    );
  }

  static List<Map<String, dynamic>> loadBazarListJson() {
    final box = Hive.box<String>(_bazarListBox);
    final items = <Map<String, dynamic>>[];
    for (final key in box.keys) {
      final json = box.get(key);
      if (json != null) {
        try {
          items.add(jsonDecode(json) as Map<String, dynamic>);
        } catch (e) {
          // Skip
        }
      }
    }
    return items;
  }

  // ============ Transactions ============

  static Future<void> saveTransactions(List<dynamic> transactions) async {
    await saveList(
      boxName: _transactionsBox,
      items: transactions,
      toJson: (t) => t.toJson(),
    );
  }

  static List<Map<String, dynamic>> loadTransactionsJson() {
    final box = Hive.box<String>(_transactionsBox);
    final items = <Map<String, dynamic>>[];
    for (final key in box.keys) {
      final json = box.get(key);
      if (json != null) {
        try {
          items.add(jsonDecode(json) as Map<String, dynamic>);
        } catch (e) {
          // Skip
        }
      }
    }
    return items;
  }

  // ============ Settings ============

  static Future<void> saveSetting(String key, dynamic value) async {
    final box = Hive.box<dynamic>(_settingsBox);
    await box.put(key, value);
  }

  static T? getSetting<T>(String key, {T? defaultValue}) {
    final box = Hive.box<dynamic>(_settingsBox);
    return box.get(key, defaultValue: defaultValue) as T?;
  }

  static Future<void> removeSetting(String key) async {
    final box = Hive.box<dynamic>(_settingsBox);
    await box.delete(key);
  }

  // ============ Theme ============

  static Future<void> saveThemeMode(bool isDark) async {
    await saveSetting('isDarkMode', isDark);
  }

  static bool loadThemeMode() {
    return getSetting<bool>('isDarkMode', defaultValue: true) ?? true;
  }

  // ============ Current Member ============

  static Future<void> saveCurrentMemberId(String id) async {
    await saveSetting('currentMemberId', id);
  }

  static String? loadCurrentMemberId() {
    return getSetting<String>('currentMemberId');
  }

  // ============ Clear All ============

  static Future<void> clearAll() async {
    await Hive.box<String>(_membersBox).clear();
    await Hive.box<String>(_mealsBox).clear();
    await Hive.box<String>(_bazarBox).clear();
    await Hive.box<String>(_bazarListBox).clear();
    await Hive.box<String>(_transactionsBox).clear();
  }

  // ============ Unified Entries ============

  static const String _unifiedEntriesBox = 'unified_entries';

  static Future<void> initUnifiedBox() async {
    if (!Hive.isBoxOpen(_unifiedEntriesBox)) {
      await Hive.openBox<String>(_unifiedEntriesBox);
    }
  }

  static Future<void> saveUnifiedEntries(List<dynamic> entries) async {
    await initUnifiedBox();
    await saveList(
      boxName: _unifiedEntriesBox,
      items: entries,
      toJson: (e) => e.toJson(),
    );
  }

  static List<Map<String, dynamic>> loadUnifiedEntriesJson() {
    if (!Hive.isBoxOpen(_unifiedEntriesBox)) return [];
    final box = Hive.box<String>(_unifiedEntriesBox);
    final items = <Map<String, dynamic>>[];
    for (final key in box.keys) {
      final json = box.get(key);
      if (json != null) {
        try {
          items.add(jsonDecode(json) as Map<String, dynamic>);
        } catch (e) {
          // Skip
        }
      }
    }
    return items;
  }
}

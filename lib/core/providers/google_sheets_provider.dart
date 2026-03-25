import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:mess_manager/core/services/google_sheets_service.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';

/// State for Google Sheets sync configuration.
class GoogleSheetsState {
  final bool isEnabled;
  final String sheetUrl;
  final DateTime? lastSync;
  final bool isSyncing;
  final String? error;

  const GoogleSheetsState({
    this.isEnabled = false,
    this.sheetUrl = '',
    this.lastSync,
    this.isSyncing = false,
    this.error,
  });

  GoogleSheetsState copyWith({
    bool? isEnabled,
    String? sheetUrl,
    DateTime? lastSync,
    bool? isSyncing,
    String? error,
  }) {
    return GoogleSheetsState(
      isEnabled: isEnabled ?? this.isEnabled,
      sheetUrl: sheetUrl ?? this.sheetUrl,
      lastSync: lastSync ?? this.lastSync,
      isSyncing: isSyncing ?? this.isSyncing,
      error: error,
    );
  }
}

/// Notifier for Google Sheets sync.
class GoogleSheetsNotifier extends Notifier<GoogleSheetsState> {
  final _service = GoogleSheetsService();

  @override
  GoogleSheetsState build() {
    _loadSavedState();
    return const GoogleSheetsState();
  }

  Future<void> _loadSavedState() async {
    await _service.init();
    final lastSync = await _service.getLastSync();
    state = state.copyWith(
      isEnabled: _service.isEnabled,
      sheetUrl: _service.spreadsheetId ?? '',
      lastSync: lastSync,
    );
  }

  /// Update sheet URL and enabled state.
  Future<void> configure({required String sheetUrl, required bool enabled}) async {
    state = state.copyWith(sheetUrl: sheetUrl, isEnabled: enabled, error: null);
    await _service.configure(sheetUrl: sheetUrl, enabled: enabled);
  }

  /// Test the connection to the configured sheet.
  Future<bool> testConnection() async {
    state = state.copyWith(isSyncing: true, error: null);
    final error = await _service.testConnection();
    state = state.copyWith(isSyncing: false, error: error);
    return error == null;
  }

  /// Manually trigger a sync of today's data.
  Future<SyncResult> syncNow() async {
    state = state.copyWith(isSyncing: true, error: null);

    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final members = ref.read(membersProvider);
      final meals = ref.read(mealsProvider);
      final bazarEntries = ref.read(bazarEntriesProvider);
      final mealRate = ref.read(mealRateProvider);
      final totalBazar = ref.read(totalBazarProvider);

      // Build meal rows for today
      final todayMeals = meals
          .where((m) => DateFormat('yyyy-MM-dd').format(m.date) == today)
          .toList();
      final mealRows = todayMeals.map((m) {
        final member = members.where((mb) => mb.id == m.memberId).firstOrNull;
        return {
          'date': today,
          'member': member?.name ?? m.memberId,
          'count': m.count,
          'type': m.type.name,
        };
      }).toList();

      // Build bazar rows for today
      final todayBazar = bazarEntries
          .where((b) => DateFormat('yyyy-MM-dd').format(b.date) == today)
          .toList();
      final bazarRows = todayBazar.map((b) {
        final member = members.where((mb) => mb.id == b.memberId).firstOrNull;
        return {
          'date': today,
          'member': member?.name ?? b.memberId,
          'amount': b.amount,
          'description': b.description ?? '',
          'items': b.isItemized
              ? b.items.map((i) => '${i.name}: ৳${i.price}').join(', ')
              : '',
        };
      }).toList();

      // Build balance rows
      final totalMeals = meals.fold(0.0, (sum, m) => sum + m.count);
      final balanceRows = members.map((m) {
        final memberMeals =
            meals.where((ml) => ml.memberId == m.id).fold(0.0, (s, ml) => s + ml.count);
        final memberBazar =
            bazarEntries.where((b) => b.memberId == m.id).fold(0.0, (s, b) => s + b.amount);
        final mealCost = memberMeals * mealRate;
        return {
          'date': today,
          'member': m.name,
          'meals': memberMeals,
          'bazarSpent': memberBazar,
          'mealCost': mealCost,
          'balance': memberBazar - mealCost,
        };
      }).toList();

      final result = await _service.syncDailyData(
        date: today,
        totalMeals: totalMeals,
        totalBazar: totalBazar,
        mealRate: mealRate,
        memberCount: members.length,
        mealRows: mealRows,
        bazarRows: bazarRows,
        balanceRows: balanceRows,
      );

      switch (result) {
        case SyncResult.success:
          final lastSync = await _service.getLastSync();
          state = state.copyWith(isSyncing: false, lastSync: lastSync);
        case SyncResult.authFailed:
          state = state.copyWith(
            isSyncing: false,
            error: 'Google sign-in required',
          );
        case SyncResult.disabled:
          state = state.copyWith(isSyncing: false);
        case SyncResult.error:
          state = state.copyWith(
            isSyncing: false,
            error: 'Sync failed — check sheet permissions',
          );
      }
      return result;
    } catch (e) {
      debugPrint('GoogleSheetsNotifier: Sync error: $e');
      state = state.copyWith(isSyncing: false, error: e.toString());
      return SyncResult.error;
    }
  }
}

final googleSheetsProvider =
    NotifierProvider<GoogleSheetsNotifier, GoogleSheetsState>(
  GoogleSheetsNotifier.new,
);

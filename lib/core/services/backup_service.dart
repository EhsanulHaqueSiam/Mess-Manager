import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/models/bazar_entry.dart';
import 'package:mess_manager/core/models/money_transaction.dart';
import 'package:mess_manager/core/models/duty.dart';
import 'package:mess_manager/core/models/unified_entry.dart';
import 'package:mess_manager/core/models/settlement.dart';
import 'package:mess_manager/core/models/ramadan.dart';

class BackupService {
  static const String _version = '1.0';

  /// create and share backup file
  static Future<void> createBackup() async {
    final data = <String, dynamic>{
      'version': _version,
      'timestamp': DateTime.now().toIso8601String(),
      'members': IsarService.getAllMembers().map((e) => e.toJson()).toList(),
      'meals': IsarService.getAllMeals().map((e) => e.toJson()).toList(),
      'bazar_entries': IsarService.getAllBazarEntries()
          .map((e) => e.toJson())
          .toList(),
      'transactions': IsarService.getAllTransactions()
          .map((e) => e.toJson())
          .toList(),
      'duty_schedules': IsarService.getAllDutySchedules()
          .map((e) => e.toJson())
          .toList(),
      'duty_assignments': IsarService.getAllDutyAssignments()
          .map((e) => e.toJson())
          .toList(),
      'duty_debts': IsarService.getAllDutyDebts()
          .map((e) => e.toJson())
          .toList(),
      'unified_entries': IsarService.getAllUnifiedEntries()
          .map((e) => e.toJson())
          .toList(),
      'settlements': IsarService.getAllSettlements()
          .map((e) => e.toJson())
          .toList(),
      'ramadan_seasons': IsarService.getAllRamadanSeasons()
          .map((e) => e.toJson())
          .toList(),
      'ramadan_meals': IsarService.getAllRamadanMeals()
          .map((e) => e.toJson())
          .toList(),
      'ramadan_bazar': IsarService.getAllRamadanBazar()
          .map((e) => e.toJson())
          .toList(),
    };

    final jsonString = jsonEncode(data);
    final directory = await getTemporaryDirectory();
    final date = DateTime.now();
    final fileName =
        'area51_backup_${date.year}${date.month}${date.day}_${date.hour}${date.minute}.json';
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(jsonString);

    await Share.shareXFiles([XFile(file.path)], text: 'Area51 Backup');
  }

  /// restore from backup file
  static Future<bool> restoreBackup() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) return false;

      final file = File(result.files.single.path!);
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      IsarService.clearAll();

      if (data.containsKey('members')) {
        final list = (data['members'] as List)
            .map((e) => Member.fromJson(e))
            .toList();
        IsarService.saveMembers(list);
      }

      if (data.containsKey('meals')) {
        final list = (data['meals'] as List)
            .map((e) => Meal.fromJson(e))
            .toList();
        IsarService.saveMeals(list);
      }

      if (data.containsKey('bazar_entries')) {
        final list = (data['bazar_entries'] as List)
            .map((e) => BazarEntry.fromJson(e))
            .toList();
        IsarService.saveBazarEntries(list);
      }

      if (data.containsKey('transactions')) {
        final list = (data['transactions'] as List)
            .map((e) => MoneyTransaction.fromJson(e))
            .toList();
        IsarService.saveTransactions(list);
      }

      if (data.containsKey('duty_schedules')) {
        final list = (data['duty_schedules'] as List)
            .map((e) => DutySchedule.fromJson(e))
            .toList();
        IsarService.saveDutySchedules(list);
      }

      if (data.containsKey('duty_assignments')) {
        final list = (data['duty_assignments'] as List)
            .map((e) => DutyAssignment.fromJson(e))
            .toList();
        IsarService.saveDutyAssignments(list);
      }

      if (data.containsKey('duty_debts')) {
        final list = (data['duty_debts'] as List)
            .map((e) => DutyDebt.fromJson(e))
            .toList();
        IsarService.saveDutyDebts(list);
      }

      if (data.containsKey('unified_entries')) {
        final list = (data['unified_entries'] as List)
            .map((e) => UnifiedEntry.fromJson(e))
            .toList();
        IsarService.saveUnifiedEntries(list);
      }

      if (data.containsKey('settlements')) {
        final list = (data['settlements'] as List)
            .map((e) => Settlement.fromJson(e))
            .toList();
        IsarService.saveSettlements(list);
      }

      if (data.containsKey('ramadan_seasons')) {
        final list = (data['ramadan_seasons'] as List)
            .map((e) => RamadanSeason.fromJson(e))
            .toList();
        IsarService.saveRamadanSeasons(list);
      }

      if (data.containsKey('ramadan_meals')) {
        final list = (data['ramadan_meals'] as List)
            .map((e) => RamadanMeal.fromJson(e))
            .toList();
        IsarService.saveRamadanMeals(list);
      }

      if (data.containsKey('ramadan_bazar')) {
        final list = (data['ramadan_bazar'] as List)
            .map((e) => RamadanBazar.fromJson(e))
            .toList();
        IsarService.saveRamadanBazars(list);
      }

      return true;
    } catch (e) {
      // debugPrint('Restore Error: $e');
      return false;
    }
  }
}

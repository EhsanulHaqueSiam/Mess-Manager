import 'package:flutter/foundation.dart';
import 'package:mess_manager/core/database/isar_service.dart';
import 'package:mess_manager/core/models/member.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/models/bazar_entry.dart';
import 'package:mess_manager/core/models/money_transaction.dart';

/// Mock Data Service for Development Testing
///
/// Creates realistic test data for all app features.
/// Only available in debug mode - safe to remove before production.
///
/// Usage: Call `MockDataService.seedAll()` after dev login
class MockDataService {
  /// Check if already seeded (avoid duplicates)
  static bool _isSeeded = false;

  /// Seed all mock data
  static Future<void> seedAll() async {
    if (_isSeeded || !kDebugMode) return;

    debugPrint('🌱 MockDataService: Seeding test data...');

    await seedMembers();
    await seedMeals();
    await seedBazarEntries();
    await seedTransactions();
    await seedMessInfo();

    _isSeeded = true;
    debugPrint('✅ MockDataService: Test data seeding complete!');
  }

  /// Clear all mock data
  static Future<void> clearAll() async {
    if (!kDebugMode) return;
    IsarService.clearAll();
    _isSeeded = false;
    debugPrint('🗑️ MockDataService: All test data cleared');
  }

  /// Reset seeded flag to allow re-seeding
  static void reset() {
    _isSeeded = false;
  }

  // ============ MEMBERS ============

  static final List<Member> _mockMembers = [
    Member(
      id: 'member_1',
      name: 'Siam (You)',
      role: MemberRole.superAdmin,
      phone: '+8801711111111',
      email: 'siam@area51.com',
      balance: 1500.0,
      joinedAt: DateTime.now().subtract(const Duration(days: 180)),
      isActive: true,
    ),
    Member(
      id: 'member_2',
      name: 'Rakib Ahmed',
      role: MemberRole.admin,
      phone: '+8801722222222',
      email: 'rakib@area51.com',
      balance: -2300.0,
      joinedAt: DateTime.now().subtract(const Duration(days: 150)),
      isActive: true,
    ),
    Member(
      id: 'member_3',
      name: 'Fahim Khan',
      role: MemberRole.mealManager,
      phone: '+8801733333333',
      balance: 500.0,
      joinedAt: DateTime.now().subtract(const Duration(days: 120)),
      isActive: true,
    ),
    Member(
      id: 'member_4',
      name: 'Tanvir Hossain',
      role: MemberRole.member,
      phone: '+8801744444444',
      balance: -800.0,
      joinedAt: DateTime.now().subtract(const Duration(days: 90)),
      isActive: true,
    ),
    Member(
      id: 'member_5',
      name: 'Jubayer Rahman',
      role: MemberRole.member,
      phone: '+8801755555555',
      balance: 200.0,
      joinedAt: DateTime.now().subtract(const Duration(days: 60)),
      isActive: true,
    ),
    Member(
      id: 'member_6',
      name: 'Arif Hasan',
      role: MemberRole.temp,
      phone: '+8801766666666',
      balance: -150.0,
      joinedAt: DateTime.now().subtract(const Duration(days: 30)),
      activeFromDate: DateTime.now().subtract(const Duration(days: 30)),
      activeToDate: DateTime.now().add(const Duration(days: 60)),
      isActive: true,
    ),
    Member(
      id: 'member_7',
      name: 'Old Member (Archived)',
      role: MemberRole.member,
      balance: 0.0,
      joinedAt: DateTime.now().subtract(const Duration(days: 365)),
      isActive: false, // Archived
    ),
  ];

  static Future<void> seedMembers() async {
    for (final member in _mockMembers) {
      IsarService.saveMember(member);
    }
    debugPrint('  ✓ Seeded ${_mockMembers.length} members');
  }

  // ============ MEALS ============

  static Future<void> seedMeals() async {
    final now = DateTime.now();
    int count = 0;

    // Generate meals for last 14 days
    for (int dayOffset = 0; dayOffset < 14; dayOffset++) {
      final date = now.subtract(Duration(days: dayOffset));

      for (final member in _mockMembers.where((m) => m.isActive)) {
        // Randomize meal types per day
        final mealTypes = <MealType>[];

        // 80% have breakfast
        if ((member.id.hashCode + dayOffset) % 5 != 0) {
          mealTypes.add(MealType.breakfast);
        }
        // 90% have lunch
        if ((member.id.hashCode + dayOffset) % 10 != 0) {
          mealTypes.add(MealType.lunch);
        }
        // 85% have dinner
        if ((member.id.hashCode + dayOffset) % 7 != 0) {
          mealTypes.add(MealType.dinner);
        }

        // Create meal entries for each type
        for (final type in mealTypes) {
          final meal = Meal(
            id: 'meal_${member.id}_${dayOffset}_${type.name}',
            memberId: member.id,
            date: DateTime(date.year, date.month, date.day),
            count: 1,
            type: type,
            status: MealStatus.confirmed,
            // Add guests for variety
            guestCount:
                (dayOffset == 0 &&
                    member.id == 'member_1' &&
                    type == MealType.lunch)
                ? 2
                : 0,
            guestName:
                (dayOffset == 0 &&
                    member.id == 'member_1' &&
                    type == MealType.lunch)
                ? 'Office friends'
                : null,
            createdAt: date,
          );
          IsarService.saveMeal(meal);
          count++;
        }
      }
    }
    debugPrint('  ✓ Seeded $count meals (14 days)');
  }

  // ============ BAZAR ENTRIES ============

  static final List<Map<String, dynamic>> _bazarData = [
    {'desc': 'Rice (25kg)', 'amount': 2500.0, 'memberId': 'member_1'},
    {'desc': 'Chicken (3kg)', 'amount': 900.0, 'memberId': 'member_2'},
    {'desc': 'Vegetables', 'amount': 350.0, 'memberId': 'member_3'},
    {'desc': 'Fish (2kg)', 'amount': 800.0, 'memberId': 'member_4'},
    {'desc': 'Oil (5L)', 'amount': 1100.0, 'memberId': 'member_1'},
    {'desc': 'Onion & Garlic', 'amount': 200.0, 'memberId': 'member_5'},
    {'desc': 'Eggs (2 dozen)', 'amount': 360.0, 'memberId': 'member_2'},
    {'desc': 'Bread & Butter', 'amount': 280.0, 'memberId': 'member_3'},
    {'desc': 'Beef (2kg)', 'amount': 1400.0, 'memberId': 'member_1'},
    {'desc': 'Fruits', 'amount': 450.0, 'memberId': 'member_4'},
    {'desc': 'Spices', 'amount': 600.0, 'memberId': 'member_2'},
    {'desc': 'Milk (5L)', 'amount': 550.0, 'memberId': 'member_5'},
  ];

  static Future<void> seedBazarEntries() async {
    final now = DateTime.now();

    for (int i = 0; i < _bazarData.length; i++) {
      final data = _bazarData[i];
      final entry = BazarEntry(
        id: 'bazar_$i',
        memberId: data['memberId'] as String,
        description: data['desc'] as String,
        amount: data['amount'] as double,
        date: now.subtract(Duration(days: i)),
        createdAt: now.subtract(Duration(days: i)),
      );
      IsarService.saveBazarEntry(entry);
    }
    debugPrint('  ✓ Seeded ${_bazarData.length} bazar entries');
  }

  // ============ MONEY TRANSACTIONS ============

  static Future<void> seedTransactions() async {
    final now = DateTime.now();

    final transactions = [
      MoneyTransaction(
        id: 'tx_1',
        fromMemberId: 'member_4', // Tanvir owes
        toMemberId: 'member_1', // Pays Siam (manager)
        amount: 5000.0,
        description: 'Monthly deposit - December',
        date: now.subtract(const Duration(days: 5)),
        status: TransactionStatus.settled,
        isSettled: true,
        settledAt: now.subtract(const Duration(days: 4)),
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      MoneyTransaction(
        id: 'tx_2',
        fromMemberId: 'member_5',
        toMemberId: 'member_1',
        amount: 3000.0,
        description: 'Monthly deposit - December',
        date: now.subtract(const Duration(days: 3)),
        status: TransactionStatus.accepted,
        acceptedAt: now.subtract(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      MoneyTransaction(
        id: 'tx_3',
        fromMemberId: 'member_2',
        toMemberId: 'member_1',
        amount: 2000.0,
        description: 'Partial payment',
        date: now.subtract(const Duration(days: 1)),
        status: TransactionStatus.pending,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];

    for (final tx in transactions) {
      IsarService.saveTransaction(tx);
    }
    debugPrint('  ✓ Seeded ${transactions.length} transactions');
  }

  // ============ SETTINGS / MESS INFO ============

  static Future<void> seedMessInfo() async {
    IsarService.saveSetting('mess_name', 'Area 51 Mess');
    IsarService.saveSetting(
      'mess_address',
      'House 51, Road 7, Dhanmondi, Dhaka',
    );
    IsarService.saveSetting('meal_rate', 70.0);
    IsarService.saveSetting('fixed_monthly_expense', 2500.0);
    IsarService.saveSetting(
      'current_month_start',
      DateTime.now().copyWith(day: 1).toIso8601String(),
    );
    debugPrint('  ✓ Seeded mess info & settings');
  }
}

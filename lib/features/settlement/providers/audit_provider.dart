import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/features/bazar/providers/bazar_provider.dart';
import 'package:mess_manager/features/meals/providers/meals_provider.dart';
import 'package:mess_manager/features/balance/providers/balance_provider.dart';
import 'package:mess_manager/features/money/providers/money_provider.dart';
import 'package:mess_manager/core/providers/members_provider.dart';
import 'package:mess_manager/core/models/money_transaction.dart';

/// Audit issue types
enum AuditIssueType {
  balanceMismatch,
  negativeBalance,
  orphanedEntry,
  duplicateEntry,
  futureDate,
  zeroAmount,
  missingMember,
}

/// Single audit issue
class AuditIssue {
  final AuditIssueType type;
  final String title;
  final String description;
  final String? affectedId;
  final double? amount;
  final DateTime? date;
  final bool isCritical;

  const AuditIssue({
    required this.type,
    required this.title,
    required this.description,
    this.affectedId,
    this.amount,
    this.date,
    this.isCritical = false,
  });
}

/// Complete audit result
class AuditResult {
  final DateTime auditedAt;
  final List<AuditIssue> issues;
  final double totalBazar;
  final double totalMealCost;
  final double totalTransactions;
  final double expectedCashInHand;
  final double actualDiscrepancy;
  final int memberCount;
  final int bazarEntryCount;
  final int mealCount;
  final int transactionCount;

  const AuditResult({
    required this.auditedAt,
    required this.issues,
    required this.totalBazar,
    required this.totalMealCost,
    required this.totalTransactions,
    required this.expectedCashInHand,
    required this.actualDiscrepancy,
    required this.memberCount,
    required this.bazarEntryCount,
    required this.mealCount,
    required this.transactionCount,
  });

  bool get isClean => issues.isEmpty;
  int get criticalCount => issues.where((i) => i.isCritical).length;
  int get warningCount => issues.where((i) => !i.isCritical).length;
}

/// Audit provider performs comprehensive data integrity checks
final auditProvider = Provider<AuditResult>((ref) {
  final bazarEntries = ref.watch(bazarEntriesProvider);
  final meals = ref.watch(mealsProvider);
  final members = ref.watch(membersProvider);
  final summary = ref.watch(balanceSummaryProvider);
  final transactions = ref.watch(moneyTransactionsProvider);
  final balances = ref.watch(memberBalancesProvider);

  final issues = <AuditIssue>[];
  final now = DateTime.now();
  final memberIds = members.map((m) => m.id).toSet();

  // 1. Check for orphaned bazar entries (member doesn't exist)
  for (final entry in bazarEntries) {
    if (!memberIds.contains(entry.memberId)) {
      issues.add(
        AuditIssue(
          type: AuditIssueType.orphanedEntry,
          title: 'Orphaned Bazar Entry',
          description: 'Entry ${entry.id} references non-existent member',
          affectedId: entry.id,
          amount: entry.amount,
          isCritical: true,
        ),
      );
    }

    // Check for future dates
    if (entry.date.isAfter(now)) {
      issues.add(
        AuditIssue(
          type: AuditIssueType.futureDate,
          title: 'Future Date Entry',
          description: 'Bazar entry dated in the future',
          affectedId: entry.id,
          date: entry.date,
        ),
      );
    }

    // Check for zero/negative amounts
    if (entry.amount <= 0) {
      issues.add(
        AuditIssue(
          type: AuditIssueType.zeroAmount,
          title: 'Invalid Amount',
          description: 'Bazar entry has zero or negative amount',
          affectedId: entry.id,
          amount: entry.amount,
          isCritical: true,
        ),
      );
    }
  }

  // 2. Check for orphaned meal entries
  for (final meal in meals) {
    if (!memberIds.contains(meal.memberId)) {
      issues.add(
        AuditIssue(
          type: AuditIssueType.orphanedEntry,
          title: 'Orphaned Meal Entry',
          description: 'Meal ${meal.id} references non-existent member',
          affectedId: meal.id,
          isCritical: true,
        ),
      );
    }

    if (meal.date.isAfter(now)) {
      issues.add(
        AuditIssue(
          type: AuditIssueType.futureDate,
          title: 'Future Date Meal',
          description: 'Meal entry dated in the future',
          affectedId: meal.id,
          date: meal.date,
        ),
      );
    }
  }

  // 3. Check for orphaned/invalid transactions
  for (final tx in transactions) {
    if (!memberIds.contains(tx.fromMemberId)) {
      issues.add(
        AuditIssue(
          type: AuditIssueType.missingMember,
          title: 'Invalid Sender',
          description: 'Transaction references non-existent sender',
          affectedId: tx.id,
          amount: tx.amount,
          isCritical: true,
        ),
      );
    }

    if (!memberIds.contains(tx.toMemberId)) {
      issues.add(
        AuditIssue(
          type: AuditIssueType.missingMember,
          title: 'Invalid Receiver',
          description: 'Transaction references non-existent receiver',
          affectedId: tx.id,
          amount: tx.amount,
          isCritical: true,
        ),
      );
    }

    if (tx.amount <= 0) {
      issues.add(
        AuditIssue(
          type: AuditIssueType.zeroAmount,
          title: 'Invalid Transaction Amount',
          description: 'Transaction has zero or negative amount',
          affectedId: tx.id,
          amount: tx.amount,
          isCritical: true,
        ),
      );
    }
  }

  // 4. Check for extreme negative balances (potential data error)
  for (final balance in balances) {
    if (balance.balance < -10000) {
      // Extreme negative balance > 10k
      issues.add(
        AuditIssue(
          type: AuditIssueType.negativeBalance,
          title: 'Extreme Negative Balance',
          description:
              '${balance.name} has ৳${balance.balance.abs().toStringAsFixed(0)} debt',
          affectedId: balance.memberId,
          amount: balance.balance,
          isCritical: true,
        ),
      );
    }
  }

  // 5. Calculate overall financial integrity
  // Formula: Total Bazar = Sum(Member Meal Costs) + Cash In Hand (Manager)
  final totalMealCost = balances.fold(0.0, (sum, b) => sum + b.mealCost);
  final completedTransactions = transactions
      .where((t) => t.status == TransactionStatus.settled)
      .fold(0.0, (sum, t) => sum + t.amount);

  // Expected: Bazar spent = What members owe (meal cost)
  // Discrepancy = Total Bazar - Total Meal Cost claimed
  final discrepancy = summary.totalBazar - totalMealCost;

  if (discrepancy.abs() > 1) {
    // More than 1 taka discrepancy
    issues.add(
      AuditIssue(
        type: AuditIssueType.balanceMismatch,
        title: 'Balance Discrepancy',
        description:
            'Total Bazar (৳${summary.totalBazar.toStringAsFixed(0)}) != Total Meal Cost (৳${totalMealCost.toStringAsFixed(0)}). Diff: ৳${discrepancy.abs().toStringAsFixed(0)}',
        amount: discrepancy,
        isCritical: discrepancy.abs() > 100,
      ),
    );
  }

  return AuditResult(
    auditedAt: now,
    issues: issues,
    totalBazar: summary.totalBazar,
    totalMealCost: totalMealCost,
    totalTransactions: completedTransactions,
    expectedCashInHand: summary.totalBazar - completedTransactions,
    actualDiscrepancy: discrepancy,
    memberCount: members.length,
    bazarEntryCount: bazarEntries.length,
    mealCount: meals.length,
    transactionCount: transactions.length,
  );
});

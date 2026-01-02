import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/providers/members_provider.dart';

/// Sample fixed expenses
final _sampleExpenses = <FixedExpense>[
  FixedExpense(
    id: 'fix1',
    type: FixedExpenseType.rent,
    amount: 12000,
    dueDate: DateTime(2026, 1, 5),
    month: 1,
    year: 2026,
    description: 'জানুয়ারি ভাড়া',
  ),
  FixedExpense(
    id: 'fix2',
    type: FixedExpenseType.wifi,
    amount: 800,
    dueDate: DateTime(2026, 1, 10),
    month: 1,
    year: 2026,
    description: 'ইন্টারনেট বিল',
  ),
  FixedExpense(
    id: 'fix3',
    type: FixedExpenseType.bua,
    amount: 3000,
    dueDate: DateTime(2026, 1, 1),
    month: 1,
    year: 2026,
    description: 'বুয়ার বেতন',
  ),
];

/// Fixed expenses notifier
class FixedExpensesNotifier extends Notifier<List<FixedExpense>> {
  @override
  List<FixedExpense> build() => List.from(_sampleExpenses);

  void addExpense(FixedExpense expense) {
    state = [...state, expense];
  }

  void updateExpense(FixedExpense expense) {
    state = [
      for (final e in state)
        if (e.id == expense.id) expense else e,
    ];
  }

  void markPaid(String id, String memberId) {
    state = [
      for (final e in state)
        if (e.id == id)
          e.copyWith(
            isPaid: true,
            paidAt: DateTime.now(),
            paidByMemberId: memberId,
          )
        else
          e,
    ];
  }

  void removeExpense(String id) {
    state = state.where((e) => e.id != id).toList();
  }
}

final fixedExpensesProvider =
    NotifierProvider<FixedExpensesNotifier, List<FixedExpense>>(() {
      return FixedExpensesNotifier();
    });

/// Current month's expenses
final currentMonthExpensesProvider = Provider<List<FixedExpense>>((ref) {
  final expenses = ref.watch(fixedExpensesProvider);
  final now = DateTime.now();
  return expenses
      .where((e) => e.month == now.month && e.year == now.year)
      .toList();
});

/// Unpaid expenses this month
final unpaidExpensesProvider = Provider<List<FixedExpense>>((ref) {
  final expenses = ref.watch(currentMonthExpensesProvider);
  return expenses.where((e) => !e.isPaid).toList();
});

/// Total fixed expenses per member this month
final fixedExpensePerMemberProvider = Provider<double>((ref) {
  final expenses = ref.watch(currentMonthExpensesProvider);
  final members = ref.watch(membersProvider);

  if (members.isEmpty) return 0;

  final totalFixed = expenses.fold(0.0, (sum, e) => sum + e.amount);
  return totalFixed / members.length;
});

/// Expense type display info
String getExpenseTypeName(FixedExpenseType type) {
  switch (type) {
    case FixedExpenseType.rent:
      return 'বাড়ি ভাড়া';
    case FixedExpenseType.wifi:
      return 'ওয়াইফাই';
    case FixedExpenseType.bua:
      return 'বুয়া';
    case FixedExpenseType.electricity:
      return 'বিদ্যুৎ';
    case FixedExpenseType.gas:
      return 'গ্যাস';
    case FixedExpenseType.water:
      return 'পানি';
    case FixedExpenseType.emergency:
      return 'জরুরি';
    case FixedExpenseType.other:
      return 'অন্যান্য';
  }
}

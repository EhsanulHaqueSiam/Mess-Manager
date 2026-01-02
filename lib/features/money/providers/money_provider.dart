import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/money_transaction.dart';
import 'package:mess_manager/core/providers/members_provider.dart';

/// Sample transactions
final _sampleTransactions = <MoneyTransaction>[
  MoneyTransaction(
    id: 't1',
    fromMemberId: 'm1', // Siam
    toMemberId: 'm2', // Tanmoy
    amount: 500,
    description: 'Lunch reimbursement',
    date: DateTime.now().subtract(const Duration(days: 2)),
    isSettled: true,
    settledAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  MoneyTransaction(
    id: 't2',
    fromMemberId: 'm3', // Sarkar
    toMemberId: 'm1', // Siam
    amount: 200,
    description: 'Movie tickets',
    date: DateTime.now().subtract(const Duration(days: 5)),
    isSettled: false,
  ),
];

/// Money transactions notifier
class MoneyTransactionsNotifier extends Notifier<List<MoneyTransaction>> {
  @override
  List<MoneyTransaction> build() => List.from(_sampleTransactions);

  void addTransaction(MoneyTransaction transaction) {
    state = [...state, transaction];
  }

  void settleTransaction(String id) {
    state = state.map((t) {
      if (t.id == id) {
        return t.copyWith(isSettled: true, settledAt: DateTime.now());
      }
      return t;
    }).toList();
  }

  void deleteTransaction(String id) {
    state = state.where((t) => t.id != id).toList();
  }
}

final moneyTransactionsProvider =
    NotifierProvider<MoneyTransactionsNotifier, List<MoneyTransaction>>(() {
      return MoneyTransactionsNotifier();
    });

/// Pending transactions (not yet settled)
final pendingTransactionsProvider = Provider<List<MoneyTransaction>>((ref) {
  final transactions = ref.watch(moneyTransactionsProvider);
  return transactions.where((t) => !t.isSettled).toList()
    ..sort((a, b) => b.date.compareTo(a.date));
});

/// Settled transactions
final settledTransactionsProvider = Provider<List<MoneyTransaction>>((ref) {
  final transactions = ref.watch(moneyTransactionsProvider);
  return transactions.where((t) => t.isSettled).toList()
    ..sort((a, b) => (b.settledAt ?? b.date).compareTo(a.settledAt ?? a.date));
});

/// Personal balance per member (what they owe/are owed)
class PersonalBalance {
  final String memberId;
  final String memberName;
  final double amountOwed; // What they owe to others
  final double amountOwedTo; // What others owe to them
  final double netBalance; // Positive = others owe them

  PersonalBalance({
    required this.memberId,
    required this.memberName,
    required this.amountOwed,
    required this.amountOwedTo,
    required this.netBalance,
  });
}

final personalBalancesProvider = Provider<List<PersonalBalance>>((ref) {
  final transactions = ref.watch(pendingTransactionsProvider);
  final members = ref.watch(membersProvider);

  return members.map((member) {
    double owed = 0;
    double owedTo = 0;

    for (final t in transactions) {
      if (t.fromMemberId == member.id) {
        // This member gave money -> others owe them
        owedTo += t.amount;
      }
      if (t.toMemberId == member.id) {
        // This member received money -> they owe others
        owed += t.amount;
      }
    }

    return PersonalBalance(
      memberId: member.id,
      memberName: member.name,
      amountOwed: owed,
      amountOwedTo: owedTo,
      netBalance: owedTo - owed,
    );
  }).toList();
});

/// Current member's personal balance
final currentPersonalBalanceProvider = Provider<PersonalBalance?>((ref) {
  final currentId = ref.watch(currentMemberIdProvider);
  final balances = ref.watch(personalBalancesProvider);

  try {
    return balances.firstWhere((b) => b.memberId == currentId);
  } catch (_) {
    return null;
  }
});

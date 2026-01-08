import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/money_transaction.dart';
import 'package:mess_manager/core/providers/members_provider.dart';

/// Sample transactions with new status field
final _sampleTransactions = <MoneyTransaction>[
  MoneyTransaction(
    id: 't1',
    fromMemberId: 'm1', // Siam
    toMemberId: 'm2', // Tanmoy
    amount: 500,
    description: 'Lunch reimbursement',
    date: DateTime.now().subtract(const Duration(days: 2)),
    status: TransactionStatus.settled,
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
    status: TransactionStatus.pending,
    isSettled: false,
  ),
  // Example of high-value pending transaction (requires photo)
  MoneyTransaction(
    id: 't3',
    fromMemberId: 'm2', // Tanmoy
    toMemberId: 'm4', // Shahriyer
    amount: 1500,
    description: 'Rent advance',
    date: DateTime.now().subtract(const Duration(days: 1)),
    status: TransactionStatus.pending,
    isSettled: false,
  ),
];

/// Result of a transaction operation
enum TransactionResult {
  success,
  unauthorized,
  alreadyProcessed,
  requiresPhotoProof,
  notAccepted,
  notFound,
}

/// Money transactions notifier with full request/confirmation flow
class MoneyTransactionsNotifier extends Notifier<List<MoneyTransaction>> {
  @override
  List<MoneyTransaction> build() => List.from(_sampleTransactions);

  /// Add a new transaction request
  /// For amounts >500, photoProofUrl is required
  TransactionResult addTransaction(MoneyTransaction transaction) {
    // Validate photo proof for large amounts
    if (transaction.requiresPhotoProof && !transaction.hasPhotoProof) {
      return TransactionResult.requiresPhotoProof;
    }

    // Ensure status is pending for new transactions
    final newTransaction = transaction.copyWith(
      status: TransactionStatus.pending,
      isSettled: false,
      createdAt: DateTime.now(),
    );

    state = [...state, newTransaction];
    return TransactionResult.success;
  }

  /// Accept a pending transaction - ONLY the receiver (toMemberId) can accept
  TransactionResult acceptTransaction(
    String id,
    String currentMemberId, {
    String? note,
  }) {
    final index = state.indexWhere((t) => t.id == id);
    if (index == -1) return TransactionResult.notFound;

    final transaction = state[index];

    // Security check: Only the receiver can accept
    if (transaction.toMemberId != currentMemberId) {
      return TransactionResult.unauthorized;
    }

    // Check if already processed
    if (transaction.status != TransactionStatus.pending) {
      return TransactionResult.alreadyProcessed;
    }

    state = [
      ...state.sublist(0, index),
      transaction.copyWith(
        status: TransactionStatus.accepted,
        acceptedAt: DateTime.now(),
        responseNote: note,
      ),
      ...state.sublist(index + 1),
    ];
    return TransactionResult.success;
  }

  /// Reject a pending transaction - ONLY the receiver (toMemberId) can reject
  TransactionResult rejectTransaction(
    String id,
    String currentMemberId, {
    String? reason,
  }) {
    final index = state.indexWhere((t) => t.id == id);
    if (index == -1) return TransactionResult.notFound;

    final transaction = state[index];

    // Security check: Only the receiver can reject
    if (transaction.toMemberId != currentMemberId) {
      return TransactionResult.unauthorized;
    }

    // Check if already processed
    if (transaction.status != TransactionStatus.pending) {
      return TransactionResult.alreadyProcessed;
    }

    state = [
      ...state.sublist(0, index),
      transaction.copyWith(
        status: TransactionStatus.rejected,
        rejectedAt: DateTime.now(),
        responseNote: reason,
      ),
      ...state.sublist(index + 1),
    ];
    return TransactionResult.success;
  }

  /// Settle an accepted transaction - ONLY the sender (fromMemberId) can mark as settled
  TransactionResult settleTransaction(String id, String currentMemberId) {
    final index = state.indexWhere((t) => t.id == id);
    if (index == -1) return TransactionResult.notFound;

    final transaction = state[index];

    // Security check: Only the sender can mark as settled (they're the one paying)
    if (transaction.fromMemberId != currentMemberId) {
      return TransactionResult.unauthorized;
    }

    // Must be accepted before settling
    if (transaction.status != TransactionStatus.accepted) {
      return TransactionResult.notAccepted;
    }

    state = [
      ...state.sublist(0, index),
      transaction.copyWith(
        status: TransactionStatus.settled,
        isSettled: true,
        settledAt: DateTime.now(),
      ),
      ...state.sublist(index + 1),
    ];
    return TransactionResult.success;
  }

  /// Add photo proof to a transaction
  TransactionResult addPhotoProof(
    String id,
    String photoUrl,
    String currentMemberId,
  ) {
    final index = state.indexWhere((t) => t.id == id);
    if (index == -1) return TransactionResult.notFound;

    final transaction = state[index];

    // Security check: Only the sender can add photo proof
    if (transaction.fromMemberId != currentMemberId) {
      return TransactionResult.unauthorized;
    }

    state = [
      ...state.sublist(0, index),
      transaction.copyWith(photoProofUrl: photoUrl),
      ...state.sublist(index + 1),
    ];
    return TransactionResult.success;
  }

  void deleteTransaction(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  /// Update an existing transaction (admin correction)
  TransactionResult updateTransaction(MoneyTransaction updatedTransaction) {
    final index = state.indexWhere((t) => t.id == updatedTransaction.id);
    if (index == -1) return TransactionResult.notFound;

    // Validate photo proof for large amounts
    if (updatedTransaction.requiresPhotoProof &&
        !updatedTransaction.hasPhotoProof) {
      return TransactionResult.requiresPhotoProof;
    }

    state = [
      ...state.sublist(0, index),
      updatedTransaction,
      ...state.sublist(index + 1),
    ];
    return TransactionResult.success;
  }
}

final moneyTransactionsProvider =
    NotifierProvider<MoneyTransactionsNotifier, List<MoneyTransaction>>(() {
      return MoneyTransactionsNotifier();
    });

/// Pending transactions (awaiting receiver response)
final pendingTransactionsProvider = Provider<List<MoneyTransaction>>((ref) {
  final transactions = ref.watch(moneyTransactionsProvider);
  return transactions
      .where((t) => t.status == TransactionStatus.pending)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));
});

/// Accepted transactions (awaiting settlement)
final acceptedTransactionsProvider = Provider<List<MoneyTransaction>>((ref) {
  final transactions = ref.watch(moneyTransactionsProvider);
  return transactions
      .where((t) => t.status == TransactionStatus.accepted)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));
});

/// Rejected transactions
final rejectedTransactionsProvider = Provider<List<MoneyTransaction>>((ref) {
  final transactions = ref.watch(moneyTransactionsProvider);
  return transactions
      .where((t) => t.status == TransactionStatus.rejected)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));
});

/// Settled transactions
final settledTransactionsProvider = Provider<List<MoneyTransaction>>((ref) {
  final transactions = ref.watch(moneyTransactionsProvider);
  return transactions
      .where((t) => t.status == TransactionStatus.settled)
      .toList()
    ..sort((a, b) => (b.settledAt ?? b.date).compareTo(a.settledAt ?? a.date));
});

/// Transactions requiring photo proof (>500 BDT without photo)
final missingPhotoProofProvider = Provider<List<MoneyTransaction>>((ref) {
  final transactions = ref.watch(moneyTransactionsProvider);
  return transactions
      .where((t) => t.requiresPhotoProof && !t.hasPhotoProof)
      .toList();
});

/// Personal balance per member (what they owe/are owed)
class PersonalBalance {
  final String memberId;
  final String memberName;
  final double amountOwed; // What they owe to others
  final double amountOwedTo; // What others owe to them
  final double netBalance; // Positive = others owe them
  final int pendingRequests; // Pending transactions they need to respond to

  PersonalBalance({
    required this.memberId,
    required this.memberName,
    required this.amountOwed,
    required this.amountOwedTo,
    required this.netBalance,
    this.pendingRequests = 0,
  });
}

final personalBalancesProvider = Provider<List<PersonalBalance>>((ref) {
  final allTransactions = ref.watch(moneyTransactionsProvider);
  final members = ref.watch(membersProvider);

  return members.map((member) {
    double owed = 0;
    double owedTo = 0;
    int pendingRequests = 0;

    for (final t in allTransactions) {
      // Only count accepted/pending transactions (not rejected or settled)
      if (t.status == TransactionStatus.rejected ||
          t.status == TransactionStatus.settled) {
        continue;
      }

      if (t.fromMemberId == member.id) {
        // This member gave money -> others owe them
        owedTo += t.amount;
      }
      if (t.toMemberId == member.id) {
        // This member received money -> they owe others
        owed += t.amount;

        // Count pending requests they need to respond to
        if (t.status == TransactionStatus.pending) {
          pendingRequests++;
        }
      }
    }

    return PersonalBalance(
      memberId: member.id,
      memberName: member.name,
      amountOwed: owed,
      amountOwedTo: owedTo,
      netBalance: owedTo - owed,
      pendingRequests: pendingRequests,
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

/// Transactions that need current user's attention (pending requests TO them)
final actionRequiredTransactionsProvider = Provider<List<MoneyTransaction>>((
  ref,
) {
  final currentId = ref.watch(currentMemberIdProvider);
  final pending = ref.watch(pendingTransactionsProvider);

  return pending.where((t) => t.toMemberId == currentId).toList();
});

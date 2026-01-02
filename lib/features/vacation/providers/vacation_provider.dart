import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/models/meal.dart';
import 'package:mess_manager/core/providers/members_provider.dart';

/// Sample vacation periods
final _sampleVacations = <VacationPeriod>[
  VacationPeriod(
    id: 'vac1',
    memberId: '2', // Tanmoy
    startDate: DateTime(2026, 1, 5),
    endDate: DateTime(2026, 1, 10),
    lastMealBefore: MealType.lunch,
    firstMealAfter: MealType.dinner,
    reason: 'বাড়ি যাচ্ছি',
    isActive: true,
  ),
];

/// Vacation periods notifier
class VacationNotifier extends Notifier<List<VacationPeriod>> {
  @override
  List<VacationPeriod> build() => List.from(_sampleVacations);

  void addVacation(VacationPeriod vacation) {
    state = [...state, vacation];
  }

  void updateVacation(VacationPeriod vacation) {
    state = [
      for (final v in state)
        if (v.id == vacation.id) vacation else v,
    ];
  }

  void removeVacation(String id) {
    state = state.where((v) => v.id != id).toList();
  }

  void toggleActive(String id) {
    state = [
      for (final v in state)
        if (v.id == id) v.copyWith(isActive: !v.isActive) else v,
    ];
  }
}

final vacationsProvider =
    NotifierProvider<VacationNotifier, List<VacationPeriod>>(() {
      return VacationNotifier();
    });

/// Check if a member is on vacation for a specific meal
final isOnVacationProvider =
    Provider.family<bool, ({String memberId, DateTime date, MealType type})>((
      ref,
      params,
    ) {
      final vacations = ref.watch(vacationsProvider);

      for (final vac in vacations) {
        if (!vac.isActive || vac.memberId != params.memberId) continue;

        final startDate = DateTime(
          vac.startDate.year,
          vac.startDate.month,
          vac.startDate.day,
        );
        final endDate = DateTime(
          vac.endDate.year,
          vac.endDate.month,
          vac.endDate.day,
        );
        final checkDate = DateTime(
          params.date.year,
          params.date.month,
          params.date.day,
        );

        // Check if date is within vacation range
        if (checkDate.isAfter(startDate) && checkDate.isBefore(endDate)) {
          return true; // Fully within vacation
        }

        // Check start date - only meals after lastMealBefore are vacation
        if (checkDate == startDate) {
          final mealOrder = {
            MealType.breakfast: 0,
            MealType.lunch: 1,
            MealType.dinner: 2,
          };
          if (mealOrder[params.type]! > mealOrder[vac.lastMealBefore]!) {
            return true;
          }
        }

        // Check end date - only meals before firstMealAfter are vacation
        if (checkDate == endDate) {
          final mealOrder = {
            MealType.breakfast: 0,
            MealType.lunch: 1,
            MealType.dinner: 2,
          };
          if (mealOrder[params.type]! < mealOrder[vac.firstMealAfter]!) {
            return true;
          }
        }
      }

      return false;
    });

/// Active vacations for current member
final currentMemberVacationsProvider = Provider<List<VacationPeriod>>((ref) {
  final currentId = ref.watch(currentMemberIdProvider);
  final vacations = ref.watch(vacationsProvider);
  return vacations.where((v) => v.memberId == currentId).toList();
});

/// Members currently on vacation
final membersOnVacationProvider = Provider<List<String>>((ref) {
  final vacations = ref.watch(vacationsProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return vacations
      .where((v) => v.isActive)
      .where((v) {
        final start = DateTime(
          v.startDate.year,
          v.startDate.month,
          v.startDate.day,
        );
        final end = DateTime(v.endDate.year, v.endDate.month, v.endDate.day);
        return !today.isBefore(start) && !today.isAfter(end);
      })
      .map((v) => v.memberId)
      .toList();
});

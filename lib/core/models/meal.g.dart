// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Meal _$MealFromJson(Map<String, dynamic> json) => _Meal(
  id: json['id'] as String,
  memberId: json['memberId'] as String,
  date: DateTime.parse(json['date'] as String),
  count: (json['count'] as num?)?.toInt() ?? 1,
  type: $enumDecodeNullable(_$MealTypeEnumMap, json['type']) ?? MealType.lunch,
  status:
      $enumDecodeNullable(_$MealStatusEnumMap, json['status']) ??
      MealStatus.confirmed,
  isFromSchedule: json['isFromSchedule'] as bool? ?? false,
  guestCount: (json['guestCount'] as num?)?.toInt() ?? 0,
  guestName: json['guestName'] as String?,
  sharedWithMemberIds:
      (json['sharedWithMemberIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  note: json['note'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$MealToJson(_Meal instance) => <String, dynamic>{
  'id': instance.id,
  'memberId': instance.memberId,
  'date': instance.date.toIso8601String(),
  'count': instance.count,
  'type': _$MealTypeEnumMap[instance.type]!,
  'status': _$MealStatusEnumMap[instance.status]!,
  'isFromSchedule': instance.isFromSchedule,
  'guestCount': instance.guestCount,
  'guestName': instance.guestName,
  'sharedWithMemberIds': instance.sharedWithMemberIds,
  'note': instance.note,
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$MealTypeEnumMap = {
  MealType.breakfast: 'breakfast',
  MealType.lunch: 'lunch',
  MealType.dinner: 'dinner',
};

const _$MealStatusEnumMap = {
  MealStatus.scheduled: 'scheduled',
  MealStatus.confirmed: 'confirmed',
  MealStatus.cancelled: 'cancelled',
};

_DailyMealSummary _$DailyMealSummaryFromJson(Map<String, dynamic> json) =>
    _DailyMealSummary(
      date: DateTime.parse(json['date'] as String),
      memberMeals: Map<String, int>.from(json['memberMeals'] as Map),
      totalMeals: (json['totalMeals'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DailyMealSummaryToJson(_DailyMealSummary instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'memberMeals': instance.memberMeals,
      'totalMeals': instance.totalMeals,
    };

_VacationPeriod _$VacationPeriodFromJson(Map<String, dynamic> json) =>
    _VacationPeriod(
      id: json['id'] as String,
      memberId: json['memberId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      lastMealBefore:
          $enumDecodeNullable(_$MealTypeEnumMap, json['lastMealBefore']) ??
          MealType.dinner,
      firstMealAfter:
          $enumDecodeNullable(_$MealTypeEnumMap, json['firstMealAfter']) ??
          MealType.lunch,
      reason: json['reason'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$VacationPeriodToJson(_VacationPeriod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberId': instance.memberId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'lastMealBefore': _$MealTypeEnumMap[instance.lastMealBefore]!,
      'firstMealAfter': _$MealTypeEnumMap[instance.firstMealAfter]!,
      'reason': instance.reason,
      'isActive': instance.isActive,
    };

_FixedExpense _$FixedExpenseFromJson(Map<String, dynamic> json) =>
    _FixedExpense(
      id: json['id'] as String,
      type: $enumDecode(_$FixedExpenseTypeEnumMap, json['type']),
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      month: (json['month'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      description: json['description'] as String?,
      isPaid: json['isPaid'] as bool? ?? false,
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      paidByMemberId: json['paidByMemberId'] as String?,
      splitMemberIds:
          (json['splitMemberIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$FixedExpenseToJson(_FixedExpense instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$FixedExpenseTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'dueDate': instance.dueDate.toIso8601String(),
      'month': instance.month,
      'year': instance.year,
      'description': instance.description,
      'isPaid': instance.isPaid,
      'paidAt': instance.paidAt?.toIso8601String(),
      'paidByMemberId': instance.paidByMemberId,
      'splitMemberIds': instance.splitMemberIds,
    };

const _$FixedExpenseTypeEnumMap = {
  FixedExpenseType.rent: 'rent',
  FixedExpenseType.wifi: 'wifi',
  FixedExpenseType.bua: 'bua',
  FixedExpenseType.electricity: 'electricity',
  FixedExpenseType.gas: 'gas',
  FixedExpenseType.water: 'water',
  FixedExpenseType.emergency: 'emergency',
  FixedExpenseType.other: 'other',
};

_FixedExpensePayment _$FixedExpensePaymentFromJson(Map<String, dynamic> json) =>
    _FixedExpensePayment(
      id: json['id'] as String,
      expenseId: json['expenseId'] as String,
      memberId: json['memberId'] as String,
      shareAmount: (json['shareAmount'] as num).toDouble(),
      isPaid: json['isPaid'] as bool? ?? false,
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
    );

Map<String, dynamic> _$FixedExpensePaymentToJson(
  _FixedExpensePayment instance,
) => <String, dynamic>{
  'id': instance.id,
  'expenseId': instance.expenseId,
  'memberId': instance.memberId,
  'shareAmount': instance.shareAmount,
  'isPaid': instance.isPaid,
  'paidAt': instance.paidAt?.toIso8601String(),
};

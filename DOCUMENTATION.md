# Area51 Documentation

> Comprehensive documentation for the Area51 Bachelor Mess Manager

## Table of Contents

1. [Architecture](#architecture)
2. [Data Models](#data-models)
3. [Features & Logic](#features--logic)
4. [Edge Cases](#edge-cases)
5. [Future Plans](#future-plans)

---

## Architecture

### State Management: Riverpod 3.x

Using the modern **Notifier pattern**:

```dart
class MembersNotifier extends Notifier<List<Member>> {
  @override
  List<Member> build() => initialMembers;
  
  void addMember(Member m) => state = [...state, m];
}

final membersProvider = NotifierProvider<MembersNotifier, List<Member>>(() {
  return MembersNotifier();
});
```

### Data Layer: Freezed 3.x

All models use `@freezed sealed class` for immutability:

```dart
@freezed
sealed class Member with _$Member {
  const factory Member({
    required String id,
    required String name,
    @Default(MemberRole.member) MemberRole role,
    @Default([]) List<FoodPreference> preferences,
  }) = _Member;
}
```

---

## Data Models

### Member
| Field | Type | Description |
|-------|------|-------------|
| id | String | Unique identifier |
| name | String | Display name |
| role | MemberRole | superAdmin, admin, member, temp |
| preferences | List<FoodPreference> | Food restrictions/allergies |
| balance | double | Current balance (calculated) |

### Meal
| Field | Type | Description |
|-------|------|-------------|
| id | String | Unique identifier |
| memberId | String | Who had the meal |
| type | MealType | breakfast, lunch, dinner |
| count | int | Whole number portions (1, 2, 3...) |
| status | MealStatus | scheduled, confirmed, cancelled |
| isFromSchedule | bool | Auto-added from weekly schedule |
| date | DateTime | Date of meal (can be future) |

### VacationPeriod
| Field | Type | Description |
|-------|------|-------------|
| id | String | Unique identifier |
| memberId | String | Member on vacation |
| startDate | DateTime | Vacation start |
| endDate | DateTime | Vacation end |
| reason | String? | Optional reason |

### BazarEntry
| Field | Type | Description |
|-------|------|-------------|
| id | String | Unique identifier |
| memberId | String | Who did the bazar |
| amount | double | Total cost |
| items | List<BazarItem> | Itemized purchases |
| isItemized | bool | Simple vs itemized mode |

### MoneyTransaction
| Field | Type | Description |
|-------|------|-------------|
| fromMemberId | String | Who gave money |
| toMemberId | String | Who received |
| amount | double | Amount transferred |
| isSettled | bool | Transaction status |

---

## Features & Logic

### 1. Balance Calculation

**Formula:**
```
Meal Rate = Total Bazar ÷ Total Meals
Meal Cost = Member's Meals × Meal Rate
Balance   = Bazar Contribution - Meal Cost
```

**Result Interpretation:**
- **Positive Balance**: Member contributed more than consumed → will receive money
- **Negative Balance**: Member consumed more than contributed → owes money

### 2. Meal Schedule (Weekly Default)

Each member can set default meal patterns per day:

```dart
class DefaultMealSchedule {
  final String memberId;
  final Map<int, MealPattern> dayPatterns; // 1=Mon to 7=Sun
}

class MealPattern {
  final bool breakfast;
  final bool lunch;
  final bool dinner;
}
```

**Use Case**: Pre-fill expected meals, compare actual vs expected.

### 3. Smart Suggestions

Contextual reminders on dashboard:

| Trigger | Suggestion |
|---------|------------|
| 3+ days since bazar | "Time for groceries?" |
| No meals logged today (after noon) | "Remember to add meals" |
| Friday/Saturday + 2+ days since bazar | "Weekend shopping?" |

### 4. Shopping List

Collaborative grocery list:
- Anyone can add items
- Members claim "I'll buy this"
- Auto-mark as purchased
- One-tap clear purchased items

### 5. Money Give/Take

Track personal loans separate from mess expenses:
- From → To transactions
- Settle when repaid
- Personal balance view

---

## Edge Cases

### Balance Calculation Edge Cases

| Scenario | Solution | Rationale |
|----------|----------|-----------|
| **No meals, no bazar** | All balances = 0 | No activity |
| **Bazar but no meals** (divide by 0) | Split bazar equally | Fair when can't calculate per-meal |
| **Member did bazar but didn't eat** | Positive balance | They contributed without consuming |
| **Member ate but did no bazar** | Negative balance | They consumed without contributing |
| **Floating point precision** | Round to 2 decimals | Avoid 0.000001 discrepancies |
| **Sum of balances ≠ 0** | Validation check | Should always sum to 0 |

```dart
// Equal split when no meals
if (totalMeals <= 0 && totalBazar > 0) {
  final equalShare = totalBazar / members.length;
  // Each member owes equalShare, minus what they contributed
  final balance = memberBazar - equalShare;
}
```

### Meal Count Edge Cases

| Input | Handling |
|-------|----------|
| count < 0.5 | Clamp to 0.5 |
| count > 2.0 | Clamp to 2.0 |
| Adding for future date | Allow (for scheduling) |
| Editing past entries | Allow (for corrections) |

### Member Edge Cases

| Scenario | Handling |
|----------|----------|
| No members | Empty list, no calculations |
| Member removed mid-month | Keep historical data, exclude from new |
| Duplicate member name | Allow (use unique ID) |

---

## Future Plans

### Phase 1: Data Persistence (Next)
- [ ] **SharedPreferences** for simple settings
- [ ] **Hive/Isar** for local data storage
- [ ] Auto-save on every change
- [ ] Offline-first architecture

### Phase 2: Firebase Integration
- [ ] Firebase Auth (Google, Phone)
- [ ] Cloud Firestore for data sync
- [ ] Multi-device sync
- [ ] Real-time updates across users

### Phase 3: Ramadan Special Mode
- [ ] Iftar/Suhoor tracking instead of regular meals
- [ ] Fasting day markers
- [ ] Special monthly reports
- [ ] Date-based activation

### Phase 4: Advanced Features
- [ ] Voice input for quick entries
- [ ] OCR receipt scanning
- [ ] Price trend analytics
- [ ] Budget goals & alerts
- [ ] Export to PDF/Excel
- [ ] Push notifications

### Phase 5: Multi-Mess Support
- [ ] Create/join multiple messes
- [ ] Mess invitation codes
- [ ] Cross-mess member transfer
- [ ] Admin dashboard

---

## Code Patterns

### Provider Best Practices

```dart
// ✅ Computed provider depending on others
final totalMealsProvider = Provider<double>((ref) {
  final meals = ref.watch(mealsProvider);
  return meals.fold(0.0, (sum, m) => sum + m.count);
});

// ✅ Notifier for mutable state
class MealsNotifier extends Notifier<List<Meal>> {
  @override
  List<Meal> build() => [];
  
  void add(Meal meal) => state = [...state, meal];
  void remove(String id) => state = state.where((m) => m.id != id).toList();
}
```

### Model Best Practices

```dart
// ✅ Freezed with defaults and optional fields
@freezed
sealed class BazarEntry with _$BazarEntry {
  const factory BazarEntry({
    required String id,
    required double amount,
    @Default([]) List<BazarItem> items,
    @Default(false) bool isItemized,
    String? description,
    DateTime? createdAt,
  }) = _BazarEntry;
}
```

---

## Testing Notes

### Balance Validation
```dart
// All balances should sum to approximately 0
final sum = balances.fold(0.0, (s, b) => s + b.balance);
assert(sum.abs() < 0.01, 'Balances do not sum to zero!');
```

### Provider Testing
```dart
final container = ProviderContainer();
final meals = container.read(mealsProvider);
expect(meals, isEmpty);

container.read(mealsProvider.notifier).add(testMeal);
expect(container.read(mealsProvider).length, 1);
```

---

*Last updated: January 3, 2026*

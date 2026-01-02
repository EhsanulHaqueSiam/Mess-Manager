# Mess Manager 🏠
### Smart Mess Management for Shared Living

> Smart expense & meal tracking for bachelor messes | Flutter

[![Flutter](https://img.shields.io/badge/Flutter-3.35+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📱 Screenshots

| Dashboard | Meal Planner |
|:---:|:---:|
| <img src="assets/screenshots/dashboard.png" width="250" alt="Dashboard" /> | <img src="assets/screenshots/meals.png" width="250" alt="Meal Planner" /> |

| Expenses | Settlement |
|:---:|:---:|
| <img src="assets/screenshots/expenses.png" width="250" alt="Expense Tracking" /> | <img src="assets/screenshots/settlement.png" width="250" alt="Settlement Reports" /> |

> **Note:** Screenshots are illustrative. Add your own to `assets/screenshots/`.

## Features

### 🍽️ Meals
- Add meals with 0.5x - 2x portions
- Weekly schedule with default patterns
- Per-member meal tracking

### 🛒 Bazar (Groceries)
- Simple or itemized entries
- Shared shopping list with claim/purchase
- Auto expense tracking

### 💰 Balance
- Fair cost distribution with edge case handling
- Meal rate = Total Bazar ÷ Total Meals
- Per-member breakdown

### 💸 Money Give/Take
- Track personal loans between members
- Settle transactions
- Personal balance view

### 📊 Analytics
- Weekly trend charts
- Daily averages
- Month summary

### 👥 Members
- Roles: Super Admin, Admin, Member, Temp
- Food preferences (allergies, restrictions)
- Balance overview

## Tech Stack

```yaml
Framework:    Flutter 3.35+
State:        Riverpod 3.x (Notifier pattern)
Routing:      go_router 15.x
Models:       Freezed 3.x + json_serializable
UI:           FlexColorScheme, Lucide Icons, Gap
```

## Quick Start

```bash
# Clone
git clone <repo-url>
cd area51_app

# Install
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Run
flutter run -d linux  # or chrome, edge, etc.
```

## Project Structure

```
lib/
├── core/
│   ├── models/          # Freezed data models
│   ├── providers/       # Global providers
│   ├── router/          # go_router config
│   └── theme/           # App theming
├── features/
│   ├── dashboard/       # Home screen
│   ├── meals/           # Meal tracking + schedule
│   ├── bazar/           # Grocery tracking
│   ├── balance/         # Balance calculations
│   ├── money/           # Give/take transactions
│   ├── members/         # Member management
│   ├── analytics/       # Charts & stats
│   └── settings/        # App settings
└── shared/
    └── widgets/         # Reusable components
```

## Routes

| Path | Screen |
|------|--------|
| `/` | Dashboard |
| `/meals` | Meals |
| `/bazar` | Bazar |
| `/balance` | Balance |
| `/analytics` | Analytics |
| `/money` | Money Give/Take |
| `/members` | Members |
| `/settings` | Settings |

## Building

```bash
# Web
flutter build web --release

# Linux
flutter build linux --release

# Serve web locally
flutter build web --release && (cd build/web && python3 -m http.server 8080)
```

## Documentation

See [DOCUMENTATION.md](DOCUMENTATION.md) for detailed feature documentation, edge cases, and architecture.

## License

MIT License - See [LICENSE](LICENSE)

---

Built with ❤️ for Area51 Mess

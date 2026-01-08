# Mess Manager 🏠
### Smart Mess Management for Shared Living

> Smart expense & meal tracking for bachelor messes | Flutter

[![Flutter](https://img.shields.io/badge/Flutter-3.35+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8+-0175C2?logo=dart)](https://dart.dev)
[![CI/CD](https://github.com/YOUR_USERNAME/area51_app/actions/workflows/build.yml/badge.svg)](https://github.com/YOUR_USERNAME/area51_app/actions)
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

## Web Testing

### Development Mode (Recommended)
```bash
# Run in debug mode with hot reload
flutter run -d chrome

# Or with a specific port
flutter run -d chrome --web-port=8080
```

### Production Build
```bash
# Build for web
flutter build web --release

# Option 1: Quick local server (may have SharedArrayBuffer issues)
cd build/web && python3 -m http.server 8080

# Option 2: With proper COOP/COEP headers (Recommended for CanvasKit)
python3 serve_web.py
# Then open http://localhost:8000
```

### Troubleshooting Web Issues

| Issue | Solution |
|-------|----------|
| White screen on release | Use `serve_web.py` for proper COOP/COEP headers |
| SharedArrayBuffer error | Same as above - headers required for CanvasKit |
| Cache issues | Hard reload with Ctrl+Shift+R or clear Service Worker |
| Firebase errors | Ensure web/index.html has Firebase config |

### serve_web.py
The project includes a custom server script that sets required headers:
```python
# Located at: area51_app/serve_web.py
# Adds Cross-Origin-Opener-Policy and Cross-Origin-Embedder-Policy headers
# Required for CanvasKit SharedArrayBuffer support
```

## Building

```bash
# Web
flutter build web --release

# Linux
flutter build linux --release

# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# Release with Obfuscation (Recommended for production)
flutter build apk --release --obfuscate --split-debug-info=build/debug-info
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info
```

> **Note:** Debug info symbols are required for crash report deobfuscation. Keep them safe!

## Documentation

See [DOCUMENTATION.md](DOCUMENTATION.md) for detailed feature documentation, edge cases, and architecture.

## License

MIT License - See [LICENSE](LICENSE)

---

Built with ❤️ for Area51 Mess

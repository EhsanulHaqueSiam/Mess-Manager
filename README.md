# Mess Manager

Smart expense and meal tracking for shared living groups. Built with Flutter.

[![Flutter](https://img.shields.io/badge/Flutter-3.41+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart)](https://dart.dev)
[![CI/CD](https://github.com/EhsanulHaqueSiam/Mess-Manager/actions/workflows/build.yml/badge.svg)](https://github.com/EhsanulHaqueSiam/Mess-Manager/actions)

## Features

**Meals** -- Add meals with 0.5-2x portions, weekly schedules, per-member tracking, bulk entry, Ramadan mode

**Bazar** -- Simple or itemized grocery entries, shared shopping list, receipt OCR scanner, budget alerts

**Balance** -- Fair cost distribution (meal rate = total bazar / total meals), per-member breakdown, settlement flow

**Money** -- Personal loans between members, transaction history, settlement reports

**Analytics** -- Spending trends, daily averages, month summaries, price spike alerts

**Members** -- 7 roles (superAdmin to guest), role-based access control, vacation tracking

**Utilities** -- DESCO electricity tracking, duty assignments, fixed expense management

**AI** -- Gemini chatbot for expense queries, NLP-based bazar entry categorization, smart suggestions

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.41 / Dart 3.11 |
| State | Riverpod 3.x (Notifier/AsyncNotifier) |
| Routing | go_router 17.x |
| Models | Freezed 3.x + json_serializable |
| Local DB | Isar Plus (offline-first, disabled on web) |
| Backend | Firebase (Auth, Firestore, Messaging, Crashlytics, AI) |
| UI | FlexColorScheme, flutter_animate, Lucide Icons, shadcn_ui |
| Design | Cosmic Bioluminescence -- glassmorphism, teal palette, 120Hz+ |
| Platforms | Android, iOS, Web, Linux |

## Quick Start

```bash
git clone git@github.com:EhsanulHaqueSiam/Mess-Manager.git
cd Mess-Manager
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Project Structure

```
lib/
  core/
    models/        Freezed data models (13 models)
    providers/     Global Riverpod providers
    router/        go_router with auth-aware redirects
    theme/         AppColors, AppSpacing, AppTypography, glassTile helpers
    widgets/       AppCard, GlassCard, AppSheet, AppInput, AppBadge
    services/      Firebase, Isar, NLP, haptics, backup, export
    api/           Retrofit clients (Dio, Aladhan, DESCO)
  features/
    18 modules: analytics, auth, balance, bazar, chatbot, dashboard,
    desco, duties, info, meals, members, money, notifications,
    ramadan, settings, settlement, unified, vacation
  shared/
    widgets/       MainShell (floating glass nav), TappableScale, SmartSuggestionCard
```

## Building

```bash
# Android (debug on device)
flutter run -d <device_id>

# Android (release APK with obfuscation)
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

# Web
flutter build web --release

# Linux
flutter build linux --release
```

## Testing

```bash
make test           # All tests
make test-unit      # Unit tests (test/unit/)
make test-widget    # Widget tests (test/widget/)
make test-e2e       # Integration tests
make test-coverage  # With coverage report
```

## License

MIT

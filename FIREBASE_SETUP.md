# Firebase Setup Guide

## Step 1: Install FlutterFire CLI

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli
```

## Step 2: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create Project"
3. Name it "mess-manager" (or your preferred name)
4. Enable Google Analytics (free)
5. Wait for project creation

## Step 3: Configure FlutterFire

```bash
# In your Flutter project directory
cd area51_app

# Run FlutterFire configuration
flutterfire configure
```

This will:
- Create necessary Firebase configuration files
- Generate `lib/firebase_options.dart`
- Configure platforms (Android, iOS, Web)

## Step 4: Enable Firebase Services

### Authentication
1. Go to Firebase Console → Authentication → Get Started
2. Enable "Email/Password" provider
3. Enable "Google" provider (optional)

### Cloud Firestore
1. Go to Firebase Console → Firestore Database → Create Database
2. Select "Start in production mode"
3. Choose a location (e.g., asia-south1 for India)
4. Deploy security rules from `firestore.rules`:

```bash
firebase deploy --only firestore:rules
```

### Cloud Messaging (FCM)
1. Already enabled by default
2. For Android: Add `google-services.json` (done by FlutterFire)
3. For iOS: Upload APNs key in Firebase Console

### Analytics & Crashlytics
1. Already enabled with Firebase project creation

## Step 5: Update Firebase Options

After running `flutterfire configure`, update `firebase_service.dart`:

```dart
// In firebase_service.dart, update initialize():
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform, // Add this
);
```

And add the import:
```dart
import 'firebase_options.dart';
```

## Step 6: Test Integration

```bash
# Run the app
flutter run

# Check Firebase Dashboard for:
# - Active users in Analytics
# - Registered users in Authentication
# - Database entries in Firestore
```

## Free Tier Limits (Spark Plan)

| Service | Daily Limit | Monthly Limit |
|---------|-------------|---------------|
| Auth | Unlimited | Unlimited |
| Firestore Reads | 50,000 | 1.5M |
| Firestore Writes | 20,000 | 600K |
| Firestore Deletes | 20,000 | 600K |
| Firestore Storage | - | 1 GB |
| FCM | Unlimited | Unlimited |
| Analytics | Unlimited | Unlimited |
| Crashlytics | Unlimited | Unlimited |

## Security Checklist

- [x] Firestore Rules deployed
- [x] Authentication required for all operations
- [x] User data isolation
- [x] Mess access control (members only)
- [x] Owner permissions for mess settings
- [x] Input validation in rules

# Firebase Setup Guide (All Free Tier Services)

## Services Used (All Free)

| Service | Limit | Purpose |
|---------|-------|---------|
| **Authentication** | 50K MAUs | User login/signup |
| **Cloud Firestore** | 1GB, 50K reads/day | Data storage |
| **FCM** | Unlimited | Push notifications |
| **Analytics** | 500 events | Usage tracking |
| **Crashlytics** | Unlimited | Crash reporting |
| **Performance** | Unlimited | App performance monitoring |
| **Remote Config** | Unlimited | Dynamic app configuration |
| **App Check** | Unlimited | API security/protection |
| **In-App Messaging** | Unlimited | Targeted messages |

---

## Step 1: Install CLI Tools

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
2. Click "Create Project" → Name: "mess-manager"
3. Enable Google Analytics ✅
4. Wait for creation

## Step 3: Configure FlutterFire

```bash
cd area51_app
flutterfire configure
```

Select platforms: Android, iOS, Web

## Step 4: Enable Services

### Authentication
1. Console → Authentication → Get Started
2. Enable providers:
   - ✅ Email/Password
   - ✅ Google (optional)

### Cloud Firestore
1. Console → Firestore → Create Database
2. Select **Production mode**
3. Choose location: `asia-south1` (India)
4. Deploy rules:
```bash
firebase deploy --only firestore:rules
```

### App Check (Security)
1. Console → App Check
2. Register your app
3. Enable enforcement for Firestore

### Remote Config
1. Console → Remote Config
2. Add parameters (or use defaults in code)

### Performance Monitoring
1. Console → Performance
2. Automatically enabled

---

## Security Checklist ✅

### 1. Firestore Security Rules (Already Created)
- ✅ Users can only access their own data
- ✅ Mess access limited to members only
- ✅ Only owner can modify mess settings
- ✅ Input validation on writes

### 2. App Check (Prevents Unauthorized Access)
```dart
// Already integrated in firebase_service.dart
await FirebaseAppCheck.instance.activate(
  androidProvider: AndroidProvider.playIntegrity,
  appleProvider: AppleProvider.appAttest,
);
```

### 3. Authentication
- ✅ Email verification (optional)
- ✅ Password strength requirements
- ✅ Secure token management

### 4. Rate Limiting (Firestore Rules)
```javascript
// Add to firestore.rules for extra protection
match /messes/{messId}/meals/{mealId} {
  allow create: if isMessMember(messId) && 
    request.time > resource.data.createdAt + duration.value(1, 's');
}
```

---

## Anti-Hack Measures

### What Firebase Protects Against:
1. **Unauthorized API calls** - App Check verifies requests come from your app
2. **Data theft** - Firestore rules restrict access
3. **User impersonation** - Firebase Auth handles tokens securely
4. **Brute force** - Firebase has built-in rate limiting
5. **Fake clients** - App attestation on Android/iOS

### Additional Security Tips:
1. Never expose Firebase config in public repos (use .gitignore)
2. Enable App Check enforcement in production
3. Review Firestore rules regularly
4. Monitor usage in Firebase Console
5. Set up billing alerts (even on free tier)

---

## Remote Config Defaults

| Key | Default | Purpose |
|-----|---------|---------|
| `meal_rate_default` | 1.0 | Default meal rate |
| `meal_reminder_morning` | "09:00" | Lunch reminder time |
| `meal_reminder_evening` | "17:00" | Dinner reminder time |
| `night_preview_time` | "21:00" | Tomorrow's meal preview |
| `maintenance_mode` | false | Enable maintenance mode |
| `min_app_version` | "1.0.0" | Force update threshold |

---

## Free Tier Optimization

### Reduce Firestore Reads:
1. Use local Hive cache as first layer
2. Batch multiple writes together
3. Limit query results with `.limit()`
4. Use `Timestamp.now()` instead of server timestamp when possible

### Monitor Usage:
1. Firebase Console → Usage & Billing
2. Set up alerts at 80% usage
3. Review daily in first weeks

---

## Test Firebase Integration

```bash
# Run the app
flutter run

# Verify in Firebase Console:
# ✅ Authentication - New user appears
# ✅ Firestore - Documents created
# ✅ Analytics - Events logged
# ✅ Crashlytics - Connected
# ✅ Performance - Traces visible
```

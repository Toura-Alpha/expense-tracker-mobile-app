# Expense Tracker

A Flutter expense tracker backed by Firebase Authentication and Cloud Firestore.
Income and expenses are logged per category, with budget caps, monthly analytics
charts, dark mode, and CSV export.

## Features

- Email/password sign-up and sign-in
- Per-user expenses and categories stored in Firestore
- Add, edit, and swipe-to-delete transactions
- Category creation with icon, color, and an optional monthly budget cap
- Budget planner with per-category and overall progress
- Monthly analytics: income vs. spending trend and category breakdown
- Light/dark/system theme and a configurable currency symbol (persisted)
- CSV export via the system share sheet

## Project structure

This is a monorepo. The data layer lives in two local packages so the UI stays
free of Firebase types.

```
lib/                            App shell, screens, and blocs
packages/expense_repository/    Expense + Category models, entities, Firestore repo
packages/user_repository/       MyUser model and Firebase Auth repo
```

Data is stored per user, so switching accounts never mixes transactions:

```
users/{uid}
  ├── expenses/{expenseId}      { expenseId, amount, isIncome, date, note, category {...} }
  ├── categories/{categoryId}   { categoryId, name, icon, color, budgetLimit, totalExpenses }
  └── { userId, email, name }
```

## Prerequisites

- Flutter 3.44.9 / Dart 3.12.2
- Android SDK (for the Android target)
- Node.js (for the Firebase CLI)
- A Firebase project

## Setup

**1. Install the Firebase CLI.** The FlutterFire CLI shells out to it, so it must
be on your PATH.

```bash
npm install -g firebase-tools
```

**2. Configure Firebase for Flutter.** This authenticates you in the browser,
generates `lib/firebase_options.dart`, and downloads
`android/app/google-services.json`.

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=<your-project-id> --platforms=android,web
```

**3. Enable services in the Firebase console** (Project settings → your project):

- **Authentication** → Sign-in method → enable **Email/Password**
- **Firestore Database** → create a database

**4. Install dependencies and run.**

```bash
flutter pub get
flutter run -d <device-id>   # or: flutter run -d chrome
```

## Tests

```bash
flutter test
flutter analyze
```

The suite covers the `Expense` and `Category` models, including entity and
Firestore-document round-trips and the `Category.empty` sentinel behavior. It
runs without a live Firebase connection.

## Notes

- The Android `applicationId` is `com.myexpensetracker.app`. This must match the
  package name registered in the Firebase project.
- Release builds are signed with debug keys, so `flutter run --release` works but
  Play Store distribution needs a real upload keystore configured in
  `android/app/build.gradle.kts`.
- Firestore security rules are not version-controlled here. Add rules that verify
  `request.auth.uid` before shipping; the default rules allow open access.

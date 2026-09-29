# MyCampus — Flutter Challenge

A polished Flutter MVP for the SoftTaqwa MyCampus recruitment challenge.

## Stack

- Flutter / Dart
- BLoC + flutter_bloc
- Firebase Authentication
- Cloud Firestore
- Clean Architecture-inspired feature separation
- Responsive Material 3 UI
- Demo Mode for instant evaluator access

## Features

- Splash / auth gate
- Firebase email/password login
- Demo mode without Firebase data
- Student dashboard
- Today's class schedule
- Attendance overview
- Assignments
- Campus notices
- Profile
- Dark/light theme
- Reusable UI components
- Repository abstraction over Firebase

## Firebase setup

Install Firebase CLI and FlutterFire CLI:

```bash
firebase login
dart pub global activate flutterfire_cli
```

From the project root:

```bash
flutter pub get
flutterfire configure
```

Select Android/iOS/Web as required. This generates `lib/firebase_options.dart`.

Then enable Email/Password authentication in Firebase Console.

Create Firestore collections if you want real data:

```text
users/{uid}
  name
  studentId
  department
  semester
  email

users/{uid}/classes/{id}
  title
  instructor
  room
  startTime
  endTime
  color

users/{uid}/assignments/{id}
  title
  course
  dueDate
  priority
  completed

users/{uid}/notices/{id}
  title
  description
  category
  date
  important
```

The app falls back to demo data when the evaluator chooses Demo Mode.

## Run

```bash
flutter pub get
flutterfire configure
flutter run
```

## Suggested challenge submission

Before submitting:

```bash
flutter analyze
flutter test
```

Then push the project to GitHub and include the repository URL in your reply to SoftTaqwa.

## Architecture

```text
lib/
├── app/
│   └── app.dart
├── core/
│   ├── theme/
│   ├── widgets/
│   └── utils/
├── data/
│   ├── models/
│   └── repositories/
├── features/
│   ├── auth/
│   ├── home/
│   ├── routine/
│   ├── assignments/
│   ├── notices/
│   └── profile/
└── main.dart
```

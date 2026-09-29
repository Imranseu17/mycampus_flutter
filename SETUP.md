# MyCampus — first run

This archive intentionally does not include generated Android/iOS platform folders or your private Firebase configuration.

## 1. Create platform folders

From the project directory:

```bash
flutter create .
```

## 2. Install dependencies

```bash
flutter pub get
```

## 3. Configure Firebase

Install/login to Firebase CLI and FlutterFire:

```bash
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
```

Choose Android, iOS and/or Web.

Then enable:

**Firebase Console → Authentication → Sign-in method → Email/Password**

For a quick evaluator demo, the app's **Explore Demo** button works without creating a Firebase user.

## 4. Run

```bash
flutter run
```

## 5. Validate before GitHub submission

```bash
flutter analyze
flutter test
```

## Recommended Firebase Firestore structure

```text
users/{uid}
users/{uid}/classes/{classId}
users/{uid}/assignments/{assignmentId}
users/{uid}/notices/{noticeId}
```

See README.md for example fields.

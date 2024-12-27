Secure Notes App
A secure note-taking application built with Flutter featuring Google authentication, biometric security, and cloud storage.
Features
Google Sign-in Authentication
Biometric App Lock
Cloud-based note storage using Firebase
Create, edit, and delete notes
Pin important notes
Customize note colors
Material Design interface
Dark/Light theme support
Offline capability
Error handling and feedback
Smooth animations and transitions
Tech Stack
Flutter & Dart
Firebase Authentication
Cloud Firestore
Provider: State Management
local_auth: Biometric authentication
google_sign_in: OAuth authentication
flutter_secure_storage: Secure local storage



Project Structure
lib/
├── core/
│   ├── config/
│   │   └── app_config.dart
│   └── errors/
│       └── error_handler.dart
├── features/
│   ├── auth/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── viewmodels/
│   └── notes/
│       ├── models/
│       ├── repositories/
│       └── viewmodels/
├── presentation/
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   └── note_screen.dart
│   └── widgets/
│       ├── error_dialog.dart
│       └── offline_banner.dart
└── shared/
    ├── services/
    │   └── connectivity_service.dart
    └── utils/
        └── animations.dart



Installation
Clone the repository:
git clone https://github.com/HASHIM-HAMEEM/secure_notes.git



Configure Firebase:
Add google-services.json to android/app/
Set up OAuth credentials in Google Cloud Console
Enable Google Sign-in in Firebase Console
Install dependencies:

flutter pub get


Run the app:
flutter run

Requirements
Flutter SDK: >= 3.0.0
Dart SDK: >= 3.0.0
Firebase project setup
Google Cloud Platform project
Android Studio / VS Code


Dependencies
dependencies:
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  google_sign_in: ^6.1.6
  local_auth: ^2.1.7
  provider: ^6.1.1
  flutter_secure_storage: ^9.0.0
  connectivity_plus: ^5.0.2

Developer
Hashim Hameem
Contact: hashimdar141@yahoo.com
Recent Updates
Added Google Sign-in authentication
Implemented biometric app lock
Migrated to Firebase Cloud Storage
Added error handling and offline support
Improved UI animations
Implemented MVVM architecture
Added proper testing infrastructure
Enhanced app security features


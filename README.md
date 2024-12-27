Secure Notes App
A modern, secure note-taking application built with Flutter that offers a clean interface and robust features for managing personal notes.


Features
Create and edit notes with titles and content
Pin important notes to the top
Customize note colors
Material Design interface
Secure local storage
Auto-save functionality
Search notes
Dark/Light theme support



Tech Stack
Flutter & Dart
Provider: State Management
SQLite Database: Local database for storing notes
flutter_secure_storage: Secure local storage for sensitive data
Material Design Components




Project Structure

lib/
├── constants/
│   ├── app_constants.dart
│   ├── colors.dart
│   └── theme.dart
├── models/
│   └── note_model.dart
├── providers/
│   ├── note_provider.dart
│   └── theme_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── note_screen.dart
│   └── search_screen.dart
├── utils/
│   ├── animations.dart
│   ├── database_helper.dart
│   └── secure_storage.dart
├── widgets/
│   ├── custom_drawer.dart
│   ├── empty_notes.dart
│   └── note_card.dart
└── main.dart




Installation
1. Clone the repository
Run the following command to clone the repository:
git clone https://github.com/HASHIM-HAMEEM/secure_notes.git


2. Install dependencies
Install the required dependencies by running:
flutter pub get


3. Run the app
Launch the app using the following command:
flutter run



Requirements
Flutter SDK: >= 3.0.0
Dart SDK: >= 3.0.0
Android Studio / VS Code
Android SDK / iOS Development Setup




Dependencies
provider: State management solution
sqflite: Local database for storing notes
flutter_secure_storage: Secure storage for sensitive data
path_provider: Access to the file system
intl: Date formatting






Contributing
Fork the repository
Create a feature branch
Commit your changes
Push to the branch
Create a Pull Request




Developer
Hashim Hameem
Contact: hashimdar141@yahoo.com




Acknowledgments
Flutter Team
Material Design
Flutter Community




Key Updates:
Added proper Markdown formatting for headers (## for subheadings).
Used code blocks with triple backticks (```) for proper code formatting.
Simplified text for clarity, especially under the "Dependencies" and "Contributing" sections.


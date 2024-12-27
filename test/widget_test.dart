import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fin/main.dart'; // Changed from secure_notes to fin

void main() {
  testWidgets('Secure Notes app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp());

    // Verify that splash screen shows correct title
    expect(find.text('Secure Notes'), findsOneWidget);

    // Verify that the note icon is present
    expect(find.byIcon(Icons.note_alt_outlined), findsOneWidget);

    // Verify the creator text is present
    expect(find.text('Created with ❤️ by Fin'), findsOneWidget);

    // Allow animations to complete
    await tester.pumpAndSettle();
  });
}

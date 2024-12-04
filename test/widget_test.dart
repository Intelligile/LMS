import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_router.dart'; // Adjust the import path if needed
import 'package:lms/main.dart';

// Create a mock or dummy GoRouter instance
GoRouter createTestRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: Center(child: Text('Home Page')),
        ),
      ),
    ],
  );
}

void main() {
  testWidgets('Basic widget test for MyApp', (WidgetTester tester) async {
    // Create a test router
    final testRouter = createTestRouter();

    // Build our app with the test router
    await tester.pumpWidget(MyApp(router: testRouter));

    // Verify that the 'Home Page' text is present
    expect(find.text('Home Page'), findsOneWidget);

    // Add more assertions as needed based on your app's functionality
  });
}

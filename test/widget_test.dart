import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:user_form/main.dart';

void main() {
  testWidgets('Home page shows Hello World and opens the form page',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Hello World'), findsOneWidget);

    await tester.tap(find.text('Go to Form Page'));
    await tester.pumpAndSettle();

    expect(find.text('User Form'), findsOneWidget);
    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Clear'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}

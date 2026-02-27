import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stich/main.dart';

void main() {
  testWidgets('menu button toggles menu rows', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);
    expect(find.textContaining('RESUME'), findsNothing);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.textContaining('RESUME'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.textContaining('RESUME'), findsNothing);
  });
}

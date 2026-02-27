import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stich/main.dart';

void _pressIconButtonByKey(WidgetTester tester, String key) {
  final button = tester.widget<IconButton>(find.byKey(Key(key)));
  button.onPressed?.call();
}

void _pressOutlinedButtonByKey(WidgetTester tester, String key) {
  final button = tester.widget<OutlinedButton>(find.byKey(Key(key)));
  button.onPressed?.call();
}

Future<void> _openAnimatedMenuItem(WidgetTester tester, int menuIndex) async {
  _pressIconButtonByKey(tester, 'hamburger_menu_button');
  await tester.pump(const Duration(milliseconds: 700));

  final menuItem = tester.widget<GestureDetector>(
    find.byKey(Key('animated_menu_item_$menuIndex')),
  );
  menuItem.onTap?.call();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 700));
}

void main() {
  testWidgets('shared app bar remains stable when switching modes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byKey(const Key('shared_app_bar')), findsOneWidget);
    expect(find.byKey(const Key('animated_mode_button')), findsOneWidget);
    expect(find.byKey(const Key('flat_mode_button')), findsOneWidget);
    expect(find.byKey(const Key('hamburger_menu_button')), findsOneWidget);
    expect(find.byKey(const Key('animated_mode_content')), findsOneWidget);

    _pressOutlinedButtonByKey(tester, 'flat_mode_button');
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byKey(const Key('shared_app_bar')), findsOneWidget);
    expect(find.byKey(const Key('flat_mode_content')), findsOneWidget);

    _pressOutlinedButtonByKey(tester, 'animated_mode_button');
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byKey(const Key('animated_mode_content')), findsOneWidget);
  });

  testWidgets('animated menu open state keeps row menu animation behavior', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.textContaining('EXPERIENCE'), findsNothing);

    _pressIconButtonByKey(tester, 'hamburger_menu_button');
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.textContaining('EXPERIENCE'), findsWidgets);
    expect(find.byKey(const Key('animated_menu_item_0')), findsOneWidget);
    expect(find.byKey(const Key('animated_menu_item_4')), findsOneWidget);
    expect(find.textContaining('CLOSE'), findsWidgets);
  });

  testWidgets('animated menu ABOUT opens in-place resume overlay', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 200));

    await _openAnimatedMenuItem(tester, 1);

    expect(
      find.byKey(const Key('animated_section_panel_about')),
      findsOneWidget,
    );
    expect(find.text('Date of Birth'), findsOneWidget);
    expect(find.byKey(const Key('flat_mode_content')), findsNothing);
  });

  testWidgets('closing animated overlay returns to landing-only state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 200));

    await _openAnimatedMenuItem(tester, 2);
    expect(
      find.byKey(const Key('animated_section_panel_skills')),
      findsOneWidget,
    );

    _pressOutlinedButtonByKey(tester, 'animated_section_close_button');
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.byKey(const Key('animated_section_panel_skills')),
      findsNothing,
    );
  });

  testWidgets('flat mode has section menu via shared hamburger', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 200));

    _pressOutlinedButtonByKey(tester, 'flat_mode_button');
    await tester.pump(const Duration(milliseconds: 250));

    _pressIconButtonByKey(tester, 'hamburger_menu_button');
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byKey(const Key('flat_section_menu')), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Skills').first);
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byKey(const Key('flat_section_menu')), findsNothing);
  });

  testWidgets('flat mode shows real profile data', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 200));

    _pressOutlinedButtonByKey(tester, 'flat_mode_button');
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Technical Skills'), findsOneWidget);
    expect(find.text('Date of Birth'), findsOneWidget);
    expect(find.text('January 27, 1996'), findsOneWidget);
    expect(find.text('Marital Status'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stich/data/portfolio_snapshot.dart';
import 'package:stich/main.dart';
import 'package:stich/widgets/scrolling_text_row.dart';

void _pressIconButtonByKey(WidgetTester tester, String key) {
  final button = tester.widget<IconButton>(find.byKey(Key(key)).first);
  button.onPressed?.call();
}

void _pressOutlinedButtonByKey(WidgetTester tester, String key) {
  final button = tester.widget<OutlinedButton>(find.byKey(Key(key)).first);
  button.onPressed?.call();
}

int _rowCount(WidgetTester tester) {
  return tester
      .widgetList<ScrollingTextRow>(find.byType(ScrollingTextRow))
      .length;
}

Future<void> _openAnimatedMenuItem(WidgetTester tester, int menuIndex) async {
  await tester.tap(
    find.byKey(const Key('hamburger_menu_button')),
    warnIfMissed: false,
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 980));

  final menuItem = tester.widget<GestureDetector>(
    find.byKey(Key('animated_menu_item_$menuIndex')),
  );
  menuItem.onTap?.call();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 920));
}

void main() {
  testWidgets('mode switch swaps shared app bar and flat sliver app bar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 220));

    expect(find.byKey(const Key('shared_app_bar')), findsOneWidget);
    expect(find.byKey(const Key('flat_sliver_app_bar')), findsNothing);

    _pressOutlinedButtonByKey(tester, 'flat_mode_button');
    await tester.pump(const Duration(milliseconds: 320));

    expect(find.byKey(const Key('shared_app_bar')), findsNothing);
    expect(find.byKey(const Key('flat_sliver_app_bar')), findsOneWidget);

    _pressOutlinedButtonByKey(tester, 'animated_mode_button');
    await tester.pump(const Duration(milliseconds: 320));

    expect(find.byKey(const Key('shared_app_bar')), findsOneWidget);
    expect(find.byKey(const Key('animated_mode_content')), findsOneWidget);
  });

  testWidgets('animated menu open state keeps row menu behavior', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 220));

    expect(find.textContaining('EXPERIENCE'), findsNothing);

    _pressIconButtonByKey(tester, 'hamburger_menu_button');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 980));

    expect(find.textContaining('EXPERIENCE'), findsWidgets);
    expect(find.byKey(const Key('animated_menu_item_0')), findsOneWidget);
    expect(find.byKey(const Key('animated_menu_item_3')), findsOneWidget);
    expect(find.byKey(const Key('animated_menu_item_4')), findsNothing);
    expect(find.textContaining('CLOSE'), findsNothing);
  });

  testWidgets('animated landing shows core profile info rows only', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 220));

    expect(find.textContaining('GITHUB •'), findsWidgets);
    expect(find.textContaining('PHONE • +989162363723'), findsWidgets);
    expect(find.textContaining('HOME PALETTE'), findsNothing);
    expect(
      find.textContaining('TOBANK • DIGITAL BANKING PLATFORM'),
      findsNothing,
    );
  });

  testWidgets('animated mode motion smoothing works across scenes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 260));

    final landingRows = tester.widgetList<ScrollingTextRow>(
      find.byType(ScrollingTextRow),
    );
    expect(
      landingRows
          .where((row) => row.motionMode == RowMotionMode.marquee)
          .length,
      6,
    );

    _pressIconButtonByKey(tester, 'hamburger_menu_button');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 980));

    final menuRows = tester.widgetList<ScrollingTextRow>(
      find.byType(ScrollingTextRow),
    );
    final reducedMotionRows = menuRows.where(
      (row) =>
          row.motionMode == RowMotionMode.marquee && row.motionBlend < 0.05,
    );
    expect(reducedMotionRows.length, 6);

    final aboutMenuItem = tester.widget<GestureDetector>(
      find.byKey(const Key('animated_menu_item_1')),
    );
    aboutMenuItem.onTap?.call();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 920));

    expect(
      find.byKey(const Key('animated_section_panel_about')),
      findsOneWidget,
    );

    final overlayRows = tester.widgetList<ScrollingTextRow>(
      find.byType(ScrollingTextRow),
    );
    expect(
      overlayRows.every((row) => row.motionMode == RowMotionMode.staticHold),
      isTrue,
    );
  });

  testWidgets('animated landing keeps fixed row count across viewports', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 260));
    final mobileRowCount = _rowCount(tester);

    tester.view.physicalSize = const Size(844, 390);
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 260));
    final landscapeRowCount = _rowCount(tester);

    tester.view.physicalSize = const Size(1024, 1366);
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 260));
    final portraitTabletRowCount = _rowCount(tester);

    tester.view.physicalSize = const Size(1366, 768);
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 260));
    final desktopRows = tester.widgetList<ScrollingTextRow>(
      find.byType(ScrollingTextRow),
    );
    final desktopMarqueeCount = desktopRows
        .where((row) => row.motionMode == RowMotionMode.marquee)
        .length;

    expect(mobileRowCount, 10);
    expect(landscapeRowCount, 10);
    expect(portraitTabletRowCount, 10);
    expect(_rowCount(tester), 10);
    expect(desktopMarqueeCount, 6);
  });

  testWidgets('row style defaults match new kinetic requirements', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 260));

    final rows = tester.widgetList<ScrollingTextRow>(
      find.byType(ScrollingTextRow),
    );
    final movingRows = rows
        .where((row) => row.motionMode == RowMotionMode.marquee)
        .toList();
    final staticRows = rows
        .where((row) => row.motionMode == RowMotionMode.staticHold)
        .toList();
    final fonts = rows.map((row) => row.fontSize).toList()..sort();
    final smallest = fonts.first;
    final largest = fonts.last;

    expect(largest / smallest, closeTo(3.0, 0.05));
    expect(rows.every((row) => row.speedPixelsPerSecond == 22.5), isTrue);
    expect(
      movingRows.every((row) => row.loopMode == RowLoopMode.pingPong),
      isTrue,
    );
    expect(movingRows.every((row) => row.syncProgress != null), isTrue);
    final syncValue = movingRows.first.syncProgress!;
    expect(
      movingRows.every(
        (row) => (row.syncProgress! - syncValue).abs() < 0.000001,
      ),
      isTrue,
    );
    expect(
      movingRows.every(
        (row) => row.baseTextStyle?.fontFamily == 'BuiltTitlingRgBold',
      ),
      isTrue,
    );
    expect(
      staticRows.any(
        (row) => row.baseTextStyle?.fontFamily != 'BuiltTitlingRgBold',
      ),
      isTrue,
    );
    expect(rows.every((row) => row.dividerColor != Colors.white), isTrue);
  });

  testWidgets('animated shared header uses avatar and dark readability tint', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 220));

    expect(find.byKey(const Key('header_avatar')), findsOneWidget);

    final appBarContainer = tester.widget<Container>(
      find.byKey(const Key('shared_app_bar')),
    );
    final decoration = appBarContainer.decoration! as BoxDecoration;
    final color = decoration.color!;

    expect(color.r, 0);
    expect(color.g, 0);
    expect(color.b, 0);
    expect(color.a, closeTo(0.50, 0.03));
  });

  test('avatar URL uses the provided GitHub avatar link', () {
    expect(
      portfolioSnapshot.avatarImageUrl,
      'https://avatars.githubusercontent.com/u/38153222?s=400&u=d18ed5e2ac293ec31421fb90d061c5671067351c&v=4',
    );
  });

  testWidgets('flat mode sliver app bar shows expanded avatar then collapses', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 220));

    _pressOutlinedButtonByKey(tester, 'flat_mode_button');
    await tester.pump(const Duration(milliseconds: 320));

    expect(find.byKey(const Key('flat_sliver_app_bar')), findsOneWidget);
    expect(find.byKey(const Key('flat_expanded_avatar')), findsOneWidget);

    await tester.drag(
      find.byKey(const Key('portfolio_scroll_view')),
      const Offset(0, -540),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byKey(const Key('flat_sliver_app_bar')), findsOneWidget);
    expect(find.byKey(const Key('hamburger_menu_button')), findsOneWidget);
    expect(find.byKey(const Key('header_avatar')), findsOneWidget);
  });

  testWidgets('flat mode has section menu via hamburger in sliver app bar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 220));

    _pressOutlinedButtonByKey(tester, 'flat_mode_button');
    await tester.pump(const Duration(milliseconds: 280));

    _pressIconButtonByKey(tester, 'hamburger_menu_button');
    await tester.pump(const Duration(milliseconds: 320));

    expect(find.byKey(const Key('flat_section_menu')), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Skills').first);
    await tester.pump(const Duration(milliseconds: 260));

    expect(find.byKey(const Key('flat_section_menu')), findsNothing);
  });

  testWidgets('animated menu ABOUT opens in-place resume overlay', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 220));

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
    await tester.pump(const Duration(milliseconds: 220));

    await _openAnimatedMenuItem(tester, 2);
    expect(
      find.byKey(const Key('animated_section_panel_skills')),
      findsOneWidget,
    );

    _pressOutlinedButtonByKey(tester, 'animated_section_close_button');
    await tester.pump(const Duration(milliseconds: 360));

    expect(
      find.byKey(const Key('animated_section_panel_skills')),
      findsNothing,
    );
  });

  testWidgets('flat mode shows real profile data', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 220));

    _pressOutlinedButtonByKey(tester, 'flat_mode_button');
    await tester.pump(const Duration(milliseconds: 320));

    expect(find.text('Technical Skills'), findsOneWidget);
    expect(find.text('Date of Birth'), findsOneWidget);
    expect(find.text('January 27, 1996'), findsOneWidget);
    expect(find.text('Marital Status'), findsOneWidget);
  });
}

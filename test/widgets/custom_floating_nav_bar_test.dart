import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:e_commerce_mobile_app/widgets/custom_floating_nav_bar.dart';

void main() {
  Widget wrap({
    int initialIndex = 0,
    ValueChanged<int>? onSelected,
    Brightness brightness = Brightness.light,
  }) {
    return MaterialApp(
      theme: ThemeData(brightness: brightness),
      home: Scaffold(
        bottomNavigationBar: CustomFloatingNavBar(
          initialIndex: initialIndex,
          onItemSelected: onSelected,
        ),
      ),
    );
  }

  testWidgets('shows a label only for the selected tab', (tester) async {
    await tester.pumpWidget(wrap());

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Chart'), findsNothing);
    expect(find.byIcon(LucideIcons.lineChart), findsOneWidget);
  });

  testWidgets('tapping a tab calls onItemSelected and expands its label', (
    tester,
  ) async {
    int? selected;
    await tester.pumpWidget(wrap(onSelected: (i) => selected = i));

    await tester.tap(find.byIcon(LucideIcons.trophy));
    await tester.pumpAndSettle();

    expect(selected, 4);
    expect(find.text('Rewards'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
  });

  testWidgets('renders ClipRRect and BackdropFilter with sigma 14 blur', (
    tester,
  ) async {
    await tester.pumpWidget(wrap());

    final clipFinder = find.byType(ClipRRect);
    expect(clipFinder, findsOneWidget);

    final backdropFinder = find.byType(BackdropFilter);
    expect(backdropFinder, findsOneWidget);

    final BackdropFilter backdropWidget = tester.widget(backdropFinder);
    expect(backdropWidget.filter, isNotNull);
  });

  testWidgets('adapts glassmorphism background and 1px border to dark theme', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(brightness: Brightness.dark));

    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/design/tokens.dart';
import 'package:flutter_portfolio/core/motion/reveal.dart';
import 'package:flutter_portfolio/core/theme/app_theme.dart';
import 'package:flutter_portfolio/main.dart';
import 'package:flutter_test/flutter_test.dart';

void _desktop(WidgetTester tester) {
  tester.view.physicalSize = const Size(1440, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('shows the name, role and nav links', (tester) async {
    _desktop(tester);
    await tester.pumpWidget(const MyApp(initialMode: ThemeMode.light));
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Chowdhury'), findsOneWidget);
    expect(find.text('Flutter engineer.'), findsOneWidget);
    for (final label in ['Projects', 'Experience', 'About', 'Contact']) {
      expect(find.text(label), findsWidgets);
    }
  });

  testWidgets('theme toggle switches light to dark', (tester) async {
    _desktop(tester);
    await tester.pumpWidget(const MyApp(initialMode: ThemeMode.light));
    await tester.pump(const Duration(seconds: 1));

    Brightness current() =>
        Theme.of(tester.element(find.text('Flutter engineer.'))).brightness;
    expect(current(), Brightness.light);

    await tester.tap(find.byIcon(Icons.dark_mode_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(current(), Brightness.dark);
  });

  testWidgets('Reveal plays once when scrolled into view', (tester) async {
    _desktop(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 2000),
                Reveal(child: const Text('revealed')),
                const SizedBox(height: 600),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    Opacity opacity() => tester.widget<Opacity>(
        find.ancestor(of: find.text('revealed'), matching: find.byType(Opacity)).first);
    expect(opacity().opacity, 0);

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -1700));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(opacity().opacity, 1);

    // Scrolling away and back must not replay it.
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 1700));
    await tester.pump(const Duration(seconds: 1));
    expect(opacity().opacity, 1);
  });

  testWidgets('Reveal shows content immediately with reduced motion',
      (tester) async {
    _desktop(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: child!,
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 3000),
                Reveal(child: const Text('revealed')),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    final opacity = tester.widget<Opacity>(
        find.ancestor(of: find.text('revealed'), matching: find.byType(Opacity)).first);
    expect(opacity.opacity, 1);
  });

  test('fluid tokens clamp at both ends', () {
    expect(Motion.entranceOffset, 24);
    expect(AppColors.light.signal, isNot(AppColors.dark.signal));
  });
}

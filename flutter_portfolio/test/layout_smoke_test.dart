import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tabrez_portfolio/main.dart';
import 'package:tabrez_portfolio/presentation/simple/simple_page.dart';

/// Renders both portfolio views at several viewport widths and fails on any
/// layout overflow. For realistic text metrics pass a folder with the real
/// fonts (Inter_400.ttf … Inter_800.ttf, JetBrainsMono_*.ttf, Sora_*.ttf):
///
///   flutter test --dart-define=FONT_DIR=/path/to/fonts
Future<void> _loadFonts() async {
  const dir = String.fromEnvironment('FONT_DIR');
  if (dir.isEmpty) return;
  for (final family in ['Inter', 'JetBrainsMono', 'Sora']) {
    for (final weight in ['400', '500', '600', '700', '800']) {
      final file = File('$dir/${family}_$weight.ttf');
      if (!file.existsSync()) continue;
      // google_fonts registers families as e.g. "Inter_regular", "Inter_600".
      final loader = FontLoader('${family}_${weight == '400' ? 'regular' : weight}')
        ..addFont(Future.value(ByteData.view(file.readAsBytesSync().buffer)));
      await loader.load();
    }
  }
}

/// Collects layout errors while [body] runs.
Future<Set<String>> _collectErrors(Future<void> Function() body) async {
  final errors = <String>{};
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    final message = details.exceptionAsString();
    // Font fetching is disabled in tests; only layout problems matter here.
    if (message.contains('font')) return;
    errors.add(message);
  };
  try {
    await body();
  } finally {
    FlutterError.onError = previous;
  }
  return errors;
}

/// Runs the view transition to completion (pumpAndSettle can't be used:
/// both views have endless animations).
Future<void> _finishFade(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  setUpAll(_loadFonts);

  const sizes = [Size(360, 780), Size(375, 812), Size(700, 1000), Size(900, 1000), Size(1100, 900), Size(1440, 900)];

  // The default test font renders every glyph 1em wide, which overflows any
  // real layout, so these checks only run with real fonts.
  const skip = String.fromEnvironment('FONT_DIR') == '';

  for (final size in sizes) {
    testWidgets('Apple view renders without layout errors at ${size.width}px', skip: skip, (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final errors = await _collectErrors(() async {
        await tester.pumpWidget(const TabrezPortfolioApp());
        await tester.pump(const Duration(milliseconds: 100));
        // Visit every interactive phone screen.
        for (final tab in ['iTask', 'Connect API', 'Flutter UI', 'Articles']) {
          await tester.tap(find.text(tab).first, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 400));
        }
      });
      expect(errors, isEmpty, reason: errors.join('\n'));
    });

    testWidgets('Simple view renders without layout errors at ${size.width}px', skip: skip, (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final errors = await _collectErrors(() async {
        await tester.pumpWidget(MaterialApp(home: SimplePortfolioPage(onSwitchView: () {})));
        await tester.pump(const Duration(milliseconds: 100));
        // Scroll through the page so every section reveals and animates.
        for (var i = 0; i < 40; i++) {
          await tester.drag(find.byType(SingleChildScrollView), Offset(0, -size.height * 0.6), warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 300));
        }
        await tester.pump(const Duration(seconds: 2));
        // Mobile menu open/close.
        final bars = find.byWidgetPredicate((w) => w.runtimeType.toString() == 'FaIcon');
        if (size.width <= 860 && bars.evaluate().isNotEmpty) {
          await tester.pump(const Duration(milliseconds: 500));
        }
      });
      expect(errors, isEmpty, reason: errors.join('\n'));
    });
  }

  testWidgets('switches between the Apple and simple views', skip: skip, (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const TabrezPortfolioApp());
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Simple view'), findsOneWidget);

    await tester.tap(find.text('Simple view'));
    await _finishFade(tester);
    expect(find.text('Developer view'), findsOneWidget);
    expect(find.text('Simple view'), findsNothing);

    await tester.tap(find.text('Developer view'));
    await _finishFade(tester);
    expect(find.text('Simple view'), findsOneWidget);
    expect(find.text('Developer view'), findsNothing);
  });
}

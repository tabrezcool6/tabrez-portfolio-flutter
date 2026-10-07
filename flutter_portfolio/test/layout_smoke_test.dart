import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tabrez_portfolio/main.dart';

/// Renders the whole page at several viewport widths and fails on any layout
/// overflow. For realistic text metrics pass a folder with the real fonts
/// (Inter_400.ttf … Inter_800.ttf, JetBrainsMono_400.ttf … JetBrainsMono_800.ttf):
///
///   flutter test --dart-define=FONT_DIR=/path/to/fonts
Future<void> _loadFonts() async {
  const dir = String.fromEnvironment('FONT_DIR');
  if (dir.isEmpty) return;
  for (final family in ['Inter', 'JetBrainsMono']) {
    for (final weight in ['400', '500', '600', '700', '800']) {
      final bytes = File('$dir/${family}_$weight.ttf').readAsBytesSync();
      // google_fonts registers families as e.g. "Inter_regular", "Inter_600".
      final loader = FontLoader('${family}_${weight == '400' ? 'regular' : weight}')
        ..addFont(Future.value(ByteData.view(bytes.buffer)));
      await loader.load();
    }
  }
}

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  setUpAll(_loadFonts);

  const sizes = [Size(360, 780), Size(375, 812), Size(700, 1000), Size(900, 1000), Size(1100, 900), Size(1440, 900)];

  // The default test font renders every glyph 1em wide, which overflows any
  // real layout, so this check only runs with real fonts.
  const skip = String.fromEnvironment('FONT_DIR') == '';

  for (final size in sizes) {
    testWidgets('renders without layout errors at ${size.width}px', skip: skip, (tester) async {
      final errors = <String>{};
      final previous = FlutterError.onError;
      FlutterError.onError = (details) {
        final message = details.exceptionAsString();
        // Font fetching is disabled in tests; only layout problems matter here.
        if (message.contains('font')) return;
        errors.add(message);
      };

      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(const TabrezPortfolioApp());
      await tester.pump(const Duration(milliseconds: 100));

      // Visit every interactive phone screen.
      for (final tab in ['iTask', 'Connect API', 'Flutter UI', 'Articles']) {
        await tester.tap(find.text(tab).first, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 400));
      }

      FlutterError.onError = previous;
      tester.view.reset();
      expect(errors, isEmpty, reason: errors.join('\n'));
    });
  }
}

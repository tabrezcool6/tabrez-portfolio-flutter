import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tailwind CSS v4 palette values used by the React build (src/), so both
/// versions render with the exact same colours.
class Tw {
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const fg = Color(0xFFF5F5F7); // body text colour

  static const neutral100 = Color(0xFFF5F5F5);
  static const neutral200 = Color(0xFFE5E5E5);
  static const neutral300 = Color(0xFFD4D4D4);
  static const neutral400 = Color(0xFFA1A1A1);
  static const neutral500 = Color(0xFF737373);
  static const neutral600 = Color(0xFF525252);
  static const neutral700 = Color(0xFF404040);
  static const neutral800 = Color(0xFF262626);
  static const neutral900 = Color(0xFF171717);
  static const neutral950 = Color(0xFF0A0A0A);

  static const blue300 = Color(0xFF8EC5FF);
  static const blue400 = Color(0xFF51A2FF);
  static const blue500 = Color(0xFF2B7FFF);
  static const blue600 = Color(0xFF155DFC);
  static const indigo600 = Color(0xFF4F39F6);
  static const emerald400 = Color(0xFF00D492);
  static const emerald500 = Color(0xFF00BC7D);
  static const emerald600 = Color(0xFF009966);
  static const amber400 = Color(0xFFFFB900);
  static const amber500 = Color(0xFFFE9A00);
  static const purple400 = Color(0xFFC27AFF);
  static const purple500 = Color(0xFFAD46FF);
  static const cyan400 = Color(0xFF00D3F2);
  static const cyan500 = Color(0xFF00B8DB);
  static const rose300 = Color(0xFFFFA1AD);
  static const rose400 = Color(0xFFFF637E);
  static const rose500 = Color(0xFFFF2056);

  static const card = Color(0xFF121214); // bg-[#121214]
  static const modal = Color(0xFF18181B); // bg-[#18181b]
  static const footer = Color(0xFF050505);

  /// `border-white/10` style helper.
  static Color w(double opacity) => white.withValues(alpha: opacity);
}

/// Tailwind type scale: (font-size, line-height multiplier).
class TwSize {
  final double size;
  final double height;
  const TwSize(this.size, this.height);

  static const xs = TwSize(12, 16 / 12);
  static const sm = TwSize(14, 20 / 14);
  static const base = TwSize(16, 1.5);
  static const lg = TwSize(18, 28 / 18);
  static const xl = TwSize(20, 28 / 20);
  static const x2 = TwSize(24, 32 / 24);
  static const x3 = TwSize(30, 36 / 30);
  static const x4 = TwSize(36, 40 / 36);
  static const x5 = TwSize(48, 1);
  static const x6 = TwSize(60, 1);
  static const x7 = TwSize(72, 1);

  /// Arbitrary `text-[11px]` sizes inherit the 1.5 body line-height.
  static TwSize px(double size) => TwSize(size, 1.5);
}

/// Tailwind letter-spacing presets (in em).
class Tracking {
  static const body = -0.015; // body { letter-spacing: -0.015em }
  static const tighter = -0.05;
  static const tight = -0.025;
  static const wider = 0.05;
  static const widest = 0.1;
}

/// Per-glyph width difference (in em) between SF Pro — what the React build
/// renders with on Apple devices — and Inter, measured in Chrome for each
/// font size (rows) and weight 400…800 (columns). Adding it as extra
/// letter-spacing makes Inter lines break exactly like the React page.
const _sfSizes = <double>[9.0, 10, 11, 12, 14, 16, 18, 20, 24, 30, 36, 48, 60, 72];
const _sfCorrection = [
  [0.0180, 0.0241, 0.0302, 0.0364, 0.0414],
  [0.0111, 0.0173, 0.0234, 0.0296, 0.0345],
  [0.0053, 0.0114, 0.0175, 0.0237, 0.0287],
  [-0.0006, 0.0056, 0.0117, 0.0179, 0.0228],
  [-0.0113, -0.0052, 0.0009, 0.0071, 0.0121],
  [-0.0201, -0.0140, -0.0079, -0.0017, 0.0033],
  [-0.0279, -0.0217, -0.0154, -0.0093, -0.0042],
  [-0.0379, -0.0314, -0.0250, -0.0185, -0.0130],
  [-0.0492, -0.0418, -0.0344, -0.0271, -0.0209],
  [-0.0504, -0.0427, -0.0351, -0.0273, -0.0209],
  [-0.0533, -0.0456, -0.0380, -0.0302, -0.0238],
  [-0.0562, -0.0485, -0.0409, -0.0332, -0.0268],
  [-0.0592, -0.0515, -0.0438, -0.0361, -0.0297],
  [-0.0618, -0.0541, -0.0465, -0.0388, -0.0324],
];

/// Second-pass residual (em) measured in Flutter web (CanvasKit) against
/// Chrome's SF Pro, for weights 400 and 700 at these sizes.
const _residualSizes = <double>[10.0, 11, 12, 14, 16, 20, 30, 48];
const _residual400 = [-0.0007, -0.0008, -0.0007, -0.0008, -0.0008, -0.0001, 0.0020, 0.0020];
const _residual700 = [-0.0037, -0.0036, -0.0037, -0.0036, -0.0036, -0.0029, -0.0003, -0.0003];

double _lerpTable(List<double> sizes, List<double> values, double size) {
  if (size <= sizes.first) return values.first;
  if (size >= sizes.last) return values.last;
  for (var i = 1; i < sizes.length; i++) {
    if (size <= sizes[i]) {
      final t = (size - sizes[i - 1]) / (sizes[i] - sizes[i - 1]);
      return values[i - 1] + (values[i] - values[i - 1]) * t;
    }
  }
  return values.last;
}

double _sfTracking(double size, FontWeight weight) {
  final col = ((weight.value - 400) ~/ 100).clamp(0, 4);
  final base = _lerpTable(_sfSizes, [for (final row in _sfCorrection) row[col]], size);
  final t = (weight.value - 400) / 300;
  final r400 = _lerpTable(_residualSizes, _residual400, size);
  final r700 = _lerpTable(_residualSizes, _residual700, size);
  return base + r400 + (r700 - r400) * t;
}

/// Builds a TextStyle that mirrors a Tailwind class list.
TextStyle tw(
  TwSize s, {
  FontWeight weight = FontWeight.w400,
  Color color = Tw.fg,
  double? leading,
  double tracking = Tracking.body,
  bool mono = false,
  bool tabular = false,
  bool uppercase = false,
  TextDecoration? decoration,
  Color? decorationColor,
}) {
  // index.html only loads JetBrains Mono 400–600, so heavier mono text renders at 600.
  if (mono && weight.value > 600) weight = FontWeight.w600;
  final base = TextStyle(
    fontSize: s.size,
    height: leading ?? s.height,
    fontWeight: weight,
    color: color,
    letterSpacing: (tracking + (mono ? 0 : _sfTracking(s.size, weight))) * s.size,
    leadingDistribution: TextLeadingDistribution.even,
    // Chrome turns off optional ligatures whenever letter-spacing is non-zero,
    // so e.g. JetBrains Mono renders "->" as two glyphs on the React page.
    fontFeatures: [
      const FontFeature.disable('liga'),
      const FontFeature.disable('calt'),
      if (tabular) const FontFeature.tabularFigures(),
    ],
    decoration: decoration,
    decorationColor: decorationColor,
  );
  // --font-sans resolves to SF Pro on Apple devices; Inter is the closest web font.
  // --font-mono resolves to JetBrains Mono (loaded from Google Fonts in index.html).
  return mono ? GoogleFonts.jetBrainsMono(textStyle: base) : GoogleFonts.inter(textStyle: base);
}

/// Tailwind leading presets.
class Leading {
  static const tight = 1.25;
  static const snug = 1.375;
  static const relaxed = 1.625;
}

/// Viewport breakpoints (sm 640, md 768, lg 1024, xl 1280).
class Bp {
  final double width;
  const Bp(this.width);
  factory Bp.of(BuildContext context) => Bp(MediaQuery.sizeOf(context).width);

  bool get sm => width >= 640;
  bool get md => width >= 768;
  bool get lg => width >= 1024;
  bool get xl => width >= 1280;

  /// Mobile-first responsive value, like `p-4 sm:p-6 lg:p-8`.
  T v<T>(T base, {T? sm, T? md, T? lg, T? xl}) {
    var r = base;
    if (this.sm && sm != null) r = sm;
    if (this.md && md != null) r = md;
    if (this.lg && lg != null) r = lg;
    if (this.xl && xl != null) r = xl;
    return r;
  }
}

class AppleTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Tw.black,
      primaryColor: Tw.blue600,
      canvasColor: Tw.neutral900,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: Tw.fg,
        displayColor: Tw.fg,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: Tw.blue600, // selection:bg-blue-600
        cursorColor: Tw.white,
      ),
      colorScheme: const ColorScheme.dark(
        primary: Tw.blue500,
        surface: Tw.neutral900,
        onSurface: Tw.fg,
      ),
    );
  }
}

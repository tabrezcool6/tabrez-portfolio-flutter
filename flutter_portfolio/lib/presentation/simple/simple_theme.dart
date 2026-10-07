import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Simple portfolio view — design tokens and shared widgets ported from
// simpler_portfolio/style.css (https://github.com/tabrezcool6/tabrezcool6.github.io).

/// `:root` tokens from style.css.
class SC {
  static const primary = Color(0xFF19C6A4);
  static const primaryDark = Color(0xFF08B390);
  static const primarySoft = Color(0x1F19C6A4); // rgba(25,198,164,.12)
  static const bg = Color(0xFF0B1220);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF10151F);
  static const inkSoft = Color(0xFF4B5563);
  static const line = Color(0xFFE6E9EF);
  static const page = Color(0xFFF7F9FB);
  static const tagBg = Color(0xFFF1F4F8);
  static const inputBg = Color(0xFFFBFCFE);
  static const footerText = Color(0xFFCBD2DF);

  static const ease = Cubic(0.22, 1, 0.36, 1);
  static const radius = 18.0;

  static const shadowSm = [BoxShadow(color: Color(0x0F10151F), offset: Offset(0, 2), blurRadius: 8)];
  static const shadowMd = [BoxShadow(color: Color(0x1A10151F), offset: Offset(0, 16), blurRadius: 40)];
  static const shadowLg = [BoxShadow(color: Color(0x2910151F), offset: Offset(0, 30), blurRadius: 70)];
  static const primaryGlow = [BoxShadow(color: Color(0x5919C6A4), offset: Offset(0, 10), blurRadius: 24)];
  static const primaryGlowHover = [BoxShadow(color: Color(0x7319C6A4), offset: Offset(0, 16), blurRadius: 34)];

  static const gradient = LinearGradient(colors: [primary, primaryDark]);
}

/// `body { line-height: 1.65 }`; form controls use `line-height: normal`
/// (≈1.21 for Inter).
const kBodyLeading = 1.65;
const kNormalLeading = 1.21;

/// Inter body text (`--font-body`).
TextStyle sBody(double size,
    {FontWeight weight = FontWeight.w400,
    Color color = SC.ink,
    double height = kBodyLeading,
    double letterSpacing = 0}) {
  return GoogleFonts.inter(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing * size,
  ).copyWith(leadingDistribution: TextLeadingDistribution.even);
}

/// Sora headings (`--font-head`).
TextStyle sHead(double size,
    {FontWeight weight = FontWeight.w600,
    Color color = SC.ink,
    double height = kBodyLeading,
    double letterSpacing = 0}) {
  return GoogleFonts.sora(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing * size,
  ).copyWith(leadingDistribution: TextLeadingDistribution.even);
}

/// Viewport breakpoints used by style.css (1300 / 1024 / 860 / 560).
class SBp {
  final double width;
  final double height;
  const SBp(this.width, this.height);
  factory SBp.of(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SBp(size.width, size.height);
  }

  bool get le1024 => width <= 1024;
  bool get le860 => width <= 860;
  bool get le560 => width <= 560;

  /// `.max-width` horizontal padding.
  double get gutter {
    if (le560) return 20;
    if (le860) return 32;
    if (width <= 1300) return 80;
    return 40;
  }

  /// CSS `clamp(min, vw%, max)`.
  double clampVw(double min, double vw, double max) => (width * vw / 100).clamp(min, max);
}

/// `.max-width { max-width: 1200px; padding: 0 <gutter>; margin: auto }`.
class SMaxWidth extends StatelessWidget {
  final Widget child;
  const SMaxWidth({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bp = SBp.of(context);
    // width: 100% up to 1200px, like the CSS (children never shrink-wrap it).
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: SizedBox(
          width: double.infinity,
          child: Padding(padding: EdgeInsets.symmetric(horizontal: bp.gutter), child: child),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reveal on scroll (`.reveal` / `.reveal.in` + IntersectionObserver in script.js)
// ---------------------------------------------------------------------------

/// Provides the page scroll controller to [Reveal] widgets.
class RevealScope extends InheritedWidget {
  final ScrollController controller;
  const RevealScope({super.key, required this.controller, required super.child});

  static ScrollController? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RevealScope>()?.controller;

  @override
  bool updateShouldNotify(RevealScope old) => controller != old.controller;
}

/// Whether the nearest [Reveal] ancestor has revealed (drives skill bars and
/// count-up stats, like `runEffects` in script.js).
class RevealedNotifier extends InheritedNotifier<ValueNotifier<bool>> {
  const RevealedNotifier({super.key, required super.notifier, required super.child});

  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RevealedNotifier>()?.notifier?.value ?? true;
}

/// Fades and slides its child up 34px once ≥15% of it is inside the
/// viewport (bottom margin -8%), with the 60ms sibling stagger of script.js.
class Reveal extends StatefulWidget {
  final Widget child;
  const Reveal({super.key, required this.child});

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  // Reveals triggered in the same frame stagger by 60ms (max 240ms).
  static int _batch = 0;
  static bool _batchResetScheduled = false;

  final _revealed = ValueNotifier<bool>(false);
  ScrollController? _controller;
  Timer? _timer;
  bool _triggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = RevealScope.of(context);
    if (controller != _controller) {
      _controller?.removeListener(_check);
      _controller = controller?..addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    _controller?.removeListener(_check);
    _timer?.cancel();
    _revealed.dispose();
    super.dispose();
  }

  void _check() {
    if (_triggered || !mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return;
    final viewport = MediaQuery.sizeOf(context).height;
    // The element sits 34px lower while hidden (CSS transform), as the observer sees it.
    final top = box.localToGlobal(Offset.zero).dy + (_revealed.value ? 0 : 34);
    final height = box.size.height;
    if (height <= 0) return;
    final visible = (top + height).clamp(0.0, viewport * 0.92) - top.clamp(0.0, viewport * 0.92);
    if (visible / height < 0.15) return;

    _triggered = true;
    if (MediaQuery.of(context).disableAnimations) {
      _revealed.value = true;
      return;
    }
    final delay = Duration(milliseconds: (_batch * 60).clamp(0, 240));
    _batch++;
    if (!_batchResetScheduled) {
      _batchResetScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _batch = 0;
        _batchResetScheduled = false;
      });
    }
    _timer = Timer(delay, () {
      if (mounted) _revealed.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RevealedNotifier(
      notifier: _revealed,
      child: ValueListenableBuilder<bool>(
        valueListenable: _revealed,
        builder: (context, shown, child) => TweenAnimationBuilder<double>(
          tween: Tween(end: shown ? 1 : 0),
          duration: const Duration(milliseconds: 800),
          curve: SC.ease,
          builder: (context, t, child) => Opacity(
            opacity: t,
            child: Transform.translate(offset: Offset(0, 34 * (1 - t)), child: child),
          ),
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section title (`.title` with ::after subtitle and ::before underline bar)
// ---------------------------------------------------------------------------

class STitle extends StatelessWidget {
  final String title;
  final String sub;
  const STitle(this.title, this.sub, {super.key});

  @override
  Widget build(BuildContext context) {
    final bp = SBp.of(context);
    return Reveal(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 44),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text(title,
                      textAlign: TextAlign.center,
                      style: sHead(bp.clampVw(30, 4, 44), weight: FontWeight.w700, letterSpacing: -0.02)),
                  const SizedBox(height: 14),
                  Text(sub.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: sBody(15, weight: FontWeight.w600, color: SC.primary, letterSpacing: 0.06)),
                ],
              ),
            ),
            Positioned(
              bottom: -8,
              child: Container(
                width: 54,
                height: 3,
                decoration: BoxDecoration(gradient: SC.gradient, borderRadius: BorderRadius.circular(3)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hover helper (same contract as the Apple view's Hover, kept local so this
// view has no dependency on the Apple widgets).
// ---------------------------------------------------------------------------

class SHover extends StatefulWidget {
  final Widget Function(BuildContext context, bool hovered) builder;
  final VoidCallback? onTap;
  const SHover({super.key, required this.builder, this.onTap});

  @override
  State<SHover> createState() => _SHoverState();
}

class _SHoverState extends State<SHover> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    Widget child = MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: widget.builder(context, _hovered),
    );
    if (widget.onTap != null) {
      child = GestureDetector(behavior: HitTestBehavior.opaque, onTap: widget.onTap, child: child);
    }
    return child;
  }
}

/// `<input>` / `<textarea>` from the contact form: 1.5px border, 12px radius,
/// 13×16 padding, focus border + 4px soft ring.
class SInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final int lines;
  final TextInputType? keyboardType;
  const SInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hint,
    this.lines = 1,
    this.keyboardType,
  });

  @override
  State<SInput> createState() => _SInputState();
}

class _SInputState extends State<SInput> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocus);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocus);
    super.dispose();
  }

  void _onFocus() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final focused = widget.focusNode.hasFocus;
    final style = sBody(15, height: kNormalLeading);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: SC.ease,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: SC.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: focused ? SC.primary : SC.line, width: 1.5),
        boxShadow: focused ? const [BoxShadow(color: SC.primarySoft, spreadRadius: 4)] : null,
      ),
      child: ConstrainedBox(
        // textarea { min-height: 130px } minus padding + border
        constraints: BoxConstraints(minHeight: widget.lines > 1 ? 130 - 26 - 3 : 0),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          minLines: widget.lines,
          maxLines: widget.lines,
          keyboardType: widget.lines > 1 ? TextInputType.multiline : widget.keyboardType,
          style: style,
          cursorColor: SC.ink,
          decoration: InputDecoration.collapsed(
            hintText: widget.hint,
            hintStyle: style.copyWith(color: const Color(0xFF757575)),
          ),
        ),
      ),
    );
  }
}

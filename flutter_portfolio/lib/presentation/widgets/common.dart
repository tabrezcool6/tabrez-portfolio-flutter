import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/apple_theme.dart';

/// Tailwind's default `transition` timing.
const twDuration = Duration(milliseconds: 150);
const twCurve = Cubic(0.4, 0, 0.2, 1);

/// Opens a link in a new tab (`target="_blank"`); mailto opens in place.
Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  await launchUrl(uri, webOnlyWindowName: uri.scheme == 'mailto' ? '_self' : '_blank');
}

/// Tracks pointer hover and exposes it to [builder], like CSS `:hover` / `group-hover`.
class Hover extends StatefulWidget {
  final Widget Function(BuildContext context, bool hovered) builder;
  final VoidCallback? onTap;
  final MouseCursor? cursor;

  const Hover({super.key, required this.builder, this.onTap, this.cursor});

  @override
  State<Hover> createState() => _HoverState();
}

class _HoverState extends State<Hover> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    Widget child = MouseRegion(
      cursor: widget.cursor ?? (widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer),
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

/// `active:scale-95` press feedback.
class PressScale extends StatefulWidget {
  final Widget child;
  final double scale;
  const PressScale({super.key, required this.child, this.scale = 0.95});

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      onPointerCancel: (_) => setState(() => _down = false),
      child: AnimatedScale(
        scale: _down ? widget.scale : 1,
        duration: twDuration,
        curve: twCurve,
        child: widget.child,
      ),
    );
  }
}

/// `max-w-7xl mx-auto px-4 sm:px-6 lg:px-8`.
class PageContainer extends StatelessWidget {
  final Widget child;
  const PageContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: bp.v(16.0, sm: 24.0, lg: 32.0)),
          child: child,
        ),
      ),
    );
  }
}

/// `<section className="py-20 sm:py-28 [border-t border-white/10]">` + page container.
class Section extends StatelessWidget {
  final Widget child;
  final bool borderTop;
  const Section({super.key, required this.child, this.borderTop = false});

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);
    return Container(
      width: double.infinity,
      decoration: borderTop ? BoxDecoration(border: Border(top: BorderSide(color: Tw.w(0.1)))) : null,
      padding: EdgeInsets.symmetric(vertical: bp.v(80.0, sm: 112.0)),
      child: PageContainer(child: child),
    );
  }
}

/// Kicker + two-tone h2 + paragraph used at the top of every section.
class SectionHeader extends StatelessWidget {
  final String kicker;
  final Color kickerColor;
  final String title;
  final String subtitle;
  final String body;
  final bool largeBody; // text-base sm:text-lg instead of text-sm sm:text-base
  final bool centered;
  final double maxWidth;

  const SectionHeader({
    super.key,
    required this.kicker,
    required this.title,
    required this.subtitle,
    required this.body,
    this.kickerColor = Tw.blue400,
    this.largeBody = false,
    this.centered = false,
    this.maxWidth = 768,
  });

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);
    final align = centered ? TextAlign.center : TextAlign.start;
    final h2 = tw(bp.v(TwSize.x3, sm: TwSize.x5),
        weight: FontWeight.w700, color: Tw.white, tracking: Tracking.tight, leading: Leading.tight);
    final bodySize = largeBody ? bp.v(TwSize.base, sm: TwSize.lg) : bp.v(TwSize.sm, sm: TwSize.base);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text(kicker.toUpperCase(),
              textAlign: align,
              style: tw(TwSize.xs, mono: true, color: kickerColor, tracking: Tracking.widest)),
          BalancedText(
            TextSpan(text: '$title\n', children: [
              TextSpan(text: subtitle, style: h2.copyWith(color: Tw.neutral400)),
            ]),
            textAlign: align,
            style: h2,
          ),
          BalancedText(TextSpan(text: body),
              textAlign: align, style: tw(bodySize, color: Tw.neutral400, leading: Leading.relaxed)),
        ],
      ),
    );
  }
}

/// `rounded-3xl bg-[#121214] border border-white/10 hover:border-white/20` card.
class TwCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double hoverBorder;
  final bool lift; // hover:-translate-y-1
  final VoidCallback? onTap;
  final Duration duration;

  const TwCard({
    super.key,
    required this.child,
    required this.padding,
    this.radius = 24,
    this.hoverBorder = 0.2,
    this.lift = false,
    this.onTap,
    this.duration = twDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Hover(
      onTap: onTap,
      builder: (context, hovered) => AnimatedContainer(
        duration: duration,
        curve: twCurve,
        transform: Matrix4.translationValues(0, lift && hovered ? -4 : 0, 0),
        padding: padding,
        decoration: BoxDecoration(
          color: Tw.card,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Tw.w(hovered ? hoverBorder : 0.1)),
        ),
        child: HoverScope(hovered: hovered, child: child),
      ),
    );
  }
}

/// Exposes the hover state of an ancestor card to descendants (`group-hover:`).
class HoverScope extends InheritedWidget {
  final bool hovered;
  const HoverScope({super.key, required this.hovered, required super.child});

  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HoverScope>()?.hovered ?? false;

  @override
  bool updateShouldNotify(HoverScope oldWidget) => hovered != oldWidget.hovered;
}

/// Tailwind-style CSS grid: fixed column count with gaps. When [stretch] is
/// true every item in a row gets the row's height (CSS grid default).
class TwGrid extends StatelessWidget {
  final int columns;
  final double gapX;
  final double gapY;
  final List<Widget> children;
  final bool stretch;

  const TwGrid({
    super.key,
    required this.columns,
    required this.children,
    this.gapX = 0,
    this.gapY = 0,
    this.stretch = true,
  });

  @override
  Widget build(BuildContext context) {
    if (columns <= 1) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: gapY, children: children);
    }
    if (stretch) {
      return LayoutBuilder(builder: (context, c) {
        final cell = (c.maxWidth - gapX * (columns - 1)) / columns;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: gapY,
          children: [
            for (var i = 0; i < children.length; i += columns)
              EqualHeightRow(
                widths: List.filled(math.min(columns, children.length - i), cell),
                gap: gapX,
                children: children.sublist(i, math.min(i + columns, children.length)),
              ),
          ],
        );
      });
    }
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += columns) {
      final cells = <Widget>[];
      for (var c = 0; c < columns; c++) {
        final idx = i + c;
        // Explicit gap boxes: Row.spacing is not counted by intrinsic sizing,
        // which would make IntrinsicHeight rows too short.
        if (c > 0) cells.add(SizedBox(width: gapX));
        cells.add(Expanded(child: idx < children.length ? children[idx] : const SizedBox()));
      }
      final row = Row(
        crossAxisAlignment: stretch ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
        children: cells,
      );
      rows.add(stretch ? IntrinsicHeight(child: row) : row);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: gapY, children: rows);
  }
}

/// Lays children side by side with fixed widths, then stretches them all to
/// the tallest child's real height — CSS grid's `align-items: stretch`.
/// Unlike IntrinsicHeight it measures with a real layout pass, so the result
/// is always exact (e.g. after web fonts finish loading).
class EqualHeightRow extends MultiChildRenderObjectWidget {
  final List<double> widths;
  final double gap;

  const EqualHeightRow({super.key, required this.widths, required this.gap, required super.children});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderEqualHeightRow(widths, gap);

  @override
  void updateRenderObject(BuildContext context, _RenderEqualHeightRow renderObject) {
    renderObject
      ..widths = widths
      ..gap = gap;
  }
}

class _EqualHeightParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderEqualHeightRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _EqualHeightParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _EqualHeightParentData> {
  _RenderEqualHeightRow(this._widths, this._gap);

  List<double> _widths;
  set widths(List<double> v) {
    _widths = v;
    markNeedsLayout();
  }

  double _gap;
  set gap(double v) {
    _gap = v;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _EqualHeightParentData) child.parentData = _EqualHeightParentData();
  }

  @override
  void performLayout() {
    var maxHeight = 0.0;
    var i = 0;
    for (var child = firstChild; child != null; child = childAfter(child), i++) {
      child.layout(BoxConstraints.tightFor(width: _widths[i]), parentUsesSize: true);
      if (child.size.height > maxHeight) maxHeight = child.size.height;
    }
    // Second pass: a minimum height rather than a tight one. Tight constraints
    // would make each child a relayout boundary, so when a web font finishes
    // loading and the text grows, this row would never re-measure and the
    // card's Column would overflow.
    var x = 0.0;
    var rowHeight = 0.0;
    i = 0;
    for (var child = firstChild; child != null; child = childAfter(child), i++) {
      child.layout(
        BoxConstraints(minWidth: _widths[i], maxWidth: _widths[i], minHeight: maxHeight),
        parentUsesSize: true,
      );
      (child.parentData! as _EqualHeightParentData).offset = Offset(x, 0);
      if (child.size.height > rowHeight) rowHeight = child.size.height;
      x += _widths[i] + _gap;
    }
    size = constraints.constrain(Size(x - _gap, rowHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) => defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}

/// A row of a 12-column CSS grid (`md:col-span-7` + `md:col-span-5`, …):
/// cells get the exact widths CSS grid would give them and equal heights.
class SpanRow extends StatelessWidget {
  final List<int> spans;
  final double gap;
  final List<Widget> children;
  final bool stretch;

  const SpanRow({super.key, required this.spans, required this.gap, required this.children, this.stretch = true});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final col = (c.maxWidth - 11 * gap) / 12;
      final widths = [for (final s in spans) s * col + (s - 1) * gap];
      if (stretch) return EqualHeightRow(widths: widths, gap: gap, children: children);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: gap,
        children: [for (var i = 0; i < children.length; i++) SizedBox(width: widths[i], child: children[i])],
      );
    });
  }
}

/// `text-wrap: balance` — narrows the line box to the smallest width that
/// keeps the same number of lines, so lines come out evenly sized.
class BalancedText extends StatefulWidget {
  final InlineSpan text;
  final TextStyle style;
  final TextAlign textAlign;

  const BalancedText(this.text, {super.key, required this.style, this.textAlign = TextAlign.start});

  @override
  State<BalancedText> createState() => _BalancedTextState();
}

class _BalancedTextState extends State<BalancedText> {
  @override
  void initState() {
    super.initState();
    // Web fonts arrive after the first frame; re-balance once they do.
    PaintingBinding.instance.systemFonts.addListener(_onFonts);
  }

  @override
  void dispose() {
    PaintingBinding.instance.systemFonts.removeListener(_onFonts);
    super.dispose();
  }

  void _onFonts() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final painter = TextPainter(
        text: TextSpan(style: widget.style, children: [widget.text]),
        textAlign: widget.textAlign,
        textDirection: TextDirection.ltr,
        textScaler: MediaQuery.textScalerOf(context),
      );
      int linesAt(double w) {
        painter.layout(maxWidth: w);
        return painter.computeLineMetrics().length;
      }

      var width = c.maxWidth;
      final lines = linesAt(width);
      // Chrome only balances blocks of up to 6 lines.
      if (lines > 1 && lines <= 6) {
        var lo = 0.0;
        for (var i = 0; i < 14; i++) {
          final mid = (lo + width) / 2;
          if (linesAt(mid) > lines) {
            lo = mid;
          } else {
            width = mid;
          }
        }
        width = width.ceilToDouble();
      }
      painter.dispose();

      final alignment = switch (widget.textAlign) {
        TextAlign.center => Alignment.topCenter,
        TextAlign.right || TextAlign.end => Alignment.topRight,
        _ => Alignment.topLeft,
      };
      return Align(
        alignment: alignment,
        widthFactor: 1,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width),
          child: Text.rich(widget.text, style: widget.style, textAlign: widget.textAlign),
        ),
      );
    });
  }
}

/// `<input>` / `<textarea>` styled like
/// `bg-neutral-900 border border-white/10 focus:border-blue-500`:
/// height = padding + line-height × lines + border, as in the browser.
class TwTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final TextStyle style;
  final EdgeInsets padding;
  final double radius;
  final int lines;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;
  final TextInputType? keyboardType;

  const TwTextInput({
    super.key,
    required this.controller,
    required this.hint,
    required this.style,
    required this.padding,
    required this.radius,
    this.lines = 1,
    this.focusNode,
    this.onSubmitted,
    this.keyboardType,
  });

  @override
  State<TwTextInput> createState() => _TwTextInputState();
}

class _TwTextInputState extends State<TwTextInput> {
  FocusNode? _ownNode;
  FocusNode get _node => widget.focusNode ?? (_ownNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _node.addListener(_onFocus);
  }

  @override
  void didUpdateWidget(TwTextInput old) {
    super.didUpdateWidget(old);
    if (old.focusNode != widget.focusNode) {
      (old.focusNode ?? _ownNode)?.removeListener(_onFocus);
      _node.addListener(_onFocus);
    }
  }

  @override
  void dispose() {
    _node.removeListener(_onFocus);
    _ownNode?.dispose();
    super.dispose();
  }

  void _onFocus() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: twDuration,
      curve: twCurve,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: Tw.neutral900,
        borderRadius: BorderRadius.circular(widget.radius),
        border: Border.all(color: _node.hasFocus ? Tw.blue500 : Tw.w(0.1)),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _node,
        style: widget.style,
        minLines: widget.lines,
        maxLines: widget.lines,
        keyboardType: widget.lines > 1 ? TextInputType.multiline : widget.keyboardType,
        cursorColor: Tw.white,
        onSubmitted: widget.onSubmitted == null ? null : (_) => widget.onSubmitted!(),
        decoration: InputDecoration.collapsed(
          hintText: widget.hint,
          hintStyle: widget.style.copyWith(color: Tw.neutral500),
        ),
      ),
    );
  }
}

/// Round profile photo from assets/images/profile.png
/// (`rounded-full object-cover border-white/15 shadow-lg shadow-black/50`).
/// [gap] (the CSS `gap` next to it) is applied only when the photo exists; if
/// the file is missing nothing is rendered, so the surrounding layout is unchanged.
class ProfilePhoto extends StatelessWidget {
  final double size;
  final EdgeInsets gap;
  const ProfilePhoto({super.key, required this.size, this.gap = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/profile.png',
      width: size,
      height: size,
      fit: BoxFit.cover,
      semanticLabel: 'Syed Tabrez Pasha S',
      frameBuilder: (context, child, frame, _) => Padding(
        padding: gap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: TwShadow.lg(Tw.black.withValues(alpha: 0.5)),
          ),
          foregroundDecoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Tw.w(0.15))),
          child: ClipOval(child: child),
        ),
      ),
      errorBuilder: (context, error, stack) => const SizedBox.shrink(),
    );
  }
}

/// Inline list separated by `·` (used for tech stacks and footers).
class DotList extends StatelessWidget {
  final List<String> items;
  final TextStyle style;
  final Color dotColor;
  final double gapX;
  final double gapY;
  final List<Widget> leading;
  final List<Widget> trailing;

  const DotList({
    super.key,
    required this.items,
    required this.style,
    required this.dotColor,
    this.gapX = 8,
    this.gapY = 4,
    this.leading = const [],
    this.trailing = const [],
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[...leading];
    for (var i = 0; i < items.length; i++) {
      children.add(Text(items[i], style: style));
      if (i < items.length - 1) children.add(Text('·', style: style.copyWith(color: dotColor)));
    }
    children.addAll(trailing);
    return Wrap(
      spacing: gapX,
      runSpacing: gapY,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}

/// `animate-pulse` — opacity 1 → 0.5 → 1 every 2s.
class Pulse extends StatefulWidget {
  final Widget child;
  const Pulse({super.key, required this.child});

  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = _c.value < 0.5 ? _c.value * 2 : (1 - _c.value) * 2;
        final eased = const Cubic(0.4, 0, 0.6, 1).transform(t);
        return Opacity(opacity: 1 - 0.5 * eased, child: child);
      },
      child: widget.child,
    );
  }
}

/// A round status dot, optionally pulsing.
class Dot extends StatelessWidget {
  final double size;
  final Color color;
  final bool pulse;
  const Dot({super.key, required this.size, required this.color, this.pulse = false});

  @override
  Widget build(BuildContext context) {
    final dot = Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
    return pulse ? Pulse(child: dot) : dot;
  }
}

/// Equivalent of CSS `linear-gradient(<angle>deg, ...)` for a given box.
Shader cssLinearGradient(Rect rect, double angleDeg, List<Color> colors, [List<double>? stops]) {
  final a = angleDeg * math.pi / 180;
  final dir = Offset(math.sin(a), -math.cos(a));
  final len = (rect.width * math.sin(a)).abs() + (rect.height * math.cos(a)).abs();
  final c = rect.center;
  return ui.Gradient.linear(c - dir * (len / 2), c + dir * (len / 2), colors, stops);
}

/// `.apple-titanium-gradient` text fill.
const titaniumColors = [Color(0xFFF5F5F7), Color(0xFF86868B), Color(0xFFD2D2D7)];
const titaniumStops = [0.0, 0.5, 1.0];

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  const GradientText(this.text, {super.key, required this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (rect) => cssLinearGradient(rect, 135, titaniumColors, titaniumStops),
      child: Text(text, style: style.copyWith(color: Tw.white), textAlign: textAlign),
    );
  }
}

String _hex(Color c) =>
    '#${(c.r * 255).round().toRadixString(16).padLeft(2, '0')}${(c.g * 255).round().toRadixString(16).padLeft(2, '0')}${(c.b * 255).round().toRadixString(16).padLeft(2, '0')}';

/// Lucide icons drawn from SVG so they can be filled (`fill="currentColor"`),
/// which the icon font cannot do.
class LucideSvg extends StatelessWidget {
  static const heart =
      '<path d="M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5"/>';
  static const bookmark = '<path d="m19 21-7-4-7 4V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v16z"/>';
  static const circleCheck = '<circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/>';

  final String body;
  final double size;
  final Color color;
  final Color? fill;

  const LucideSvg(this.body, {super.key, required this.size, required this.color, this.fill});

  @override
  Widget build(BuildContext context) {
    final fillAttr = fill == null ? 'fill="none"' : 'fill="${_hex(fill!)}" fill-opacity="${fill!.a.toStringAsFixed(3)}"';
    final svg = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" $fillAttr '
        'stroke="${_hex(color)}" stroke-opacity="${color.a.toStringAsFixed(3)}" stroke-width="2" '
        'stroke-linecap="round" stroke-linejoin="round">$body</svg>';
    return SvgPicture.string(svg, width: size, height: size);
  }
}

/// Tailwind shadow presets.
class TwShadow {
  static List<BoxShadow> sm([Color color = const Color(0x1A000000)]) => [
        BoxShadow(color: color, offset: const Offset(0, 1), blurRadius: 3),
        BoxShadow(color: color, offset: const Offset(0, 1), blurRadius: 2, spreadRadius: -1),
      ];
  static List<BoxShadow> md([Color color = const Color(0x1A000000)]) => [
        BoxShadow(color: color, offset: const Offset(0, 4), blurRadius: 6, spreadRadius: -1),
        BoxShadow(color: color, offset: const Offset(0, 2), blurRadius: 4, spreadRadius: -2),
      ];
  static List<BoxShadow> lg([Color color = const Color(0x1A000000)]) => [
        BoxShadow(color: color, offset: const Offset(0, 10), blurRadius: 15, spreadRadius: -3),
        BoxShadow(color: color, offset: const Offset(0, 4), blurRadius: 6, spreadRadius: -4),
      ];
  static const xl2 = [BoxShadow(color: Color(0x40000000), offset: Offset(0, 25), blurRadius: 50, spreadRadius: -12)];
}

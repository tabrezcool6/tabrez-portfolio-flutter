import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/common.dart' show EqualHeightRow, openUrl;
import 'simple_theme.dart';

// Sections of the simple portfolio view, ported from simpler_portfolio/index.html.
// Content is copied verbatim from that page.

/// Social links used by the hero rail and the footer.
const simpleSocials = [
  (FontAwesomeIcons.linkedinIn, 'https://linkedin.com/in/syed-tabrez-pasha-s-295b8a114/', 'LinkedIn'),
  (FontAwesomeIcons.github, 'https://github.com/tabrezcool6', 'GitHub'),
  (FontAwesomeIcons.xTwitter, 'https://twitter.com/tabrezcool6', 'Twitter'),
  (FontAwesomeIcons.facebookF, 'https://facebook.com/syed.tabrez.3382/', 'Facebook'),
];

/// Section padding from style.css (`section { padding: 72px 0 }` and the
/// per-section overrides, which win over the ≤860px `80px 0`).
EdgeInsets _sectionPadding(SBp bp, {double? top, double? bottom}) {
  final base = bp.le860 ? 80.0 : 72.0;
  return EdgeInsets.only(top: top ?? base, bottom: bottom ?? base);
}

/// Inline link style inside running text (`.hero-sub a`, `.about … p a`).
TextStyle _linkStyle(TextStyle style) => style.copyWith(color: SC.primaryDark, fontWeight: FontWeight.w600);

/// Running text with tappable links. Links are rendered as [WidgetSpan]s so
/// each can open its URL.
Widget _richText(List<Object> parts, TextStyle style, {TextAlign align = TextAlign.start}) {
  return Text.rich(
    TextSpan(children: [
      for (final p in parts)
        if (p is String)
          TextSpan(text: p)
        else if (p is (String, String))
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: _InlineLink(text: p.$1, url: p.$2, style: style),
          )
        else if (p is TextSpan)
          p,
    ]),
    style: style,
    textAlign: align,
  );
}

class _InlineLink extends StatelessWidget {
  final String text;
  final String url;
  final TextStyle style;
  const _InlineLink({required this.text, required this.url, required this.style});

  @override
  Widget build(BuildContext context) {
    final base = _linkStyle(style);
    return SHover(
      onTap: () => openUrl(url),
      builder: (context, hovered) => Text(
        text,
        style: base.copyWith(
          decoration: hovered ? TextDecoration.underline : null,
          decorationColor: SC.primaryDark,
        ),
      ),
    );
  }
}

// ===========================================================================
// Hero
// ===========================================================================

class SimpleHero extends StatelessWidget {
  final VoidCallback onViewWork;
  final VoidCallback onGetInTouch;
  final VoidCallback onScrollHint;
  const SimpleHero({super.key, required this.onViewWork, required this.onGetInTouch, required this.onScrollHint});

  @override
  Widget build(BuildContext context) {
    final bp = SBp.of(context);
    final centered = bp.le860;

    final content = Column(
      crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Reveal(
          child: Text('Hello, my name is',
              textAlign: centered ? TextAlign.center : TextAlign.start,
              style: sBody(20, weight: FontWeight.w500, color: SC.inkSoft)),
        ),
        Reveal(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('Syed Tabrez Pasha S',
                textAlign: centered ? TextAlign.center : TextAlign.start,
                style: sHead(bp.le560 ? 32 : bp.clampVw(38, 6, 64),
                    weight: FontWeight.w800, height: 1.05, letterSpacing: -0.03)),
          ),
        ),
        Reveal(
          child: Text.rich(
            TextSpan(text: "I'm a ", children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (rect) => SC.gradient.createShader(rect),
                  child: Text('Senior Flutter Engineer',
                      style: sHead(bp.le560 ? 22 : bp.clampVw(24, 3.4, 38), weight: FontWeight.w800)),
                ),
              ),
            ]),
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: sHead(bp.le560 ? 22 : bp.clampVw(24, 3.4, 38), color: SC.inkSoft),
          ),
        ),
        Reveal(
          child: Padding(
            padding: const EdgeInsets.only(top: 22, bottom: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: _richText(
                [
                  'Founder & Lead Engineer at ',
                  ('Sameens', 'https://sameens.com'),
                  '. Currently working at Rokkun Systems on ',
                  ('Rentify', 'https://gorentify.com'),
                  ', a Dubai-based platform modernizing property rentals. I build performant mobile and web '
                      'experiences with Flutter, Backed-Integration and Clean UI/UX.',
                ],
                sBody(bp.le560 ? 15 : 17, color: SC.inkSoft),
                align: centered ? TextAlign.center : TextAlign.start,
              ),
            ),
          ),
        ),
        Reveal(
          child: Wrap(
            spacing: 14,
            runSpacing: 14,
            alignment: centered ? WrapAlignment.center : WrapAlignment.start,
            children: [
              SButton.primary('View my work', onTap: onViewWork),
              SButton.ghost('Get in touch', onTap: onGetInTouch),
            ],
          ),
        ),
      ],
    );

    final photo = Reveal(child: _HeroPhoto(compact: bp.le1024));

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: bp.height),
      child: Stack(
        children: [
          // radial-gradient(1000px 600px at 80% -10%, primary-soft, transparent 60%), page
          Positioned.fill(child: CustomPaint(painter: _HeroBackgroundPainter())),
          Positioned.fill(child: _HeroGlow()),
          Padding(
            padding: EdgeInsets.only(top: 120, bottom: bp.le860 ? 80 : 72),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: bp.height - 120 - (bp.le860 ? 80 : 72)),
              child: Center(
                child: SMaxWidth(
                  child: centered
                      ? Column(children: [photo, const SizedBox(height: 10 + 20), content])
                      : Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 640),
                                  child: content,
                                ),
                              ),
                            ),
                            const SizedBox(width: 40),
                            photo,
                          ],
                        ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Center(child: _ScrollHint(onTap: onScrollHint)),
          ),
        ],
      ),
    );
  }
}

class _HeroBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = SC.page);
    final center = Offset(size.width * 0.8, -0.1 * size.height);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(1, 600 / 1000);
    canvas.drawCircle(
      Offset.zero,
      1000,
      Paint()
        ..shader = ui.Gradient.radial(Offset.zero, 1000, const [SC.primarySoft, Color(0x0019C6A4)], const [0, 0.6]),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_HeroBackgroundPainter old) => false;
}

/// `.hero-glow`: 520px radial glow, right -120px, top 8%, blur 30px, floating.
class _HeroGlow extends StatefulWidget {
  @override
  State<_HeroGlow> createState() => _HeroGlowState();
}

class _HeroGlowState extends State<_HeroGlow> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(seconds: 9))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(builder: (context, c) {
        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              right: -120,
              top: c.maxHeight * 0.08,
              width: 520,
              height: 520,
              child: AnimatedBuilder(
                animation: _c,
                builder: (context, child) {
                  // ease-in-out between 0% → 50% → 100%
                  final t = _c.value < 0.5 ? _c.value * 2 : (1 - _c.value) * 2;
                  final e = Curves.easeInOut.transform(t);
                  return Transform.translate(offset: Offset(-30 * e, 30 * e), child: child);
                },
                child: ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30, tileMode: TileMode.decal),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      // radial-gradient(circle, rgba(25,198,164,.28), transparent 65%):
                      // the circle reaches the farthest corner (260·√2 px = 0.707 of the
                      // box side in Flutter's units) and is transparent from 65% of that.
                      gradient: RadialGradient(
                        colors: [Color(0x4719C6A4), Color(0x0019C6A4)],
                        stops: [0, 0.65],
                        radius: 0.707,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

/// `.hero-photo`: spinning conic ring + floating circular photo.
class _HeroPhoto extends StatefulWidget {
  final bool compact; // ≤1024px: 260px box, image 240×290
  const _HeroPhoto({required this.compact});

  @override
  State<_HeroPhoto> createState() => _HeroPhotoState();
}

class _HeroPhotoState extends State<_HeroPhoto> with TickerProviderStateMixin {
  late final _spin = AnimationController(vsync: this, duration: const Duration(seconds: 14))..repeat();
  late final _float = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();

  @override
  void dispose() {
    _spin.dispose();
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = widget.compact ? 260.0 : 320.0;
    final imgW = widget.compact ? 240.0 : 290.0;
    const imgH = 290.0; // style.css only shrinks the width at ≤1024px
    return SizedBox(
      width: box,
      height: box,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: RotationTransition(
              turns: _spin,
              child: Opacity(
                opacity: 0.5,
                child: ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        // conic-gradient(from 0deg, primary, transparent 40%, primary-dark 70%, primary)
                        transform: GradientRotation(-math.pi / 2),
                        colors: [SC.primary, Color(0x0019C6A4), SC.primaryDark, SC.primary],
                        stops: [0, 0.4, 0.7, 1],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _float,
            builder: (context, child) {
              final t = _float.value < 0.5 ? _float.value * 2 : (1 - _float.value) * 2;
              return Transform.translate(offset: Offset(0, -16 * Curves.easeInOut.transform(t)), child: child);
            },
            child: Container(
              width: imgW,
              height: imgH,
              decoration: const ShapeDecoration(shape: OvalBorder(), color: SC.page, shadows: SC.shadowMd),
              child: ClipOval(
                child: Image.asset(
                  'assets/simple/syed-profile-pic.png',
                  width: imgW,
                  height: imgH,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  semanticLabel: 'Syed Tabrez Pasha S',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// `.scroll-hint`: mouse outline with an animated dot.
class _ScrollHint extends StatefulWidget {
  final VoidCallback onTap;
  const _ScrollHint({required this.onTap});

  @override
  State<_ScrollHint> createState() => _ScrollHintState();
}

class _ScrollHintState extends State<_ScrollHint> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SHover(
      onTap: widget.onTap,
      builder: (context, _) => Container(
        width: 24,
        height: 40,
        padding: const EdgeInsets.only(top: 7),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          border: Border.all(color: SC.inkSoft, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, child) {
            // @keyframes scrollDot: 0% {0, y0} 40% {1} 80% {0, y12} 100% {0}
            final v = _c.value;
            final opacity = v < 0.4 ? v / 0.4 : (v < 0.8 ? 1 - (v - 0.4) / 0.4 : 0.0);
            final dy = v < 0.8 ? 12 * v / 0.8 : 12.0;
            return Opacity(
              opacity: opacity.clamp(0, 1),
              child: Transform.translate(offset: Offset(0, dy), child: child),
            );
          },
          child: Container(
            width: 4,
            height: 8,
            decoration: BoxDecoration(color: SC.primary, borderRadius: BorderRadius.circular(4)),
          ),
        ),
      ),
    );
  }
}

/// `.social-rail`: fixed to the bottom-left on wide screens.
class SimpleSocialRail extends StatelessWidget {
  const SimpleSocialRail({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 18,
      children: [
        for (final s in simpleSocials)
          SHover(
            onTap: () => openUrl(s.$2),
            builder: (context, hovered) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: SC.ease,
              transform: Matrix4.translationValues(0, hovered ? -3 : 0, 0),
              child: Semantics(
                label: s.$3,
                // inline <a> with font-size 18px → 29.7px line box
                child: SizedBox(
                  height: 18 * kBodyLeading,
                  child: Center(child: FaIcon(s.$1, size: 18, color: hovered ? SC.primary : SC.inkSoft)),
                ),
              ),
            ),
          ),
        Container(
          width: 1.5,
          height: 90,
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [SC.inkSoft, Color(0x004B5563)],
            ),
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// Buttons (`.btn-primary`, `.btn-ghost`)
// ===========================================================================

class SButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool primary;
  final IconData? icon;
  final EdgeInsets padding;

  const SButton.primary(this.label,
      {super.key,
      required this.onTap,
      this.icon,
      this.padding = const EdgeInsets.symmetric(horizontal: 26, vertical: 13)})
      : primary = true;
  const SButton.ghost(this.label, {super.key, required this.onTap})
      : primary = false,
        icon = null,
        padding = const EdgeInsets.symmetric(horizontal: 26, vertical: 13);

  @override
  Widget build(BuildContext context) {
    return SHover(
      onTap: onTap,
      builder: (context, hovered) {
        final fg = primary ? Colors.white : (hovered ? SC.primaryDark : SC.ink);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: SC.ease,
          transform: Matrix4.translationValues(0, hovered ? -3 : 0, 0),
          padding: padding,
          decoration: BoxDecoration(
            color: primary ? (hovered ? SC.primaryDark : SC.primary) : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: primary ? Colors.transparent : (hovered ? SC.primary : SC.line),
              width: 1.5,
            ),
            boxShadow: primary ? (hovered ? SC.primaryGlowHover : SC.primaryGlow) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              Text(label, style: sBody(15, weight: FontWeight.w600, color: fg, height: kNormalLeading)),
              if (icon != null) FaIcon(icon, size: 15, color: fg),
            ],
          ),
        );
      },
    );
  }
}

// ===========================================================================
// About
// ===========================================================================

class SimpleAbout extends StatelessWidget {
  const SimpleAbout({super.key});

  @override
  Widget build(BuildContext context) {
    final bp = SBp.of(context);
    final imgSize = bp.le860 ? 300.0 : 380.0;
    final statSize = bp.le560 ? 24.0 : (bp.le860 ? 28.0 : 40.0);
    final p = sBody(16, color: SC.inkSoft);

    final image = Reveal(child: _AboutImage(size: imgSize));
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Reveal(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text("I'm Syed Tabrez Pasha S and I'm a Flutter Developer.", style: sHead(24, letterSpacing: -0.01)),
          ),
        ),
        Reveal(
          child: _richText([
            'I live in Bengaluru. I completed my Bachelor of Engineering (Electronics and Communication) from '
                'Sambhram Institute of Technology. I started coding in early 2019 and got a hang of it. From then '
                "I didn't stop. Initially, I started with Android Development (Java) and created many projects out "
                'of which ',
            ('Handwriter: handwriting app', 'https://play.google.com/store/apps/details?id=com.xsar.handwriter'),
            ' is one. Over the time, my interest kept increasing in the development field and to explore further '
                'I started Web Development. Apart from coding, I mostly like to cook and eat, watch series, travel '
                '& read and write and listen to good music.',
          ], p),
        ),
        Reveal(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Wrap(
              spacing: bp.le560 ? 24 : 36,
              runSpacing: 16,
              children: [
                _Stat(count: 5, label: 'Years coding', size: statSize),
                _Stat(count: 10, label: 'Featured projects', size: statSize),
                _Stat(count: 15, label: 'Years in business', size: statSize),
              ],
            ),
          ),
        ),
      ],
    );

    return Padding(
      padding: _sectionPadding(bp, top: 0, bottom: 110),
      child: SMaxWidth(
        child: Column(
          children: [
            const STitle('About me', 'who I am'),
            if (bp.le860)
              Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 36, children: [image, text])
            else
              Row(children: [image, const SizedBox(width: 60), Expanded(child: text)]),
          ],
        ),
      ),
    );
  }
}

class _AboutImage extends StatelessWidget {
  final double size;
  const _AboutImage({required this.size});

  @override
  Widget build(BuildContext context) {
    return SHover(
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: SC.ease,
        transform: hovered
            ? (Matrix4.identity()
              ..translateByDouble(size / 2, size / 2, 0, 1)
              ..rotateZ(-math.pi / 180)
              ..scaleByDouble(1.02, 1.02, 1, 1)
              ..translateByDouble(-size / 2, -size / 2, 0, 1))
            : Matrix4.identity(),
        width: size,
        height: size,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), boxShadow: SC.shadowMd),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset('assets/simple/syed-seconday-pic.png',
              fit: BoxFit.cover, semanticLabel: 'Syed Tabrez portrait'),
        ),
      ),
    );
  }
}

/// `.stat`: count-up number + "+" and a caption (runs when revealed).
class _Stat extends StatelessWidget {
  final int count;
  final String label;
  final double size;
  const _Stat({required this.count, required this.label, required this.size});

  @override
  Widget build(BuildContext context) {
    final revealed = RevealedNotifier.of(context);
    final num = sHead(size, weight: FontWeight.w800, color: SC.primaryDark, height: 1);
    final caption = sBody(13, weight: FontWeight.w500, color: SC.inkSoft);
    // `.stat` is a wrapping flex row whose caption has flex-basis 100%, so its
    // max-content width is number + "+" + caption side by side.
    double widthOf(String text, TextStyle style) =>
        (TextPainter(text: TextSpan(text: text, style: style), textDirection: TextDirection.ltr)..layout()).width;
    final width = widthOf('$count+', num) + widthOf(label, caption);
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: revealed ? count.toDouble() : 0),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, v, _) => Text('${v.round()}+', style: num),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(label, style: caption),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Career timeline
// ===========================================================================

class _Job {
  final String title;
  final String url;
  final String date;
  final String place;
  final List<Object> body; // String / TextSpan parts, '\n' for <br />
  final List<String> tags;
  const _Job(this.title, this.url, this.date, this.place, this.body, this.tags);
}

const _bold = TextStyle(fontWeight: FontWeight.w700);

final _jobs = <_Job>[
  const _Job(
    'Flutter Engineer — Rokkun Systems',
    'https://',
    'Jan 2026 – Present',
    'Bengaluru, India · Full-time',
    [
      'Leading mobile application development for Rentify, a Dubai-based fintech platform modernizing rental '
          'payments and property management. I own the app end-to-end — from planning and design through '
          'development to deployment on the App Store and Google Play.\nThe app lets tenants pay rent monthly with '
          'secure digital transactions and earn rewards redeemable across 200+ partner brands, while landlords '
          'receive rent upfront through banking partners. Recognized as "Startup of the Year" at the Finance '
          'Middle East Awards 2025.',
    ],
    [
      'Flutter',
      'Mobile Architecture',
      'UI/UX Design',
      'API Integration',
      'State Management',
      'CI/CD & Deployment',
      'Team Leadership'
    ],
  ),
  const _Job(
    'Founder & Lead Engineer — Sameens',
    'https://sameens.com',
    'Oct 2023 – Present',
    'Bengaluru, Karnataka',
    [
      'Founded and built Sameens, an online store for bags and accessories, as two Flutter apps: a customer '
          'storefront for Android, iOS and web from a single codebase, and a Flutter Web admin dashboard for '
          'products, orders, transactions, customers, notifications and analytics. Built the full purchase flow — '
          'catalogue, cart, Razorpay checkout, order tracking and PDF invoices — with one shared invoice renderer '
          'so the admin and customer always see the identical document. Customers get an order confirmation email '
          'through Brevo. The dashboard also has an internal chatbot powered by Gemini 3.7 Flash and a feedback '
          'system where admins and managers can raise requirements, bugs and enhancement requests.\n',
      TextSpan(text: 'Tech stack:', style: _bold),
      ' Flutter, Dart, Firebase (Firestore), Google Apps Script backend, Razorpay, Brevo, Gemini 3.7 Flash, '
          'flutter_bloc, get_it, fpdart.\n',
      TextSpan(text: 'Approach:', style: _bold),
      ' Both apps follow the same clean architecture, with BLoC for state, dependency injection and typed error '
          'handling. Payment secrets and all privileged writes live on the Apps Script backend, never in the '
          'client. A three-tier role model (super admin / admin / manager) is enforced both in the UI and on the '
          'server. Dev, staging and prod build flavors each point to their own Firebase project and backend, with '
          'a visible banner on non-prod builds. Deployments run through GitHub Actions CI/CD pipelines that '
          'authenticate with Google service accounts. Backed by 300+ unit, bloc and widget tests, including layout '
          'tests across screen sizes and text scales, and nine architecture and operations guides.',
    ],
    [
      'Flutter',
      'Dart',
      'Firebase',
      'Google Apps Script',
      'Razorpay',
      'Clean Architecture',
      'BLoC',
      'GitHub Actions',
      'Gemini AI',
      'Brevo',
      'Testing'
    ],
  ),
  const _Job(
    'Flutter Developer — Intertec Systems',
    'https://intertecsystems.com',
    'July 2025 – Dec 2025',
    'Dubai, UAE · Remote',
    [
      'Senior Flutter Developer on an enterprise application for Nama Water Services (NWS), an Oman Government '
          'entity (formerly OWWSC). Contributed across the full development lifecycle — from requirement analysis '
          'and BRD/CR implementation to testing, deployment and production support.\nCollaborated with '
          'cross-functional teams to deliver feature modules, managed source control on Microsoft Azure, conducted '
          'code reviews, wrote unit tests, and mentored junior developers within an Agile/Scrum workflow.',
    ],
    [
      'Flutter',
      'Enterprise Applications',
      'Azure DevOps',
      'Agile / Scrum',
      'Jira',
      'Unit Testing',
      'Code Review',
      'Mentoring'
    ],
  ),
  const _Job(
    'Flutter Developer — iBuild Software Solutions',
    'https://ibuild.in',
    'Jul 2022 – Jun 2025',
    'Bengaluru, Karnataka · Full-time',
    [
      'Successfully integrated ERP systems into mobile applications. The app contains features like updating '
          'attendance, real-time location tracking, admin access, background tasks, getting attendance details, '
          'etc.\nDeveloped an integrated system, known as the Intranet System, which facilitates real-time '
          'communication among users within a closed network using Socket.IO.',
    ],
    ['Flutter', 'Software Development', 'Project Management', 'API Integration', 'State Management', 'Teamwork'],
  ),
  const _Job(
    'Sales Associate — Sameer Collections',
    'https://sameens.com',
    'Jan 2010 – Present',
    'Bengaluru, Karnataka · Part-time',
    [
      'Accumulated over fifteen years of experience in sales at a retail establishment operated by my family. '
          "This business specializes in the retail sale of men's clothing, school bags, travel bags, women's "
          "handbags, clutches, men's accessories, and handlooms.",
    ],
    ['Sales', 'Sales Management', 'Sales Operations', 'Direct Sales', 'Retail Sales'],
  ),
  const _Job(
    'Flutter Developer — Madvistara Software Solutions',
    'https://thecompanycheck.com/company/madvistara-private-limited/U72900KA2022PTC159416',
    'Jan 2022 – Jun 2022',
    'Bengaluru, Karnataka · Full-time',
    [
      'Built and integrated mobile app features with cloud services and REST APIs, focusing on data persistence '
          'and reliable API communication.',
    ],
    ['Firebase', 'Postman API', 'Flutter', 'API Integration', 'Database'],
  ),
  const _Job(
    'Front End Developer Trainee — REFORMX',
    'https://linkedin.com/company/reformx/posts/?feedView=all',
    'Sep 2021 – Jan 2022',
    'Bengaluru, Karnataka · Internship',
    [
      'Successfully completed an internship and gained hands-on experience in developing websites using HTML, '
          'CSS, Bootstrap and JavaScript. Completed 3–4 projects based on this.',
    ],
    ['Bootstrap', 'HTML5', 'Front-End Development', 'JavaScript', 'CSS'],
  ),
];

class SimpleCareer extends StatelessWidget {
  const SimpleCareer({super.key});

  @override
  Widget build(BuildContext context) {
    final bp = SBp.of(context);
    return Padding(
      padding: _sectionPadding(bp, top: 0),
      child: SMaxWidth(
        child: Column(
          children: [
            const STitle('Career', 'where I work'),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Stack(
                  children: [
                    // .timeline::before — vertical gradient line
                    Positioned(
                      left: 7,
                      top: 6,
                      bottom: 6,
                      width: 2,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [SC.primary, Color(0x2619C6A4)],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 34),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [for (final j in _jobs) Reveal(child: _TimelineItem(job: j))],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final _Job job;
  const _TimelineItem({required this.job});

  @override
  Widget build(BuildContext context) {
    final bp = SBp.of(context);
    final title = SHover(
      onTap: () => openUrl(job.url),
      builder: (context, hovered) =>
          Text(job.title, style: sHead(bp.le560 ? 17 : 19, color: hovered ? SC.primaryDark : SC.ink)),
    );
    final date = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: SC.primarySoft, borderRadius: BorderRadius.circular(999)),
      child: Text(job.date, softWrap: false, style: sBody(13, weight: FontWeight.w600, color: SC.primaryDark)),
    );
    final bodyStyle = sBody(15, color: SC.inkSoft);

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SHover(
            builder: (context, hovered) => AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: SC.ease,
              transform: Matrix4.translationValues(0, hovered ? -4 : 0, 0),
              padding: bp.le560 ? const EdgeInsets.all(20) : const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
              decoration: BoxDecoration(
                color: SC.surface,
                borderRadius: BorderRadius.circular(SC.radius),
                border: Border.all(color: hovered ? const Color(0x6619C6A4) : SC.line),
                boxShadow: hovered ? SC.shadowMd : SC.shadowSm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (bp.le560)
                    Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 6, children: [title, date])
                  else
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 16,
                      runSpacing: 8,
                      children: [title, date],
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 12),
                    child: Text(job.place, style: sBody(14, weight: FontWeight.w500, color: SC.inkSoft)),
                  ),
                  Text.rich(
                    TextSpan(children: [for (final p in job.body) p is TextSpan ? p : TextSpan(text: p as String)]),
                    style: bodyStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final t in job.tags)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
                            decoration: BoxDecoration(
                              color: SC.tagBg,
                              border: Border.all(color: SC.line),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(t, style: sBody(12.5, weight: FontWeight.w500, color: SC.inkSoft)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // .tl-dot
          Positioned(
            left: -34,
            top: 24,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: SC.primary,
                shape: BoxShape.circle,
                border: Border.all(color: SC.page, width: 3),
                boxShadow: const [BoxShadow(color: SC.primarySoft, spreadRadius: 4)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Qualification
// ===========================================================================

class SimpleEducation extends StatelessWidget {
  const SimpleEducation({super.key});

  @override
  Widget build(BuildContext context) {
    final bp = SBp.of(context);
    final education = _EduColumn(
      icon: FontAwesomeIcons.graduationCap,
      heading: 'Education',
      rows: const [
        ('Bachelor of Engineering (ECE)', 'Sambhram Institute of Technology', '2016–2021', '6.3 CGPA'),
        ('Pre University College (Science, PCME)', 'Mahesh PU College', '2014–2016', '76.58%'),
        ('Secondary School Leaving Certificate', 'Kiran High School', '2002–2014', '88.64%'),
      ],
    );
    final experience = _EduColumn(
      icon: FontAwesomeIcons.briefcase,
      heading: 'Internship & Experience',
      rows: const [
        ('Front End Development Trainee', 'ReformX Consulting Private Limited', '2021', null),
        ('Internet of Things (IoT)', 'ExpertsHub', '2019', null),
        ('Field Technician — Computing & Peripherals', 'Rooman Technologies (PMKVY)', '2018', null),
      ],
    );

    return Padding(
      padding: _sectionPadding(bp, top: 10),
      child: SMaxWidth(
        child: Column(
          children: [
            const STitle('Qualification', 'what I studied'),
            if (bp.le860)
              Column(
                spacing: 36,
                children: [
                  for (final c in [education, experience])
                    ConstrainedBox(constraints: const BoxConstraints(maxWidth: 500), child: Reveal(child: c)),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 36,
                children: [Expanded(child: Reveal(child: education)), Expanded(child: Reveal(child: experience))],
              ),
          ],
        ),
      ),
    );
  }
}

class _EduColumn extends StatelessWidget {
  final IconData icon;
  final String heading;
  final List<(String, String, String, String?)> rows;
  const _EduColumn({required this.icon, required this.heading, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: SC.surface,
        border: Border.all(color: SC.line),
        borderRadius: BorderRadius.circular(SC.radius),
        boxShadow: SC.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              spacing: 10,
              children: [
                FaIcon(icon, size: 22, color: SC.primary),
                Flexible(child: Text(heading, style: sHead(22))),
              ],
            ),
          ),
          for (var i = 0; i < rows.length; i++)
            Container(
              padding: EdgeInsets.only(top: 16, bottom: i == rows.length - 1 ? 0 : 16),
              decoration:
                  i == rows.length - 1 ? null : const BoxDecoration(border: Border(bottom: BorderSide(color: SC.line))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rows[i].$1, style: sHead(16)),
                        Text(rows[i].$2, style: sBody(14, weight: FontWeight.w500, color: SC.primaryDark)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(rows[i].$3, softWrap: false, style: sBody(14, color: SC.inkSoft)),
                      if (rows[i].$4 != null)
                        Text(rows[i].$4!, softWrap: false, style: sBody(14, weight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Skills
// ===========================================================================

class SimpleSkills extends StatelessWidget {
  const SimpleSkills({super.key});

  static const _left = [('Flutter', 90), ('PHP, SQL', 60), ('HTML, CSS, JS', 70), ('Node.JS', 80)];
  static const _right = [('Java', 70), ('Android', 60), ('XML', 80), ('Git', 80)];

  @override
  Widget build(BuildContext context) {
    final bp = SBp.of(context);
    Widget column(List<(String, int)> bars) => Reveal(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 26,
            children: [for (final b in bars) _SkillBar(name: b.$1, percent: b.$2)],
          ),
        );

    return Padding(
      padding: _sectionPadding(bp, top: bp.le860 ? 0 : null, bottom: bp.le860 ? 120 : 190),
      child: SMaxWidth(
        child: Column(
          children: [
            const STitle('My Skills', 'what I know'),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: bp.le860
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 26,
                        children: [column(_left), column(_right)],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 60,
                        children: [Expanded(child: column(_left)), Expanded(child: column(_right))],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  final String name;
  final int percent;
  const _SkillBar({required this.name, required this.percent});

  @override
  Widget build(BuildContext context) {
    final revealed = RevealedNotifier.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: sBody(16, weight: FontWeight.w600)),
              Text('$percent%', style: sBody(16, weight: FontWeight.w600, color: SC.primaryDark)),
            ],
          ),
        ),
        Container(
          height: 8,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: SC.line, borderRadius: BorderRadius.circular(999)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: revealed ? percent / 100 : 0),
              duration: const Duration(milliseconds: 1400),
              curve: SC.ease,
              builder: (context, f, _) => FractionallySizedBox(
                widthFactor: f,
                heightFactor: 1,
                child: Container(
                  decoration: BoxDecoration(gradient: SC.gradient, borderRadius: BorderRadius.circular(999)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// Projects
// ===========================================================================

class _Project {
  final String title;
  final String badge;
  final String image;
  final String description;
  final String linkLabel;
  final String url;
  const _Project(this.title, this.badge, this.image, this.description, this.linkLabel, this.url);
}

const _projects = [
  _Project(
      'Sameens - Store',
      'Website',
      'sameens-logo.png',
      'A mobile and web e-commerce app built using Flutter and App scripts backend, delivering a seamless shopping experience.',
      'Visit site',
      'https://sameens.com'),
  _Project(
      'Sameens - Dashboard (Staging)',
      'Website',
      'sameens-logo.png',
      'An admin dashboard for managing products, orders, transactions, customers and analytics, with role-based access. Built with Flutter Web, Firebase and a Google Apps Script backend.',
      'Visit site',
      'https://staging-admin.sameens.com'),
  _Project(
      'Rentify',
      'Mobile',
      'rentify-logo.png',
      'A rental marketplace app that connects tenants and owners, making it easy to list, browse and rent properties.',
      'View on Play Store',
      'https://play.google.com/store/apps/details?id=com.rentify.rentifyApp&hl=en_IN'),
  _Project(
      'Nama Water',
      'Mobile',
      'nama-logo.png',
      'A water services app that lets customers manage their accounts, view bills and handle water-related requests on the go.',
      'View on Play Store',
      'https://play.google.com/store/apps/details?id=com.diamwaterproject&hl=en_IN'),
  _Project(
      'Handwriter',
      'Android',
      'project1.png',
      'A font-converter app that turns camera or gallery images into text files. Built with Java, XML, Firebase, Photoshop and Adobe XD.',
      'View on Play Store',
      'https://play.google.com/store/apps/details?id=com.xsar.handwriter'),
  _Project(
      'iTask — To Do List',
      'Android',
      'project2.png',
      'An Android app to plan daily tasks, with user login/logout and tasks stored in a realtime Firebase database.',
      'View on GitHub',
      'https://github.com/tabrezcool6/iTask-ToDoListApp'),
  _Project(
      'Connect — Web Chat API',
      'Website',
      'project3.png',
      'A real-time chat API built with JavaScript, Node server and Socket.IO, enabling users to communicate through accessible web interfaces.',
      'View on GitHub',
      'https://github.com/tabrezcool6/Connect--A-Web-Chat-API'),
];

class SimpleProjects extends StatelessWidget {
  const SimpleProjects({super.key});

  @override
  Widget build(BuildContext context) {
    final bp = SBp.of(context);
    final columns = bp.le560 ? 1 : (bp.le1024 ? 2 : 4);
    final cards = [for (final p in _projects) Reveal(child: _ProjectCard(project: p))];

    return Padding(
      padding: _sectionPadding(bp, top: 10),
      child: SMaxWidth(
        child: Column(
          children: [
            const STitle('My Projects', 'what I made'),
            LayoutBuilder(builder: (context, c) {
              if (columns == 1) {
                return Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: 24, children: cards);
              }
              final cell = (c.maxWidth - 24 * (columns - 1)) / columns;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 24,
                children: [
                  for (var i = 0; i < cards.length; i += columns)
                    EqualHeightRow(
                      widths: List.filled(math.min(columns, cards.length - i), cell),
                      gap: 24,
                      children: cards.sublist(i, math.min(i + columns, cards.length)),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final _Project project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return SHover(
      onTap: () => openUrl(project.url),
      builder: (context, hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: SC.ease,
        transform: Matrix4.translationValues(0, hovered ? -8 : 0, 0),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: SC.surface,
          border: Border.all(color: hovered ? const Color(0x7319C6A4) : SC.line),
          borderRadius: BorderRadius.circular(SC.radius),
          boxShadow: hovered ? SC.shadowLg : SC.shadowSm,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 130,
                  margin: const EdgeInsets.only(bottom: 16),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      // linear-gradient(160deg, primary-soft, transparent)
                      begin: Alignment(-0.34, -0.94),
                      end: Alignment(0.34, 0.94),
                      colors: [SC.primarySoft, Color(0x0019C6A4)],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: AnimatedScale(
                    scale: hovered ? 1.08 : 1,
                    duration: const Duration(milliseconds: 400),
                    curve: SC.ease,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 90, maxHeight: 100),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset('assets/simple/${project.image}', semanticLabel: project.title),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(project.title, style: sHead(17)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(color: SC.primarySoft, borderRadius: BorderRadius.circular(999)),
                        child: Text(project.badge, style: sBody(12, weight: FontWeight.w600, color: SC.primaryDark)),
                      ),
                    ],
                  ),
                ),
                Text(project.description, style: sBody(13.5, color: SC.inkSoft)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Row(
                spacing: 6,
                children: [
                  Text(project.linkLabel, style: sBody(14, weight: FontWeight.w600, color: SC.primaryDark)),
                  AnimatedSlide(
                    offset: Offset(hovered ? 5 / 14 : 0, 0),
                    duration: const Duration(milliseconds: 300),
                    curve: SC.ease,
                    child: const FaIcon(FontAwesomeIcons.arrowRight, size: 14, color: SC.primaryDark),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// Contact (form → mail app)
// ===========================================================================

/// Destination address for the contact form.
const contactEmail = 'dev.tabrez6@gmail.com';

/// mailto: link that opens the visitor's mail app with the form pre-filled.
String buildContactMailto(
    {required String name, required String email, required String subject, required String message}) {
  final body = "Hello Syed, I'd like to get in touch.\n\n"
      'Name: $name\n'
      'Email: $email\n\n'
      'Message:\n$message';
  // Uri.encodeComponent (not queryParameters) so spaces become %20, not '+'.
  return 'mailto:$contactEmail'
      '?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
}

class SimpleContact extends StatefulWidget {
  const SimpleContact({super.key});

  @override
  State<SimpleContact> createState() => _SimpleContactState();
}

class _SimpleContactState extends State<SimpleContact> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _subject = TextEditingController();
  final _message = TextEditingController();
  final _focus = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in [_name, _email, _subject, _message]) {
      c.dispose();
    }
    for (final f in _focus) {
      f.dispose();
    }
    super.dispose();
  }

  void _submit() {
    final values = [_name, _email, _subject, _message].map((c) => c.text.trim()).toList();
    // `required` fields: like the browser, stop at the first empty one.
    final firstEmpty = values.indexWhere((v) => v.isEmpty);
    if (firstEmpty != -1) {
      _focus[firstEmpty].requestFocus();
      return;
    }
    openUrl(buildContactMailto(name: values[0], email: values[1], subject: values[2], message: values[3]));
  }

  @override
  Widget build(BuildContext context) {
    final bp = SBp.of(context);
    final heading = sHead(22);

    final left = Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(bottom: 12), child: Text('Get in touch', style: heading)),
          Text(
            "If you need to know more details about me or have any questions, please feel free to drop me a message. "
            "I'll get back to you as soon as I can.",
            style: sBody(16, color: SC.inkSoft),
          ),
          const SizedBox(height: 26),
          for (final r in const [
            (FontAwesomeIcons.solidUser, 'Name', 'Syed Tabrez Pasha S'),
            (FontAwesomeIcons.locationDot, 'Address', 'Bangalore, Karnataka'),
            (FontAwesomeIcons.solidEnvelope, 'E-mail', 'dev.tabrez6@gmail.com'),
          ])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                spacing: 18,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: SC.primarySoft, borderRadius: BorderRadius.circular(12)),
                    child: FaIcon(r.$1, size: 18, color: SC.primaryDark),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.$2, style: sBody(15, weight: FontWeight.w600)),
                        Text(r.$3, style: sBody(14, color: SC.inkSoft)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );

    final nameField = SInput(controller: _name, focusNode: _focus[0], hint: 'Enter your name');
    final emailField = SInput(
        controller: _email, focusNode: _focus[1], hint: 'Enter your e-mail', keyboardType: TextInputType.emailAddress);

    final right = Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(padding: const EdgeInsets.only(bottom: 12), child: Text('Message me', style: heading)),
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: SC.surface,
              border: Border.all(color: SC.line),
              borderRadius: BorderRadius.circular(SC.radius),
              boxShadow: SC.shadowSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (bp.le560) ...[
                  Padding(padding: const EdgeInsets.only(bottom: 16), child: nameField),
                  Padding(padding: const EdgeInsets.only(bottom: 16), child: emailField),
                ] else
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      spacing: 16,
                      children: [Expanded(child: nameField), Expanded(child: emailField)],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SInput(controller: _subject, focusNode: _focus[2], hint: 'Subject'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SInput(controller: _message, focusNode: _focus[3], hint: 'Describe project...', lines: 6),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SButton.primary(
                    'Send message',
                    icon: FontAwesomeIcons.solidPaperPlane,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    onTap: _submit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: _sectionPadding(bp, top: 0),
      child: SMaxWidth(
        child: Column(
          children: [
            const STitle('Contact Me', 'get in touch'),
            if (bp.le860)
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: 50, children: [left, right])
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Expanded(child: left), const SizedBox(width: 50), Expanded(child: right)],
              ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// Footer
// ===========================================================================

class SimpleFooter extends StatelessWidget {
  final VoidCallback onLogoTap;
  const SimpleFooter({super.key, required this.onLogoTap});

  @override
  Widget build(BuildContext context) {
    final bp = SBp.of(context);
    final children = [
      SimpleLogo(onTap: onLogoTap, dark: true),
      Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          for (final s in simpleSocials)
            SHover(
              onTap: () => openUrl(s.$2),
              builder: (context, hovered) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: SC.ease,
                transform: Matrix4.translationValues(0, hovered ? -3 : 0, 0),
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hovered ? SC.primary : Colors.white.withValues(alpha: 0.06),
                ),
                child: FaIcon(s.$1, size: 17, color: hovered ? Colors.white : SC.footerText),
              ),
            ),
        ],
      ),
      Text('© ${DateTime.now().year} Syed Tabrez Pasha S. All Rights Reserved.',
          textAlign: bp.le560 ? TextAlign.center : TextAlign.start, style: sBody(14, color: SC.footerText)),
    ];

    return Container(
      color: SC.bg,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: SMaxWidth(
        child: bp.le560
            ? Column(spacing: 20, children: children)
            : Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: children,
              ),
      ),
    );
  }
}

/// `.logo`: "Tabrez" + ".in" (the "in" at 0.8em), Sora 26/800.
class SimpleLogo extends StatelessWidget {
  final VoidCallback onTap;
  final bool dark;
  const SimpleLogo({super.key, required this.onTap, this.dark = false});

  @override
  Widget build(BuildContext context) {
    final style = sHead(26, weight: FontWeight.w800, letterSpacing: -0.02, color: dark ? Colors.white : SC.ink);
    return SHover(
      onTap: onTap,
      builder: (context, _) => Text.rich(
        TextSpan(text: 'Tabrez', children: [
          TextSpan(text: '.', style: style.copyWith(color: SC.primary)),
          TextSpan(text: 'in', style: style.copyWith(color: SC.primary, fontSize: 26 * 0.8)),
        ]),
        style: style,
      ),
    );
  }
}

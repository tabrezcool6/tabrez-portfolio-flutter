import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/apple_theme.dart';
import '../../data/portfolio_data.dart';
import 'common.dart';
import 'device_mockup_widget.dart';

/// Apple keynote hero (src/components/Hero.tsx).
class HeroSection extends StatelessWidget {
  final VoidCallback onOpenContact;
  final VoidCallback onExploreProjects;

  const HeroSection({super.key, required this.onOpenContact, required this.onExploreProjects});

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);

    return ClipRect(
      child: Stack(
        children: [
          // Ambient lighting: blue-600/15 → indigo-600/10 → transparent, blur 120px.
          Positioned.fill(
            child: IgnorePointer(
              child: LayoutBuilder(builder: (context, c) {
                final w = bp.v(600.0, sm: 900.0);
                final h = bp.v(400.0, sm: 550.0);
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: c.maxWidth / 2 - w / 2,
                      top: c.maxHeight / 4 - h / 2,
                      width: w,
                      height: h,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 120, sigmaY: 120, tileMode: TileMode.decal),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.elliptical(w / 2, h / 2)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Tw.blue600.withValues(alpha: 0.15),
                                Tw.indigo600.withValues(alpha: 0.10),
                                Tw.indigo600.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: bp.v(96.0, sm: 128.0), bottom: bp.v(64.0, sm: 96.0)),
            child: PageContainer(
              child: Column(
                children: [
                  _headline(context, bp),
                  SizedBox(height: bp.v(48.0, sm: 64.0)),
                  const DeviceMockup(),
                  SizedBox(height: bp.v(64.0, sm: 96.0)),
                  _stats(bp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headline(BuildContext context, Bp bp) {
    final h1 = tw(bp.v(TwSize.x4, sm: TwSize.x6, md: TwSize.x7),
        weight: FontWeight.w700, color: Tw.white, tracking: Tracking.tight, leading: 1.08);
    final body = tw(bp.v(TwSize.lg, sm: TwSize.xl), color: Tw.neutral400, leading: Leading.relaxed);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 896),
      child: Column(
        spacing: bp.v(16.0, sm: 24.0),
        children: [
          // Kicker
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Tw.w(0.06),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Tw.w(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                const Dot(size: 8, color: Tw.emerald400, pulse: true),
                Text('Flutter Engineer · Rokkun Bengaluru',
                    style: tw(TwSize.xs, weight: FontWeight.w500, color: Tw.neutral300)),
              ],
            ),
          ),

          // Display headline with titanium sheen
          if (bp.sm)
            Column(children: [
              Text('Mobile Engineering.', textAlign: TextAlign.center, style: h1),
              GradientText('Down to the pixel.', textAlign: TextAlign.center, style: h1),
            ])
          else
            LayoutBuilder(builder: (context, c) {
              final rect = Rect.fromLTWH(0, 0, c.maxWidth, h1.fontSize! * 1.08 * 3);
              return BalancedText(
                TextSpan(text: 'Mobile Engineering. ', children: [
                  TextSpan(
                    text: 'Down to the pixel.',
                    style: h1.copyWith(
                      color: null,
                      foreground: Paint()..shader = cssLinearGradient(rect, 135, titaniumColors, titaniumStops),
                    ),
                  ),
                ]),
                textAlign: TextAlign.center,
                style: h1,
              );
            }),

          // Sub-headline
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 672),
            child: BalancedText(
              TextSpan(text: "Hi, I'm ", children: [
                TextSpan(text: PersonalInfo.name, style: body.copyWith(color: Tw.white, fontWeight: FontWeight.w500)),
                const TextSpan(
                    text:
                        '. I architect buttery, high-refresh cross-platform mobile experiences with Flutter, Dart, Clean Architecture, and Native Android.'),
              ]),
              textAlign: TextAlign.center,
              style: body,
            ),
          ),

          // Primary actions
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: bp.v(12.0, sm: 16.0),
              runSpacing: bp.v(12.0, sm: 16.0),
              children: [
                PressScale(
                  child: Hover(
                    onTap: onExploreProjects,
                    builder: (context, hovered) => AnimatedContainer(
                      duration: twDuration,
                      curve: twCurve,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: hovered ? Tw.blue500 : Tw.blue600,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: TwShadow.lg(
                            hovered ? Tw.blue500.withValues(alpha: 0.4) : Tw.blue600.withValues(alpha: 0.25)),
                      ),
                      child:
                          Text('Explore Applications', style: tw(TwSize.sm, weight: FontWeight.w500, color: Tw.white)),
                    ),
                  ),
                ),
                PressScale(
                  child: Hover(
                    onTap: onOpenContact,
                    builder: (context, hovered) => AnimatedContainer(
                      duration: twDuration,
                      curve: twCurve,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: hovered ? Tw.neutral800 : Tw.neutral900,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Tw.w(hovered ? 0.2 : 0.1)),
                      ),
                      child: Text('Connect with Tabrez',
                          style: tw(TwSize.sm, weight: FontWeight.w500, color: hovered ? Tw.white : Tw.neutral200)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stats(Bp bp) {
    final align = bp.md ? CrossAxisAlignment.start : CrossAxisAlignment.center;
    final textAlign = bp.md ? TextAlign.left : TextAlign.center;
    return Container(
      padding: const EdgeInsets.only(top: 48),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Tw.w(0.1)))),
      child: TwGrid(
        columns: bp.v(2, md: 4),
        gapX: bp.v(24.0, sm: 32.0),
        gapY: bp.v(24.0, sm: 32.0),
        stretch: false,
        children: [
          for (final s in stats)
            Column(
              crossAxisAlignment: align,
              spacing: 4,
              children: [
                Text(s.value,
                    textAlign: textAlign,
                    style: tw(bp.v(TwSize.x3, sm: TwSize.x4),
                        weight: FontWeight.w800, color: Tw.white, tracking: Tracking.tight, mono: true, tabular: true)),
                Text(s.label,
                    textAlign: textAlign,
                    style: tw(bp.v(TwSize.xs, sm: TwSize.sm), weight: FontWeight.w600, color: Tw.neutral300)),
                Text(s.subtext, textAlign: textAlign, style: tw(TwSize.xs, color: Tw.neutral500)),
              ],
            ),
        ],
      ),
    );
  }
}

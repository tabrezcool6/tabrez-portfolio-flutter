import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/apple_theme.dart';
import '../../data/portfolio_data.dart';
import 'common.dart';

/// Section ids used by the navbar, footer and hero buttons.
const navLinks = [
  ('Overview', 'overview'),
  ('Engineering', 'engineering'),
  ('Projects', 'projects'),
  ('Architecture', 'architecture'),
  ('Experience', 'experience'),
  ('Contact', 'contact'),
];

/// Apple frosted navbar (src/components/Navbar.tsx header).
class AppleNavbar extends StatelessWidget {
  final bool scrolled;
  final bool menuOpen;
  final ValueChanged<String> onNavigate;
  final VoidCallback onOpenContact;
  final VoidCallback onToggleMenu;

  const AppleNavbar({
    super.key,
    required this.scrolled,
    required this.menuOpen,
    required this.onNavigate,
    required this.onOpenContact,
    required this.onToggleMenu,
  });

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);
    final solid = scrolled || menuOpen;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: twCurve,
      decoration: BoxDecoration(boxShadow: solid ? TwShadow.lg(Tw.black.withValues(alpha: 0.4)) : null),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: solid ? 24 : 12, sigmaY: solid ? 24 : 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: twCurve,
            height: 48,
            decoration: BoxDecoration(
              color: Tw.black.withValues(alpha: solid ? 0.85 : 0.4),
              border: Border(bottom: BorderSide(color: Tw.w(solid ? 0.1 : 0.05))),
            ),
            child: PageContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Zone 1: brand wordmark
                  Hover(
                    onTap: () => onNavigate('overview'),
                    builder: (context, hovered) => Text.rich(
                      TextSpan(text: 'Tabrez', children: [
                        TextSpan(text: '.in', style: tw(TwSize.sm, weight: FontWeight.w600, tracking: Tracking.tight, color: Tw.blue400)),
                      ]),
                      style: tw(TwSize.sm,
                          weight: FontWeight.w600,
                          tracking: Tracking.tight,
                          color: hovered ? Tw.neutral300 : Tw.white),
                    ),
                  ),

                  // Zone 2: text navigation links
                  if (bp.md)
                    Row(
                      spacing: 28,
                      children: [
                        for (final link in navLinks)
                          Hover(
                            onTap: () => onNavigate(link.$2),
                            builder: (context, hovered) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(link.$1,
                                  style: tw(TwSize.xs,
                                      weight: FontWeight.w500, color: hovered ? Tw.white : Tw.neutral400)),
                            ),
                          ),
                      ],
                    ),

                  // Zone 3: primary actions
                  Row(
                    spacing: 12,
                    children: [
                      if (bp.sm) _GetInTouchButton(scrolled: scrolled, onTap: onOpenContact),
                      if (!bp.md)
                        Hover(
                          onTap: onToggleMenu,
                          builder: (context, hovered) => Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(menuOpen ? LucideIcons.x : LucideIcons.menu,
                                size: 20, color: hovered ? Tw.white : Tw.neutral400),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GetInTouchButton extends StatelessWidget {
  final bool scrolled;
  final VoidCallback onTap;
  const _GetInTouchButton({required this.scrolled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Hover(
      onTap: onTap,
      builder: (context, hovered) {
        final bg = scrolled ? (hovered ? Tw.blue500 : Tw.blue600) : (hovered ? Tw.neutral200 : Tw.white);
        final fg = scrolled ? Tw.white : Tw.black;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: twCurve,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            boxShadow: scrolled ? TwShadow.md(Tw.blue600.withValues(alpha: 0.3)) : TwShadow.sm(),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              Text('Get in Touch', style: tw(TwSize.xs, weight: FontWeight.w500, color: fg)),
              Icon(LucideIcons.arrowUpRight, size: 12, color: fg),
            ],
          ),
        );
      },
    );
  }
}

/// Full-screen mobile menu shown below the navbar (`fixed inset-0 top-12`).
class MobileMenu extends StatelessWidget {
  final ValueChanged<String> onNavigate;
  final VoidCallback onOpenContact;

  const MobileMenu({super.key, required this.onNavigate, required this.onOpenContact});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          color: Tw.black.withValues(alpha: 0.95),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    Text('NAVIGATION',
                        style: tw(TwSize.px(11), mono: true, color: Tw.neutral500, tracking: Tracking.widest)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        for (final link in navLinks)
                          Hover(
                            onTap: () => onNavigate(link.$2),
                            builder: (context, hovered) => Text(link.$1,
                                style: tw(TwSize.x2,
                                    weight: FontWeight.w600,
                                    tracking: Tracking.tight,
                                    color: hovered ? Tw.white : Tw.neutral200)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 24),
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Tw.w(0.1)))),
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(PersonalInfo.location, style: tw(TwSize.xs, color: Tw.neutral400)),
                        Text('Available for projects', style: tw(TwSize.xs, mono: true, color: Tw.emerald400)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: PressScale(
                        scale: 0.98,
                        child: Hover(
                          onTap: onOpenContact,
                          builder: (context, _) => Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(color: Tw.white, borderRadius: BorderRadius.circular(12)),
                            alignment: Alignment.center,
                            child: Text('Connect with Tabrez',
                                style: tw(TwSize.sm, weight: FontWeight.w600, color: Tw.black)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 24,
                        children: [
                          _social(LucideIcons.github, PersonalInfo.github),
                          _social(LucideIcons.linkedin, PersonalInfo.linkedin),
                          _social(LucideIcons.mail, 'mailto:${PersonalInfo.email}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _social(IconData icon, String url) {
    return Hover(
      onTap: () => openUrl(url),
      builder: (context, hovered) => Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 20, color: hovered ? Tw.white : Tw.neutral400),
      ),
    );
  }
}

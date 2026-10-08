import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/apple_theme.dart';
import '../../data/portfolio_data.dart';
import 'common.dart';

/// Apple "compare models" capabilities matrix (src/components/CompareMatrix.tsx).
class CompareSection extends StatefulWidget {
  const CompareSection({super.key});

  @override
  State<CompareSection> createState() => _CompareSectionState();
}

class _CompareSectionState extends State<CompareSection> {
  int _selected = 0;
  final _tabScroll = ScrollController();
  final _tabViewportKey = GlobalKey();
  late final _tabKeys = List.generate(skillCategories.length, (_) => GlobalKey());

  @override
  void dispose() {
    _tabScroll.dispose();
    super.dispose();
  }

  void _select(int i) {
    setState(() => _selected = i);
    // On small screens, slide the tapped tab to the center of the strip.
    if (Bp.of(context).md) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerTab(i));
  }

  void _centerTab(int i) {
    if (!_tabScroll.hasClients) return;
    final tab = _tabKeys[i].currentContext?.findRenderObject() as RenderBox?;
    final viewport = _tabViewportKey.currentContext?.findRenderObject() as RenderBox?;
    if (tab == null || viewport == null) return;
    final tabCenter = tab.localToGlobal(tab.size.center(Offset.zero), ancestor: viewport).dx;
    final delta = tabCenter - viewport.size.width / 2;
    final position = _tabScroll.position;
    final target = (position.pixels + delta).clamp(position.minScrollExtent, position.maxScrollExtent);
    _tabScroll.animateTo(target, duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);
    final category = skillCategories[_selected];

    return Section(
      borderTop: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 48,
        children: [
          const Center(
            child: SectionHeader(
              kicker: 'Compare Capabilities',
              title: 'Which technology fits your app?',
              subtitle: 'Explore architectural depth.',
              body: "Compare proficiencies, execution paradigms, and production applications across Tabrez's toolkit.",
              centered: true,
            ),
          ),
          Column(
            spacing: 16,
            children: [
              SingleChildScrollView(
                key: _tabViewportKey,
                controller: _tabScroll,
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Tw.neutral900,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Tw.w(0.1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < skillCategories.length; i++)
                        Hover(
                          key: _tabKeys[i],
                          onTap: () => _select(i),
                          builder: (context, hovered) {
                            final active = i == _selected;
                            return AnimatedContainer(
                              duration: twDuration,
                              curve: twCurve,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: active ? Tw.white : Tw.white.withValues(alpha: 0),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: active ? TwShadow.md() : null,
                              ),
                              child: Text(skillCategories[i].title,
                                  style: tw(TwSize.xs,
                                      weight: active ? FontWeight.w600 : FontWeight.w500,
                                      color: active ? Tw.black : (hovered ? Tw.white : Tw.neutral400))),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              Text(category.subtitle,
                  textAlign: TextAlign.center, style: tw(TwSize.xs, mono: true, color: Tw.neutral400)),
            ],
          ),
          TwGrid(
            columns: bp.v(1, sm: 2, lg: 3, xl: 4),
            gapX: 24,
            gapY: 24,
            children: [for (final item in category.items) _SkillCard(item: item)],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'All engineering solutions follow strict S.O.L.I.D principles and unit/widget test verification.',
              textAlign: TextAlign.center,
              style: tw(TwSize.xs, color: Tw.neutral500),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final SkillItem item;
  const _SkillCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return TwCard(
      padding: const EdgeInsets.all(24),
      child: Builder(builder: (context) {
        final hovered = HoverScope.of(context);
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.experience, style: tw(TwSize.px(11), mono: true, color: Tw.neutral400)),
                    Text(item.level,
                        style: tw(TwSize.px(11), mono: true, weight: FontWeight.w600, color: Tw.blue400)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: twDuration,
                      style: tw(TwSize.lg,
                          weight: FontWeight.w700,
                          tracking: Tracking.tight,
                          color: hovered ? Tw.blue400 : Tw.white),
                      child: Text(item.name),
                    ),
                    Text(item.description,
                        style: tw(TwSize.xs, color: Tw.neutral400, leading: Leading.relaxed)),
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 24),
              padding: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Tw.w(0.05)))),
              child: Row(
                spacing: 8,
                children: [
                  const Icon(LucideIcons.check, size: 16, color: Tw.emerald400),
                  Text('Production Ready', style: tw(TwSize.xs, color: Tw.neutral300)),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/apple_theme.dart';
import '../../data/portfolio_data.dart';
import 'common.dart';
import 'project_modal.dart';

/// Featured projects lineup (src/components/ProjectShowcase.tsx).
class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  static const _categories = ['All', 'Mobile', 'Website'];
  String _active = 'All';

  List<Project> get _filtered {
    if (_active == 'All') return projects;
    if (_active == 'Mobile') {
      return projects
          .where((p) =>
              p.category == 'Mobile' ||
              p.category == 'Android' ||
              (p.badges?.contains('Mobile') ?? false) ||
              (p.badges?.contains('Android') ?? false))
          .toList();
    }
    return projects.where((p) => p.category == _active || (p.badges?.contains(_active) ?? false)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);

    const header = SectionHeader(
      kicker: 'Featured Work',
      title: 'The Product Lineup.',
      subtitle: 'Engineered for production.',
      body: 'Explore open-source architectures, native integrations, and responsive Flutter applications.',
      maxWidth: 672,
    );

    return Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 48,
        children: [
          if (bp.md)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 24,
              children: [const Flexible(child: header), _filterTabs(stretch: false)],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 24,
              children: [header, _filterTabs(stretch: true)],
            ),
          TwGrid(
            columns: bp.v(1, md: 2, lg: 3),
            gapX: bp.v(24.0, sm: 32.0),
            gapY: bp.v(24.0, sm: 32.0),
            children: [for (final p in _filtered) _ProjectCard(project: p)],
          ),
        ],
      ),
    );
  }

  Widget _filterTabs({required bool stretch}) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Tw.neutral900.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Tw.w(0.1)),
      ),
      child: Row(
        mainAxisSize: stretch ? MainAxisSize.max : MainAxisSize.min,
        spacing: 4,
        children: [
          for (final cat in _categories)
            Hover(
              onTap: () => setState(() => _active = cat),
              builder: (context, hovered) {
                final active = _active == cat;
                return AnimatedContainer(
                  duration: twDuration,
                  curve: twCurve,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: active ? Tw.white : Tw.white.withValues(alpha: 0),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: active ? TwShadow.sm() : null,
                  ),
                  child: Text(cat,
                      style: tw(TwSize.xs,
                          weight: active ? FontWeight.w600 : FontWeight.w500,
                          color: active ? Tw.black : (hovered ? Tw.white : Tw.neutral400))),
                );
              },
            ),
        ],
      ),
    );
  }
}

Widget projectIcon(String name) {
  switch (name) {
    case 'ShoppingBag':
      return const Icon(LucideIcons.shoppingBag, size: 20, color: Tw.amber400);
    case 'LayoutDashboard':
      return const Icon(LucideIcons.layoutDashboard, size: 20, color: Tw.blue400);
    case 'Home':
      return const Icon(LucideIcons.house, size: 20, color: Tw.emerald400);
    case 'Droplets':
      return const Icon(LucideIcons.droplets, size: 20, color: Tw.cyan400);
    case 'FileText':
      return const Icon(LucideIcons.fileText, size: 20, color: Tw.rose400);
    case 'CheckCircle2':
      return const Icon(LucideIcons.circleCheck, size: 20, color: Tw.emerald400);
    case 'MessageSquare':
      return const Icon(LucideIcons.messageSquare, size: 20, color: Tw.purple400);
    default:
      return const Icon(LucideIcons.codeXml, size: 20, color: Tw.blue400);
  }
}

Widget actionIcon(String actionType) {
  switch (actionType) {
    case 'playstore':
      return const Icon(LucideIcons.smartphone, size: 14, color: Tw.emerald400);
    case 'website':
      return const Icon(LucideIcons.globe, size: 14, color: Tw.blue400);
    case 'github':
      return const Icon(LucideIcons.github, size: 14, color: Tw.neutral300);
    default:
      return const Icon(LucideIcons.externalLink, size: 14, color: Tw.blue400);
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);
    final p = project;
    void open() => showProjectModal(context, p);

    final badgeStyle = tw(TwSize.px(11), mono: true, weight: FontWeight.w500, color: Tw.neutral300);
    Widget badge(String text) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: Tw.w(0.05),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Tw.w(0.1)),
          ),
          child: Text(text, style: badgeStyle),
        );

    final techStyle = tw(TwSize.px(11), color: Tw.neutral300);
    final shownTech = p.technologies.take(4).toList();

    return TwCard(
      onTap: open,
      lift: true,
      hoverBorder: 0.25,
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(bp.v(24.0, sm: 28.0)),
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
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Tw.neutral900,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Tw.w(0.1)),
                      ),
                      child: projectIcon(p.iconName),
                    ),
                    Row(
                      spacing: 6,
                      children: [for (final b in p.badges ?? [p.category]) badge(b)],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: twDuration,
                      style: tw(TwSize.xl,
                          weight: FontWeight.w700,
                          tracking: Tracking.tight,
                          color: hovered ? Tw.blue400 : Tw.white),
                      child: Text(p.title),
                    ),
                    Text(p.tagline, style: tw(TwSize.xs, weight: FontWeight.w500, color: Tw.neutral400)),
                  ],
                ),
                Text(p.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: tw(bp.v(TwSize.xs, sm: TwSize.sm), color: Tw.neutral300, leading: Leading.relaxed)),
                if (p.metrics != null)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.symmetric(horizontal: BorderSide(color: Tw.w(0.05))),
                    ),
                    child: TwGrid(
                      columns: 3,
                      gapX: 8,
                      stretch: false,
                      children: [
                        for (final m in p.metrics!)
                          Column(
                            children: [
                              Text(m.value,
                                  textAlign: TextAlign.center,
                                  style: tw(TwSize.xs,
                                      weight: FontWeight.w700, color: Tw.white, mono: true, tabular: true)),
                              Text(m.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: tw(TwSize.px(10), color: Tw.neutral500)),
                            ],
                          ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: DotList(
                    items: shownTech,
                    style: techStyle,
                    dotColor: Tw.neutral600,
                    trailing: [
                      if (p.technologies.length > 4)
                        Text('+${p.technologies.length - 4}',
                            style: tw(TwSize.px(11), mono: true, color: Tw.neutral500)),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 24),
              padding: const EdgeInsets.only(top: 24),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Tw.w(0.05)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 12,
                children: [
                  Flexible(
                    child: Hover(
                      onTap: open,
                      builder: (context, h) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('Architecture & Details',
                            style: tw(TwSize.xs, color: h ? Tw.white : Tw.neutral400)),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 6,
                    children: [
                      _ActionLink(icon: actionIcon(p.actionType), label: p.actionLabel, url: p.projectUrl),
                      if (p.playStoreUrl != null)
                        _ActionLink(
                            icon: actionIcon('playstore'), label: 'View on Play Store', url: p.playStoreUrl!),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _ActionLink extends StatelessWidget {
  final Widget icon;
  final String label;
  final String url;
  const _ActionLink({required this.icon, required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return Hover(
      onTap: () => openUrl(url),
      builder: (context, hovered) => AnimatedContainer(
        duration: twDuration,
        curve: twCurve,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: hovered ? Tw.white : Tw.w(0.1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: TwShadow.sm(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            icon,
            Text(label,
                style: tw(TwSize.xs, weight: FontWeight.w600, color: hovered ? Tw.black : Tw.neutral200)),
            AnimatedSlide(
              duration: twDuration,
              offset: hovered ? const Offset(2 / 12, -2 / 12) : Offset.zero,
              child: Icon(LucideIcons.arrowUpRight, size: 12, color: hovered ? Tw.black : Tw.neutral200),
            ),
          ],
        ),
      ),
    );
  }
}

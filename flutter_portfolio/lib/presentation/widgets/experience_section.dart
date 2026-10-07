import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/apple_theme.dart';
import '../../data/portfolio_data.dart';
import 'common.dart';

const _months = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'];

/// Parses "Jul 2022" / "July 2025" / "Present" into a month index (year * 12 + month).
int? _toMonthIndex(String value) {
  final text = value.trim();
  if (text.toLowerCase() == 'present') {
    final now = DateTime.now();
    return now.year * 12 + now.month - 1;
  }
  final parts = text.split(RegExp(r'\s+'));
  if (parts.length < 2 || parts[0].length < 3) return null;
  final m = _months.indexOf(parts[0].substring(0, 3).toLowerCase());
  final y = int.tryParse(parts[1]);
  return m < 0 || y == null ? null : y * 12 + m;
}

/// "Jul 2022 – Jun 2025" → "3 years". Both the start and end months are counted.
String? formatDuration(String period) {
  final range = period.split(RegExp('[–-]'));
  if (range.length < 2) return null;
  final start = _toMonthIndex(range[0]);
  final end = _toMonthIndex(range[1]);
  if (start == null || end == null || end < start) return null;
  final total = end - start + 1;
  final years = total ~/ 12;
  final months = total % 12;
  return [
    if (years > 0) '$years ${years == 1 ? 'year' : 'years'}',
    if (months > 0) '$months ${months == 1 ? 'month' : 'months'}',
  ].join(', ');
}

/// Experience trajectory & Medium articles (src/components/ExperienceTimeline.tsx).
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);

    return Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 64,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: SectionHeader(
              kicker: 'Professional Trajectory',
              title: 'The Journey.',
              subtitle: 'From native Android to Flutter at scale.',
              body:
                  'Real engineering impact delivered in high-velocity teams, open-source communities, and technical publications.',
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 32,
            children: [for (final item in experience) _ExperienceCard(item: item)],
          ),
          _articles(bp),
        ],
      ),
    );
  }

  Widget _articles(Bp bp) {
    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text('TECHNICAL WRITING',
            style: tw(TwSize.xs, mono: true, color: Tw.emerald400, tracking: Tracking.widest)),
        Text('Published on Medium',
            style: tw(bp.v(TwSize.x2, sm: TwSize.x3),
                weight: FontWeight.w700, color: Tw.white, tracking: Tracking.tight)),
      ],
    );
    final follow = Hover(
      onTap: () => openUrl('https://medium.com/@tabrezcool6'),
      builder: (context, hovered) {
        final c = hovered ? Tw.blue300 : Tw.blue400;
        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Text('Follow on Medium', style: tw(TwSize.xs, weight: FontWeight.w600, color: c)),
            Icon(LucideIcons.arrowUpRight, size: 14, color: c),
          ],
        );
      },
    );

    return Container(
      padding: const EdgeInsets.only(top: 32),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Tw.w(0.1)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 24,
        children: [
          if (bp.sm)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [heading, follow],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [heading, follow],
            ),
          TwGrid(
            columns: bp.v(1, md: 2),
            gapX: 24,
            gapY: 24,
            children: [for (final a in articles) _ArticleCard(article: a)],
          ),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final ExperienceItem item;
  const _ExperienceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);
    final role = tw(TwSize.xl, weight: FontWeight.w700, color: Tw.white, tracking: Tracking.tight);
    final bulletStyle = tw(bp.v(TwSize.xs, sm: TwSize.sm), color: Tw.neutral400);

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(item.role, style: role),
            Text('at', style: tw(TwSize.base, color: Tw.neutral400)),
            if (item.companyUrl != null)
              Tooltip(
                message: 'Visit ${item.company}',
                waitDuration: const Duration(milliseconds: 600),
                child: Hover(
                  onTap: () => openUrl(item.companyUrl!),
                  builder: (context, hovered) => Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4,
                    children: [
                      Flexible(
                        child: Text(item.company,
                            style: role.copyWith(
                              color: hovered ? Tw.blue300 : Tw.blue400,
                              decoration: hovered ? TextDecoration.underline : null,
                              decorationColor: Tw.blue400.withValues(alpha: 0.4),
                            )),
                      ),
                      AnimatedSlide(
                        duration: twDuration,
                        offset: hovered ? const Offset(2 / 16, -2 / 16) : Offset.zero,
                        child: Icon(LucideIcons.arrowUpRight,
                            size: 16, color: hovered ? Tw.blue300 : Tw.blue400.withValues(alpha: 0.8)),
                      ),
                    ],
                  ),
                ),
              )
            else
              Text(item.company, style: role.copyWith(color: Tw.blue400)),
          ],
        ),
        DotList(
          items: [item.location, item.type],
          style: tw(TwSize.xs, color: Tw.neutral400),
          dotColor: Tw.neutral400,
        ),
      ],
    );

    final duration = formatDuration(item.period);
    final period = Column(
      crossAxisAlignment: bp.sm ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Tw.w(0.05),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Tw.w(0.1)),
          ),
          child: Text(item.period, style: tw(TwSize.xs, mono: true, color: Tw.neutral300)),
        ),
        if (duration != null)
          // mt-2 below an inline pill whose padding+border paint 5px past its line box;
          // px-[13px] lines the text up with the date inside the pill (12px padding + 1px border).
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 3, 13, 0),
            child: Text(duration,
                style: tw(TwSize(11, 16 / 12), mono: true, color: Tw.neutral500)),
          ),
      ],
    );

    return TwCard(
      padding: EdgeInsets.all(bp.v(24.0, sm: 32.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 20,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Tw.w(0.05)))),
            child: bp.sm
                ? Row(
                    spacing: 8,
                    children: [Expanded(child: titleBlock), period],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [titleBlock, period],
                  ),
          ),
          Text(item.summary, style: tw(TwSize.sm, color: Tw.neutral300, leading: Leading.relaxed)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              for (final b in item.bullets)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text('·',
                          style: bulletStyle.copyWith(color: Tw.blue400, fontWeight: FontWeight.w700)),
                    ),
                    Expanded(child: Text(b, style: bulletStyle)),
                  ],
                ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Tw.w(0.05)))),
            child: DotList(
              items: item.technologies,
              style: tw(TwSize.xs, color: Tw.neutral300),
              dotColor: Tw.neutral600,
              leading: [Text('Toolkit:', style: tw(TwSize.xs, mono: true, color: Tw.neutral500))],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final ArticleItem article;
  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);
    final a = article;

    return TwCard(
      onTap: () => openUrl(a.url),
      lift: true,
      hoverBorder: 0.25,
      padding: EdgeInsets.all(bp.v(24.0, sm: 28.0)),
      child: Builder(builder: (context) {
        final hovered = HoverScope.of(context);
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(a.platform,
                        style: tw(TwSize.xs, mono: true, weight: FontWeight.w500, color: Tw.emerald400)),
                    Text('·', style: tw(TwSize.xs, color: Tw.neutral400)),
                    Text(a.readTime, style: tw(TwSize.xs, color: Tw.neutral400)),
                  ],
                ),
                AnimatedDefaultTextStyle(
                  duration: twDuration,
                  style: tw(TwSize.lg,
                      weight: FontWeight.w700, leading: Leading.snug, color: hovered ? Tw.blue400 : Tw.white),
                  child: Text(a.title),
                ),
                Text(a.summary,
                    style: tw(bp.v(TwSize.xs, sm: TwSize.sm), color: Tw.neutral400, leading: Leading.relaxed)),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Tw.w(0.05)))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 2,
                      children: [
                        for (final t in a.topics)
                          Text('#$t', style: tw(TwSize.px(10), mono: true, color: Tw.neutral500)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedSlide(
                    duration: twDuration,
                    offset: hovered ? const Offset(0.02, 0) : Offset.zero,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        Text('Read Article', style: tw(TwSize.xs, weight: FontWeight.w500, color: Tw.blue400)),
                        const Icon(LucideIcons.arrowUpRight, size: 12, color: Tw.blue400),
                      ],
                    ),
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

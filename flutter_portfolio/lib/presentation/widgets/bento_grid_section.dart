import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/apple_theme.dart';
import 'common.dart';

const _header = SectionHeader(
  kicker: 'Core Architecture',
  title: 'Engineered from the core.',
  subtitle: 'Built to withstand scale.',
  body:
      'Every Flutter application is built atop strict separation of concerns, deterministic state streams, and offline-first reliability.',
  largeBody: true,
);

/// Apple M-series style architecture bento grid (src/components/BentoGrid.tsx).
class BentoGridSection extends StatelessWidget {
  const BentoGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);

    final cards = [
      _cleanArchitecture(bp),
      _offlinePersistence(bp),
      _realtime(bp),
      _testing(bp),
      _cloud(bp),
    ];

    return Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 48,
        children: [
          _header,
          if (bp.md)
            Column(
              spacing: 24,
              children: [
                SpanRow(
                    spans: const [7, 5],
                    gap: 24,
                    children: [cards[0], cards[1]]),
                SpanRow(
                    spans: const [4, 4, 4],
                    gap: 24,
                    children: [cards[2], cards[3], cards[4]]),
              ],
            )
          else
            Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 24,
                children: cards),
        ],
      ),
    );
  }

  Widget _card(Bp bp,
      {required Widget body, required Widget footer, double footerGap = 24}) {
    return TwCard(
      padding: EdgeInsets.all(bp.v(24.0, sm: 32.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          body,
          Container(
            margin: EdgeInsets.only(top: footerGap),
            padding: const EdgeInsets.only(top: 24),
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Tw.w(0.05)))),
            child: footer,
          ),
        ],
      ),
    );
  }

  Widget _iconBox(IconData icon, Color bg, Color fg) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bg.withValues(alpha: 0.2)),
      ),
      child: Icon(icon, size: 20, color: fg),
    );
  }

  Widget _titleBlock(Bp bp, String title, String body, {bool large = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(title,
            style: tw(
                large
                    ? bp.v(TwSize.xl, sm: TwSize.x2)
                    : bp.v(TwSize.lg, sm: TwSize.xl),
                weight: FontWeight.w700,
                color: Tw.white,
                tracking: Tracking.tight)),
        Text(body,
            style: tw(large ? TwSize.sm : bp.v(TwSize.xs, sm: TwSize.sm),
                color: Tw.neutral400, leading: Leading.relaxed)),
      ],
    );
  }

  Widget _footerDots(List<String> items) => DotList(
      items: items,
      style: tw(TwSize.xs, color: Tw.neutral400),
      dotColor: Tw.neutral400,
      gapX: 12);

  Widget _footerText(String text) =>
      Text(text, style: tw(TwSize.xs, color: Tw.neutral500));

  Widget _cleanArchitecture(Bp bp) {
    Widget layer(String title, String sub, String tag, Color tagColor,
            Color border) =>
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Tw.neutral900.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Inline span in a 16px/1.5 block: the line box is 24px tall (CSS strut).
                    Text(title,
                        style: tw(TwSize.xs,
                            weight: FontWeight.w600,
                            color: Tw.white,
                            leading: 2)),
                    Text(sub, style: tw(TwSize.px(11), color: Tw.neutral400)),
                  ],
                ),
              ),
              Text(tag, style: tw(TwSize.px(10), mono: true, color: tagColor)),
            ],
          ),
        );

    return _card(
      bp,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconBox(LucideIcons.layers, Tw.blue600, Tw.blue400),
              Text('Layered Separation',
                  style: tw(TwSize.xs, mono: true, color: Tw.neutral400)),
            ],
          ),
          _titleBlock(bp, 'Clean Architecture & BLoC State',
              'Decoupled Presentation, Domain, and Data boundaries. Unidirectional event-to-state pipelines eliminate side effects and guarantee predictable UI rendering.'),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10,
              children: [
                layer(
                    'Presentation Layer',
                    'Flutter Widgets · BlocBuilder · Page Routers',
                    'UI / Events',
                    Tw.blue400,
                    Tw.w(0.1)),
                layer(
                    'Domain Layer',
                    'UseCases · Entities · Repository Contracts',
                    'Pure Business Logic',
                    Tw.emerald400,
                    Tw.blue500.withValues(alpha: 0.3)),
                layer('Data Layer', 'Models · Remote DataSources · Local Cache',
                    'APIs & Hive/SQFLite', Tw.purple400, Tw.w(0.1)),
              ],
            ),
          ),
        ],
      ),
      footer: _footerDots(const [
        'S.O.L.I.D Compliance',
        'Dependency Inversion',
        'GetIt Service Locator'
      ]),
    );
  }

  Widget _offlinePersistence(Bp bp) {
    Widget row(String title, String tag, Color tagColor) => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Tw.neutral900.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Tw.w(0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: tw(TwSize.xs,
                      weight: FontWeight.w500, color: Tw.neutral200)),
              Text(tag, style: tw(TwSize.xs, mono: true, color: tagColor)),
            ],
          ),
        );

    return _card(
      bp,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconBox(LucideIcons.database, Tw.amber500, Tw.amber400),
              Text('<2ms Reads',
                  style: tw(TwSize.xs, mono: true, color: Tw.neutral400)),
            ],
          ),
          _titleBlock(bp, 'Offline-First Persistence',
              'Fast, resilient local storage architecture. Applications work effortlessly offline, instantaneously reading from local binary stores and syncing when network resumes.'),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                row('Hive NoSQL Box', 'Key-Value <1ms', Tw.amber400),
                row('SQFLite Relational', 'ACID Transactions', Tw.blue400),
                row('SharedPreferences', 'Config & Tokens', Tw.purple400),
              ],
            ),
          ),
        ],
      ),
      footer: _footerDots(const ['Zero Native Overhead', 'Encrypted Boxes']),
    );
  }

  Widget _codeBox(List<(String, Color)> lines) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Tw.neutral900.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Tw.w(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          for (final l in lines)
            Text(l.$1, style: tw(TwSize.px(11), mono: true, color: l.$2))
        ],
      ),
    );
  }

  Widget _realtime(Bp bp) {
    return _card(
      bp,
      footerGap: 16,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: _iconBox(LucideIcons.wifi, Tw.emerald500, Tw.emerald400)),
          _titleBlock(bp, 'Realtime Sockets & APIs',
              'Persistent bidirectional WebSocket connections with Socket.IO and Node.js. Resilient reconnect hooks and heartbeat telemetry.',
              large: false),
          _codeBox(const [
            ('// Socket Channel Sync', Tw.neutral500),
            ("socket.on('stream:sync')", Tw.emerald400),
            ('ping: <45ms · jitter: 2ms', Tw.neutral400),
          ]),
        ],
      ),
      footer: _footerText('WebSockets · Postman Verified · RESTful Contracts'),
    );
  }

  Widget _testing(Bp bp) {
    return _card(
      bp,
      footerGap: 16,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: _iconBox(
                  LucideIcons.shieldCheck, Tw.purple500, Tw.purple400)),
          _titleBlock(bp, 'TDD & Test Automation',
              'Author of technical testing masterclasses on Medium. Exhaustive Widget tests, Integration flows, and unit verification before production rollout.',
              large: false),
          _codeBox(const [
            ("✓ testWidgets('Pumps Counter')", Tw.emerald400),
            ("✓ integrationTest('Auth Flow')", Tw.emerald400),
            ("✓ blocTest('Emits Loading -> Loaded')", Tw.emerald400),
          ]),
        ],
      ),
      footer: _footerText('Medium Published · Automated CI Pipeline'),
    );
  }

  Widget _cloud(Bp bp) {
    Widget row(String title, String tag) => Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Tw.neutral900.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Tw.w(0.05)),
          ),
          child: Row(
            children: [
              Expanded(
                  child: Text(title,
                      style: tw(TwSize.xs,
                          weight: FontWeight.w500, color: Tw.neutral300))),
              Text(tag,
                  style: tw(TwSize.px(10), mono: true, color: Tw.cyan400)),
            ],
          ),
        );

    return _card(
      bp,
      footerGap: 16,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: _iconBox(LucideIcons.cloud, Tw.cyan500, Tw.cyan400)),
          _titleBlock(bp, 'Cloud & Infrastructure',
              'Actively engineering with Firebase Functions, Google Play Services, and resilient cloud-connected mobile architectures.',
              large: false),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              row('Appscripts (Google Apps Script)', 'Serverless Automation'),
              row('Firebase Functions', 'Serverless Backend'),
              row('Google Play Services', 'Auth · Maps · Billing'),
            ],
          ),
        ],
      ),
      footer: _footerText('Cloud Ecosystem · Mobile Services'),
    );
  }
}

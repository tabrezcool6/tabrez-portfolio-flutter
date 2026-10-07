import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/apple_theme.dart';
import '../../data/portfolio_data.dart';
import 'common.dart';

/// Apple-style footer (src/components/Footer.tsx).
class AppleFooter extends StatelessWidget {
  final ValueChanged<String> onNavigate;
  final VoidCallback onBackToTop;

  const AppleFooter({super.key, required this.onNavigate, required this.onBackToTop});

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);
    final note = tw(TwSize.px(11), color: Tw.neutral500, leading: Leading.relaxed);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Tw.footer,
        border: Border(top: BorderSide(color: Tw.w(0.1))),
      ),
      padding: EdgeInsets.symmetric(vertical: bp.v(56.0, sm: 64.0)),
      child: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 40,
          children: [
            // Footnotes
            Container(
              padding: const EdgeInsets.only(bottom: 32),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Tw.w(0.05)))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Text(
                      "1. 120 FPS performance targets are profiled on 120Hz ProMotion displays with zero frame jitter using Flutter's DevTools performance overlay and Skia/Impeller graphics pipelines.",
                      style: note),
                  Text(
                      "2. Architectural references and test coverage adhere to Clean Architecture, S.O.L.I.D principles, and automated test pyramids as detailed in Syed's published technical articles on Medium.",
                      style: note),
                  Text(
                      '3. All trademarks, device silhouettes, and product references belong to their respective owners. Portfolio engineered with Apple human interface design principles.',
                      style: note),
                ],
              ),
            ),

            // Directory columns
            TwGrid(
              columns: bp.v(2, md: 4),
              gapX: 32,
              gapY: 32,
              stretch: false,
              children: [
                _column('Navigation', [
                  _link('Overview', () => onNavigate('overview')),
                  _link('Core Specs', () => onNavigate('engineering')),
                  _link('Featured Works', () => onNavigate('projects')),
                  _link('Code Engine', () => onNavigate('architecture')),
                  _link('Trajectory', () => onNavigate('experience')),
                ]),
                _column('Featured Projects', [
                  _url('Sameens App', 'https://play.google.com/store/apps/details?id=com.sameens.store'),
                  _url('Sameens Store', 'https://sameens.com'),
                  _url('Sameens Dashboard', 'https://staging-admin.sameens.com'),
                  _url('Handwriter Android', 'https://play.google.com/store/apps/details?id=com.xsar.handwriter'),
                  _url('iTask', 'https://github.com/tabrezcool6/iTask-ToDoListApp'),
                ]),
                _column('Articles & Insights', [
                  _url('Pick Image from Camera & Gallery',
                      'https://medium.com/@tabrezcool6/how-to-pick-image-from-camera-and-gallery-flutter-2023-2faa1d104eee'),
                  _url('Unit Tests for an API in Flutter',
                      'https://medium.com/@tabrezcool6/unit-tests-for-an-api-in-flutter-2025-e8f162ec9f46'),
                  _url('Widget Tests for a Counter Class',
                      'https://medium.com/@tabrezcool6/widget-tests-for-a-counter-class-in-flutter-2025-c8c919d7ca88'),
                  _url('Integration Tests for a Login Page',
                      'https://medium.com/@tabrezcool6/integration-tests-for-a-login-page-in-flutter-2025-9e09f8049181'),
                  _url('Medium Articles Hub', 'https://medium.com/@tabrezcool6'),
                ]),
                _column('Direct Connect', [
                  _url('Mail: ${PersonalInfo.email}', 'mailto:${PersonalInfo.email}'),
                  _url('LinkedIn: syed-tabrez-pasha-s', PersonalInfo.linkedin),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(PersonalInfo.location, style: tw(TwSize.px(11), mono: true, color: Tw.neutral500)),
                  ),
                ]),
              ],
            ),

            // Bottom line bar
            Container(
              padding: const EdgeInsets.only(top: 32),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Tw.w(0.05)))),
              child: bp.sm
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Flexible(child: _copyright(bp)), _backToTop()],
                    )
                  : Column(spacing: 16, children: [_copyright(bp), _backToTop()]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _column(String title, List<Widget> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(title, style: tw(TwSize.xs, weight: FontWeight.w600, color: Tw.white, tracking: Tracking.tight)),
        Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 8, children: links),
      ],
    );
  }

  Widget _link(String label, VoidCallback onTap) => Hover(
        onTap: onTap,
        builder: (context, hovered) =>
            Text(label, style: tw(TwSize.xs, color: hovered ? Tw.white : Tw.neutral400)),
      );

  Widget _url(String label, String url) => _link(label, () => openUrl(url));

  Widget _copyright(Bp bp) {
    final style = tw(TwSize.xs, color: Tw.neutral500);
    return Wrap(
      alignment: bp.sm ? WrapAlignment.start : WrapAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        Text('Copyright © ${DateTime.now().year} ${PersonalInfo.name}.', style: style),
        if (bp.sm) Text('·', style: style),
        Text('All rights reserved.', style: style),
      ],
    );
  }

  Widget _backToTop() => Hover(
        onTap: onBackToTop,
        builder: (context, hovered) {
          final c = hovered ? Tw.white : Tw.neutral400;
          return Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              Text('Back to top', style: tw(TwSize.xs, color: c)),
              Icon(LucideIcons.arrowUp, size: 14, color: c),
            ],
          );
        },
      );
}

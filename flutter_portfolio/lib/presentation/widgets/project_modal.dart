import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/apple_theme.dart';
import '../../data/portfolio_data.dart';
import 'common.dart';

/// Opens the project detail overlay (src/components/ProjectModal.tsx).
Future<void> showProjectModal(BuildContext context, Project project) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    transitionDuration: Duration.zero,
    pageBuilder: (context, _, __) => _ProjectModal(project: project),
  );
}

class _ProjectModal extends StatefulWidget {
  final Project project;
  const _ProjectModal({required this.project});

  @override
  State<_ProjectModal> createState() => _ProjectModalState();
}

class _ProjectModalState extends State<_ProjectModal> {
  bool _copied = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _close() => Navigator.of(context).pop();

  void _copy() {
    final snippet = widget.project.codeSnippet;
    if (snippet == null) return;
    Clipboard.setData(ClipboardData(text: snippet.code));
    setState(() => _copied = true);
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () => mounted ? setState(() => _copied = false) : null);
  }

  TextStyle get _h4 =>
      tw(TwSize.sm, weight: FontWeight.w600, color: Tw.neutral300, mono: true, tracking: Tracking.wider);

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);
    final p = widget.project;
    final screenH = MediaQuery.sizeOf(context).height;

    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.escape): _close},
      child: Focus(
        autofocus: true,
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              // Backdrop: bg-black/80 backdrop-blur-xl; click to close.
              Positioned.fill(
                child: GestureDetector(
                  onTap: _close,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: Container(color: Tw.black.withValues(alpha: 0.8)),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(bp.v(16.0, sm: 24.0, md: 40.0)),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 768, maxHeight: screenH * 0.9),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Tw.modal,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Tw.w(0.15)),
                        boxShadow: TwShadow.xl2,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(bp.v(24.0, sm: 32.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 24,
                          children: [
                            _header(bp, p),
                            _overview(bp, p),
                            _highlights(bp, p),
                            if (p.metrics != null) _metrics(bp, p),
                            _techStack(bp, p),
                            if (p.codeSnippet != null) _snippet(p),
                            _actions(bp, p),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(Bp bp, Project p) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Tw.w(0.1)))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Text(p.category, style: tw(TwSize.xs, color: Tw.neutral400)),
                    Text('·', style: tw(TwSize.xs, color: Tw.neutral400)),
                    Text('Architecture Verified', style: tw(TwSize.xs, mono: true, color: Tw.blue400)),
                  ],
                ),
                Text(p.title,
                    style: tw(bp.v(TwSize.x2, sm: TwSize.x3),
                        weight: FontWeight.w700, color: Tw.white, tracking: Tracking.tight)),
                Text(p.tagline, style: tw(TwSize.sm, color: Tw.neutral400)),
              ],
            ),
          ),
          Hover(
            onTap: _close,
            builder: (context, hovered) => AnimatedContainer(
              duration: twDuration,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Tw.w(hovered ? 0.2 : 0.1), shape: BoxShape.circle),
              child: Icon(LucideIcons.x, size: 20, color: hovered ? Tw.white : Tw.neutral300),
            ),
          ),
        ],
      ),
    );
  }

  Widget _overview(Bp bp, Project p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Text('SYSTEM OVERVIEW', style: _h4),
        Text(p.longDescription,
            style: tw(bp.v(TwSize.sm, sm: TwSize.base), color: Tw.neutral300, leading: Leading.relaxed)),
      ],
    );
  }

  Widget _highlights(Bp bp, Project p) {
    final style = tw(bp.v(TwSize.xs, sm: TwSize.sm), color: Tw.neutral300);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text('ENGINEERING HIGHLIGHTS', style: _h4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            for (final h in p.highlights)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text('·', style: style.copyWith(color: Tw.blue400, fontWeight: FontWeight.w700)),
                  ),
                  Expanded(child: Text(h, style: style)),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _metrics(Bp bp, Project p) {
    final align = bp.sm ? CrossAxisAlignment.start : CrossAxisAlignment.center;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Text('KEY METRICS & PATTERNS', style: _h4),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Tw.neutral900.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Tw.w(0.05)),
            ),
            child: TwGrid(
              columns: 3,
              gapX: 12,
              stretch: false,
              children: [
                for (final m in p.metrics!)
                  Column(
                    crossAxisAlignment: align,
                    children: [
                      Text(m.value,
                          textAlign: bp.sm ? TextAlign.left : TextAlign.center,
                          style: tw(bp.v(TwSize.base, sm: TwSize.lg),
                              weight: FontWeight.w700, color: Tw.white, mono: true, tabular: true)),
                      Text(m.label,
                          textAlign: bp.sm ? TextAlign.left : TextAlign.center,
                          style: tw(TwSize.xs, color: Tw.neutral400)),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _techStack(Bp bp, Project p) {
    final size = bp.v(TwSize.xs, sm: TwSize.sm);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text('TECH STACK', style: _h4),
          DotList(
            items: p.technologies,
            style: tw(size, weight: FontWeight.w500, color: Tw.white),
            dotColor: Tw.neutral600,
            gapX: 12,
            gapY: 6,
          ),
        ],
      ),
    );
  }

  Widget _snippet(Project p) {
    final s = p.codeSnippet!;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(spacing: 8, children: [
                const Icon(LucideIcons.terminal, size: 14, color: Tw.blue400),
                Text(s.filename, style: tw(TwSize.xs, mono: true, color: Tw.neutral400)),
              ]),
              Hover(
                onTap: _copy,
                builder: (context, hovered) {
                  final c = hovered ? Tw.white : Tw.neutral400;
                  return Row(spacing: 4, children: [
                    _copied
                        ? const Icon(LucideIcons.check, size: 14, color: Tw.emerald400)
                        : Icon(LucideIcons.copy, size: 14, color: c),
                    Text(_copied ? 'Copied' : 'Copy Code', style: tw(TwSize.xs, color: c)),
                  ]);
                },
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Tw.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Tw.w(0.1)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(s.code,
                  softWrap: false,
                  style: tw(TwSize.xs, mono: true, color: Tw.neutral200, leading: Leading.relaxed)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actions(Bp bp, Project p) {
    final size = bp.v(TwSize.xs, sm: TwSize.sm);

    Widget link(IconData icon, Color iconColor, String label, String url) => Hover(
          onTap: () => openUrl(url),
          builder: (context, hovered) => AnimatedContainer(
            duration: twDuration,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: hovered ? Tw.neutral200 : Tw.white,
              borderRadius: BorderRadius.circular(999),
              boxShadow: TwShadow.sm(),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                Icon(icon, size: 16, color: iconColor),
                Text(label, style: tw(size, weight: FontWeight.w600, color: Tw.black)),
                const Icon(LucideIcons.arrowUpRight, size: 16, color: Tw.black),
              ],
            ),
          ),
        );

    final (IconData icon, Color color) = switch (p.actionType) {
      'playstore' => (LucideIcons.smartphone, Tw.emerald600),
      'website' => (LucideIcons.globe, Tw.blue600),
      _ => (LucideIcons.github, Tw.neutral800),
    };

    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Tw.w(0.1)))),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              link(icon, color, p.actionLabel, p.projectUrl),
              if (p.playStoreUrl != null)
                link(LucideIcons.smartphone, Tw.emerald600, 'View on Play Store', p.playStoreUrl!),
            ],
          ),
          Hover(
            onTap: _close,
            builder: (context, hovered) => AnimatedContainer(
              duration: twDuration,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: hovered ? Tw.neutral700 : Tw.neutral800,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text('Close Overview',
                  style: tw(size, weight: FontWeight.w500, color: hovered ? Tw.white : Tw.neutral300)),
            ),
          ),
        ],
      ),
    );
  }
}

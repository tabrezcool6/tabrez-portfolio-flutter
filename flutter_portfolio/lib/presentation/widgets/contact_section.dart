import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/apple_theme.dart';
import '../../data/portfolio_data.dart';
import 'common.dart';

const _scopeOptions = [
  ('Mobile App (Flutter)', 'Mobile App Development (Flutter)'),
  ('Freelance Opportunity', 'Freelance Opportunity'),
  ('Architecture & State Audit', 'Architecture & BLoC/Clean Arch Audit'),
  ('Full-time Engineering Role', 'Full-time Engineering Opportunity'),
  ('Technical Consulting', 'Technical Consulting / Mentorship'),
  ('Other', 'Other Collaboration'),
];

/// mailto: link to [PersonalInfo.email] with the form's details as subject + body.
String buildMailtoLink({
  required String name,
  required String email,
  required String projectType,
  required String message,
}) {
  final scope = _scopeOptions.firstWhere((o) => o.$1 == projectType, orElse: () => (projectType, projectType)).$2;
  final subject = 'Portfolio Inquiry: $scope — ${name.trim()}';
  final body = [
    'Name: ${name.trim()}',
    'Email: ${email.trim()}',
    'Project / Inquiry Scope: $scope',
    '',
    'Message:',
    message.trim(),
  ].join('\n');
  // Uri.encodeComponent (not queryParameters) so spaces become %20, not '+'.
  return 'mailto:${PersonalInfo.email}'
      '?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
}

enum _FormStatus { idle, submitting, success, error }

/// Contact & inquiry desk (src/components/ContactSection.tsx).
class ContactSection extends StatefulWidget {
  /// Focused by the "Get in Touch" buttons (`#contact-name`).
  final FocusNode nameFocus;
  const ContactSection({super.key, required this.nameFocus});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  bool _copiedEmail = false;
  Timer? _copyTimer;

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  String _projectType = 'Mobile App (Flutter)';
  _FormStatus _status = _FormStatus.idle;
  String _error = '';

  @override
  void dispose() {
    _copyTimer?.cancel();
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  void _copyEmail() {
    Clipboard.setData(const ClipboardData(text: PersonalInfo.email));
    setState(() => _copiedEmail = true);
    _copyTimer?.cancel();
    _copyTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _copiedEmail = false);
    });
  }

  void _submit() {
    if (_status == _FormStatus.submitting) return;
    if (_name.text.trim().isEmpty || _email.text.trim().isEmpty || _message.text.trim().isEmpty) {
      setState(() {
        _status = _FormStatus.error;
        _error = 'Please fill in your name, email, and message.';
      });
      return;
    }
    // Open the visitor's mail app with everything they entered, addressed to Tabrez.
    openUrl(buildMailtoLink(
      name: _name.text,
      email: _email.text,
      projectType: _projectType,
      message: _message.text,
    ));

    setState(() => _status = _FormStatus.submitting);
    Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _status = _FormStatus.success;
        _name.clear();
        _email.clear();
        _message.clear();
        _projectType = 'Mobile App (Flutter)';
        _error = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);

    return Section(
      borderTop: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 64,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: SectionHeader(
              kicker: 'Get in Touch',
              title: 'Connect with Tabrez.',
              subtitle: "Let's build something remarkable.",
              body:
                  "Whether you need a senior Flutter engineer, an architectural consultation, or a high-performance mobile app engineered from the ground up, I'm just a message away.",
            ),
          ),
          if (bp.lg)
            SpanRow(spans: const [5, 7], gap: 40, stretch: false, children: [_channels(bp), _formCard(bp)])
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 40,
              children: [_channels(bp), _formCard(bp)],
            ),
        ],
      ),
    );
  }

  // Left column: direct communication channels
  Widget _channels(Bp bp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _ProfileCard(),
        _channelCards(bp),
      ],
    );
  }

  Widget _channelCards(Bp bp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 24,
      children: [
        TwCard(
          padding: EdgeInsets.all(bp.v(24.0, sm: 28.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Primary Channel', style: tw(TwSize.xs, mono: true, color: Tw.neutral400)),
                  Row(
                    spacing: 4,
                    children: [
                      const Dot(size: 6, color: Tw.emerald400, pulse: true),
                      Text('Quick Reply', style: tw(TwSize.xs, mono: true, color: Tw.emerald400)),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text('Direct Inquiries',
                      style: tw(TwSize.lg, weight: FontWeight.w700, color: Tw.white, tracking: Tracking.tight)),
                  Text('Tap to copy address or open in your default mail client.',
                      style: tw(TwSize.xs, color: Tw.neutral400)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Tw.neutral900,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Tw.w(0.05)),
                ),
                child: Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('EMAIL ADDRESS', style: tw(TwSize.px(10), mono: true, color: Tw.neutral500, leading: 2.4)),
                          Text(PersonalInfo.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: tw(bp.v(TwSize.xs, sm: TwSize.sm),
                                  weight: FontWeight.w600, color: Tw.white, mono: true)),
                        ],
                      ),
                    ),
                    Tooltip(
                      message: 'Copy email',
                      waitDuration: const Duration(milliseconds: 600),
                      child: Hover(
                        onTap: _copyEmail,
                        builder: (context, hovered) => AnimatedContainer(
                          duration: twDuration,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Tw.w(hovered ? 0.1 : 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Tw.w(0.1)),
                          ),
                          child: _copiedEmail
                              ? const Icon(LucideIcons.check, size: 16, color: Tw.emerald400)
                              : Icon(LucideIcons.copy, size: 16, color: hovered ? Tw.white : Tw.neutral300),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_copiedEmail)
                Row(
                  spacing: 6,
                  children: [
                    const Icon(LucideIcons.check, size: 14, color: Tw.emerald400),
                    Text('Email address copied to clipboard',
                        style: tw(TwSize.xs, mono: true, color: Tw.emerald400)),
                  ],
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Tw.card,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Tw.w(0.1)),
          ),
          child: Column(
            spacing: 16,
            children: [
              Row(spacing: 12, children: [
                const Icon(LucideIcons.mapPin, size: 16, color: Tw.blue400),
                Text(PersonalInfo.location, style: tw(TwSize.xs, color: Tw.neutral300)),
              ]),
              Row(spacing: 12, children: [
                const Icon(LucideIcons.clock, size: 16, color: Tw.emerald400),
                Text('IST (UTC+5:30) · High availability', style: tw(TwSize.xs, color: Tw.neutral300)),
              ]),
            ],
          ),
        ),
        TwGrid(
          columns: 3,
          gapX: 12,
          children: [
            _social(LucideIcons.github, 20, Tw.white, 'GitHub', 'tabrezcool6', PersonalInfo.github),
            _social(LucideIcons.linkedin, 16, Tw.blue400, 'LinkedIn', 'syed-tabrez-pasha-s', PersonalInfo.linkedin),
            _social(LucideIcons.messageSquare, 16, Tw.emerald400, 'Medium', 'tabrezcool6', PersonalInfo.medium),
          ],
        ),
      ],
    );
  }

  Widget _social(IconData icon, double size, Color hoverColor, String label, String handle, String url) {
    return TwCard(
      onTap: () => openUrl(url),
      padding: const EdgeInsets.all(16),
      radius: 16,
      child: Builder(builder: (context) {
        final hovered = HoverScope.of(context);
        return Column(
          children: [
            Icon(icon, size: size, color: hovered ? hoverColor : Tw.neutral400),
            const SizedBox(height: 8),
            Text(label, style: tw(TwSize.xs, weight: FontWeight.w600, color: Tw.neutral300)),
            Text(handle,
                textAlign: TextAlign.center,
                style: tw(TwSize.px(10), mono: true, color: Tw.neutral500, leading: 2.4)),
          ],
        );
      }),
    );
  }

  // Right column: message form
  Widget _formCard(Bp bp) {
    return Container(
      padding: EdgeInsets.all(bp.v(24.0, sm: 36.0)),
      decoration: BoxDecoration(
        color: Tw.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Tw.w(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 24,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text('Send a Message',
                  style: tw(bp.v(TwSize.xl, sm: TwSize.x2),
                      weight: FontWeight.w700, color: Tw.white, tracking: Tracking.tight)),
              Text('Have an opportunity or architecture question? Drop the details below.',
                  style: tw(bp.v(TwSize.xs, sm: TwSize.sm), color: Tw.neutral400)),
            ],
          ),
          if (_status == _FormStatus.success) _success() else _form(bp),
        ],
      ),
    );
  }

  Widget _success() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Tw.emerald500.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Tw.emerald500.withValues(alpha: 0.2)),
      ),
      child: Column(
        spacing: 16,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: Tw.emerald500.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: const Icon(LucideIcons.check, size: 24, color: Tw.emerald400),
          ),
          Column(
            spacing: 4,
            children: [
              Text('Message Dispatched!', style: tw(TwSize.lg, weight: FontWeight.w700, color: Tw.white)),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 384),
                child: Text(
                  'Thank you for reaching out. Tabrez will review your message and reply via email shortly.',
                  textAlign: TextAlign.center,
                  style: tw(TwSize.xs, color: Tw.neutral300),
                ),
              ),
            ],
          ),
          Hover(
            onTap: () => setState(() => _status = _FormStatus.idle),
            builder: (context, hovered) => AnimatedContainer(
              duration: twDuration,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: hovered ? Tw.neutral200 : Tw.white,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text('Send Another Note', style: tw(TwSize.xs, weight: FontWeight.w600, color: Tw.black)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _form(Bp bp) {
    final inputSize = bp.v(TwSize.xs, sm: TwSize.sm);

    Widget field(String label, Widget input) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 6,
          children: [
            // Inline <label> in a 16px/1.5 block: 24px line box (CSS strut).
            Text(label, style: tw(TwSize.xs, weight: FontWeight.w500, color: Tw.neutral300, leading: 2)),
            input,
          ],
        );

    final nameField = field(
      'Your Name',
      _TwInput(controller: _name, hint: 'Enter your name', size: inputSize, focusNode: widget.nameFocus),
    );
    final emailField = field(
      'Email Address',
      _TwInput(
          controller: _email, hint: 'Enter your email', size: inputSize, keyboardType: TextInputType.emailAddress),
    );

    final submitting = _status == _FormStatus.submitting;
    final submit = PressScale(
      child: Hover(
        onTap: submitting ? null : _submit,
        cursor: submitting ? SystemMouseCursors.basic : SystemMouseCursors.click,
        builder: (context, hovered) => AnimatedOpacity(
          duration: twDuration,
          opacity: submitting ? 0.5 : 1,
          child: AnimatedContainer(
            duration: twDuration,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: hovered && !submitting ? Tw.blue500 : Tw.blue600,
              borderRadius: BorderRadius.circular(999),
              boxShadow: TwShadow.lg(Tw.blue600.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: bp.sm ? MainAxisSize.min : MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Text(submitting ? 'Transmitting...' : 'Transmit Message',
                    style: tw(inputSize, weight: FontWeight.w500, color: Tw.white)),
                if (!submitting) const Icon(LucideIcons.send, size: 14, color: Tw.white),
              ],
            ),
          ),
        ),
      ),
    );
    final note = Text('Replies typically dispatched within 24 hours.',
        style: tw(TwSize.px(11), color: Tw.neutral500));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        if (_status == _FormStatus.error)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Tw.rose500.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Tw.rose500.withValues(alpha: 0.2)),
            ),
            child: Text(_error, style: tw(TwSize.xs, color: Tw.rose300)),
          ),
        if (bp.sm)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [Expanded(child: nameField), Expanded(child: emailField)],
          )
        else
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: 16, children: [nameField, emailField]),
        field('Project / Inquiry Scope', _scopeSelect(inputSize)),
        field(
          'Message',
          _TwInput(
            controller: _message,
            hint: 'Share details about your application, timelines, or engineering challenge...',
            size: inputSize,
            lines: 4,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: bp.sm
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 16,
                  children: [Flexible(child: note), submit],
                )
              : Column(spacing: 16, children: [note, submit]),
        ),
      ],
    );
  }

  Widget _scopeSelect(TwSize size) {
    // Native <select> (px-3.5 py-2.5, ~41px tall). A dense DropdownButton
    // reserves a 24px line, so trim the vertical padding to match.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Tw.neutral900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Tw.w(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _projectType,
          isDense: true,
          isExpanded: true,
          dropdownColor: Tw.neutral900,
          borderRadius: BorderRadius.circular(12),
          icon: const Icon(LucideIcons.chevronDown, size: 16, color: Tw.neutral400),
          style: tw(size, color: Tw.white),
          items: [
            for (final o in _scopeOptions)
              DropdownMenuItem(value: o.$1, child: Text(o.$2, style: tw(size, color: Tw.white))),
          ],
          onChanged: (v) => setState(() => _projectType = v ?? _projectType),
        ),
      ),
    );
  }
}

/// Profile card at the top of the contact column: photo, name, title and
/// availability. Hidden entirely (including its 24px gap) until
/// assets/images/profile.png exists.
class _ProfileCard extends StatefulWidget {
  const _ProfileCard();

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  static final Future<bool> _photoExists =
      rootBundle.load('assets/images/profile.png').then((_) => true, onError: (_) => false);

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);
    return FutureBuilder<bool>(
      future: _photoExists,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 24), // space-y-6
          child: TwCard(
            padding: EdgeInsets.all(bp.v(24.0, sm: 28.0)),
            child: Row(
              spacing: 20,
              children: [
                ProfilePhoto(size: bp.v(96.0, sm: 112.0)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(PersonalInfo.name,
                          style: tw(TwSize.lg, weight: FontWeight.w700, color: Tw.white, tracking: Tracking.tight)),
                      Text(PersonalInfo.title, style: tw(TwSize.xs, color: Tw.neutral400)),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          spacing: 6,
                          children: [
                            const Dot(size: 6, color: Tw.emerald400, pulse: true),
                            Flexible(
                              child: Text('Available for projects',
                                  style: tw(TwSize.xs, mono: true, color: Tw.emerald400)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TwInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TwSize size;
  final int lines;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;

  const _TwInput({
    required this.controller,
    required this.hint,
    required this.size,
    this.lines = 1,
    this.focusNode,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TwTextInput(
      controller: controller,
      hint: hint,
      style: tw(size, color: Tw.white),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      radius: 12,
      lines: lines,
      focusNode: focusNode,
      keyboardType: keyboardType,
    );
  }
}

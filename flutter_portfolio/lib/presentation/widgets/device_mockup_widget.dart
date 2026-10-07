import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/apple_theme.dart';
import 'common.dart';

/// Inside the phone, arbitrary `text-[Npx]` sizes inherit text-xs line-height.
TwSize _px(double size) => TwSize(size, 16 / 12);

class _Task {
  final int id;
  final String title;
  final bool done;
  final String priority;
  const _Task(this.id, this.title, this.done, this.priority);
  _Task toggled() => _Task(id, title, !done, priority);
}

class _Message {
  final String text;
  final String time;
  final bool isMe;
  const _Message(this.text, this.time, this.isMe);
}

/// Interactive iPhone 16 Pro mockup (src/components/DeviceMockup.tsx).
class DeviceMockup extends StatefulWidget {
  const DeviceMockup({super.key});

  @override
  State<DeviceMockup> createState() => _DeviceMockupState();
}

class _DeviceMockupState extends State<DeviceMockup> {
  String _tab = 'blog';

  List<_Task> _tasks = const [
    _Task(1, 'Implement BLoC state transitions', true, 'High'),
    _Task(2, 'Deployment on Play Store and App Store', true, 'Critical'),
    _Task(3, 'Add widget pump tests for auth form', false, 'Medium'),
    _Task(4, 'Profile 120 FPS sliver scroll performance', false, 'High'),
  ];
  final _taskInput = TextEditingController();

  final List<_Message> _messages = [
    const _Message('Hey Tabrez! How is the new Flutter release looking?', '10:41 AM', false),
    const _Message('Clean Architecture refactor is live. 0 frame drops, buttery 120 FPS!', '10:42 AM', true),
    const _Message('Incredible work on the state stream isolation. Deploying now 🚀', '10:42 AM', false),
  ];
  final _chatInput = TextEditingController();

  bool _liked = true;
  bool _bookmarked = true;

  double _slider = 75;
  String _chip = 'BLoC';

  @override
  void dispose() {
    _taskInput.dispose();
    _chatInput.dispose();
    super.dispose();
  }

  void _addTask() {
    final text = _taskInput.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _tasks = [..._tasks, _Task(DateTime.now().millisecondsSinceEpoch, text, false, 'Normal')];
      _taskInput.clear();
    });
  }

  void _sendChat() {
    final text = _chatInput.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(text, '10:43 AM', true));
      _chatInput.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: bp.v(384.0, sm: 448.0)),
      child: Column(
        children: [
          _selector(),
          const SizedBox(height: 24),
          SelectionContainer.disabled(child: _chassis(bp)),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              const Icon(LucideIcons.sparkles, size: 14, color: Tw.blue400),
              Flexible(
                child: Text('Interactive mockup: Tap screens, add tasks, or send messages',
                    textAlign: TextAlign.center, style: tw(TwSize.xs, color: Tw.neutral500)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _selector() {
    Widget pill(String id, String label) => Hover(
          onTap: () => setState(() => _tab = id),
          builder: (context, hovered) {
            final active = _tab == id;
            return AnimatedContainer(
              duration: twDuration,
              curve: twCurve,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: active ? Tw.white : Tw.white.withValues(alpha: 0),
                borderRadius: BorderRadius.circular(999),
                boxShadow: active ? TwShadow.md() : null,
              ),
              child: Text(label,
                  style: tw(TwSize.xs,
                      weight: FontWeight.w500,
                      color: active ? Tw.black : (hovered ? Tw.white : Tw.neutral400))),
            );
          },
        );

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Tw.w(0.06),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Tw.w(0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              pill('blog', 'Articles'),
              pill('tasks', 'iTask'),
              pill('chat', 'Connect API'),
              pill('widgets', 'Flutter UI'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chassis(Bp bp) {
    final w = bp.v(300.0, sm: 340.0);
    final h = bp.v(620.0, sm: 680.0);

    Widget sideButton({double? left, double? right, required double top, required double height}) => Positioned(
          left: left,
          right: right,
          top: top,
          width: 3,
          height: height,
          child: Container(
            decoration: BoxDecoration(
              color: Tw.neutral600,
              borderRadius: left != null
                  ? const BorderRadius.horizontal(left: Radius.circular(4))
                  : const BorderRadius.horizontal(right: Radius.circular(4)),
            ),
          ),
        );

    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Titanium chassis
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1C),
                borderRadius: BorderRadius.circular(52),
                boxShadow: [
                  BoxShadow(
                      color: Tw.black.withValues(alpha: 0.9),
                      offset: const Offset(0, 25),
                      blurRadius: 60,
                      spreadRadius: -15),
                  // 0 0 0 1px white/15 + ring-1 white/10
                  BoxShadow(color: Tw.w(0.235), spreadRadius: 1),
                ],
              ),
            ),
          ),
          // Outer titanium edge reflection (border-white/20 at 40% opacity)
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(52),
                  border: Border.all(color: Tw.w(0.08)),
                ),
              ),
            ),
          ),
          sideButton(left: -3, top: 115, height: 28),
          sideButton(left: -3, top: 160, height: 50),
          sideButton(left: -3, top: 220, height: 50),
          sideButton(right: -3, top: 170, height: 75),
          Positioned.fill(child: Padding(padding: const EdgeInsets.all(12), child: _screen())),
        ],
      ),
    );
  }

  Widget _screen() {
    return Container(
      decoration: BoxDecoration(
        color: Tw.black,
        borderRadius: BorderRadius.circular(42),
        border: Border.all(color: Tw.black),
      ),
      clipBehavior: Clip.antiAlias,
      child: DefaultTextStyle(
        style: tw(TwSize.xs, color: Tw.neutral100),
        child: Stack(
          children: [
            Column(
              children: [
                // Status bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('9:41',
                          style: tw(_px(12), weight: FontWeight.w500, color: Tw.white, tracking: Tracking.tight)
                              .copyWith(height: 1.5)),
                      const Row(
                        spacing: 6,
                        children: [
                          Icon(LucideIcons.wifi, size: 14, color: Tw.neutral300),
                          Icon(LucideIcons.battery, size: 14, color: Tw.neutral300),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(child: _content()),
                // iOS home bar
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    width: 128,
                    height: 4,
                    decoration: BoxDecoration(color: Tw.w(0.4), borderRadius: BorderRadius.circular(999)),
                  ),
                ),
              ],
            ),
            // Dynamic Island
            const Positioned(top: 10, left: 0, right: 0, child: Center(child: _DynamicIsland())),
          ],
        ),
      ),
    );
  }

  Widget _content() {
    const pad = EdgeInsets.fromLTRB(16, 12, 16, 32);
    switch (_tab) {
      case 'chat':
        return Padding(padding: pad, child: _chatScreen());
      case 'tasks':
        return SingleChildScrollView(padding: pad, child: _tasksScreen());
      case 'widgets':
        return SingleChildScrollView(padding: pad, child: _widgetsScreen());
      default:
        return SingleChildScrollView(padding: pad, child: _blogScreen());
    }
  }

  Widget _screenHeader(String kicker, String title, Widget trailing) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(kicker.toUpperCase(),
                  style: tw(_px(10), mono: true, color: Tw.neutral400, tracking: Tracking.widest, leading: 1.6)),
              Text(title,
                  style: tw(TwSize.base, weight: FontWeight.w700, color: Tw.white, tracking: Tracking.tight)),
            ],
          ),
          trailing,
        ],
      ),
    );
  }

  // SCREEN 1: InsightBlog
  Widget _blogScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 14,
      children: [
        _screenHeader(
          'InsightBlog',
          "Today's Stories",
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Tw.neutral800,
              shape: BoxShape.circle,
              border: Border.all(color: Tw.w(0.1)),
            ),
            child: const Icon(LucideIcons.search, size: 14, color: Tw.neutral400),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Tw.neutral900.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Tw.w(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Architecture', style: tw(_px(10), weight: FontWeight.w500, color: Tw.blue400)),
                  Text('4 min read', style: tw(_px(10), color: Tw.neutral400)),
                ],
              ),
              Text('Mastering BLoC & Clean Architecture in Flutter',
                  style: tw(TwSize.sm, weight: FontWeight.w600, color: Tw.white, leading: Leading.snug)),
              Text(
                'How separating presentation, domain, and data layers prevents UI regressions and keeps state immutable.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: tw(_px(11), color: Tw.neutral400, leading: Leading.relaxed),
              ),
              Container(
                padding: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Tw.w(0.05)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hover(
                      onTap: () => setState(() => _liked = !_liked),
                      builder: (context, hovered) {
                        final c = _liked ? Tw.rose500 : (hovered ? Tw.white : Tw.neutral400);
                        return Row(
                          spacing: 4,
                          children: [
                            LucideSvg(LucideSvg.heart, size: 14, color: c, fill: _liked ? c : null),
                            Text(_liked ? '143' : '142', style: tw(_px(10), color: c)),
                          ],
                        );
                      },
                    ),
                    Hover(
                      onTap: () => setState(() => _bookmarked = !_bookmarked),
                      builder: (context, hovered) {
                        final c = _bookmarked ? Tw.amber400 : (hovered ? Tw.white : Tw.neutral400);
                        return LucideSvg(LucideSvg.bookmark, size: 14, color: c, fill: _bookmarked ? c : null);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Tw.neutral900.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Tw.w(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Deployment', style: tw(_px(10), weight: FontWeight.w500, color: Tw.emerald400)),
                  Text('Store Release', style: tw(_px(10), color: Tw.neutral400)),
                ],
              ),
              Text('Deployment on Play Store and App Store',
                  style: tw(TwSize.sm, weight: FontWeight.w600, color: Tw.white, leading: Leading.snug)),
              Text(
                'Production CI/CD pipelines, release management, and app deployment on Google Play and Apple App Store.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: tw(_px(11), color: Tw.neutral400),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // SCREEN 2: iTask
  Widget _tasksScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        _screenHeader(
          'iTask',
          'Daily Tasks',
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Tw.emerald500.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Tw.emerald500.withValues(alpha: 0.2)),
            ),
            child: Text('Firebase DB', style: tw(_px(10), mono: true, color: Tw.emerald400)),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            for (final task in _tasks)
              Hover(
                onTap: () => setState(() {
                  _tasks = [for (final t in _tasks) t.id == task.id ? t.toggled() : t];
                }),
                builder: (context, hovered) => AnimatedContainer(
                  duration: twDuration,
                  curve: twCurve,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Tw.neutral900.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Tw.w(hovered ? 0.2 : 0.05)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: task.done
                            ? LucideSvg(LucideSvg.circleCheck,
                                size: 16, color: Tw.blue500, fill: Tw.blue500.withValues(alpha: 0.2))
                            : Icon(LucideIcons.circle, size: 16, color: hovered ? Tw.blue400 : Tw.neutral400),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: tw(_px(11),
                                  weight: FontWeight.w500,
                                  leading: Leading.snug,
                                  color: task.done ? Tw.neutral500 : Tw.neutral200,
                                  decoration: task.done ? TextDecoration.lineThrough : null,
                                  decorationColor: Tw.neutral500),
                            ),
                            Text(task.priority, style: tw(_px(9), mono: true, color: Tw.neutral500, leading: 16 / 9)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            spacing: 6,
            children: [
              Expanded(
                child: _MiniInput(
                  controller: _taskInput,
                  hint: 'Add task to Hive storage...',
                  radius: 8,
                  horizontalPadding: 10,
                  onSubmitted: _addTask,
                ),
              ),
              _MiniSubmit(icon: LucideIcons.plus, iconSize: 14, radius: 8, onTap: _addTask),
            ],
          ),
        ),
      ],
    );
  }

  // SCREEN 3: Connect WebChat
  Widget _chatScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 4, bottom: 8),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Tw.w(0.1)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 8,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [Tw.blue600, Tw.indigo600],
                      ),
                    ),
                    child: Text('S', style: tw(_px(10), weight: FontWeight.w700, color: Tw.neutral100)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sameens Mobile Team', style: tw(TwSize.xs, weight: FontWeight.w600, color: Tw.white)),
                      Row(
                        spacing: 4,
                        children: [
                          const Dot(size: 6, color: Tw.emerald400, pulse: true),
                          Text('Socket.IO Live', style: tw(_px(9), color: Tw.emerald400)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Text('Node v20', style: tw(_px(9), mono: true, color: Tw.neutral500)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 220),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: LayoutBuilder(builder: (context, c) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  for (final m in _messages)
                    Column(
                      crossAxisAlignment: m.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: c.maxWidth * 0.82),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: m.isMe ? Tw.blue600 : Tw.neutral800,
                              border: m.isMe ? null : Border.all(color: Tw.w(0.05)),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(m.isMe ? 16 : 4),
                                bottomRight: Radius.circular(m.isMe ? 4 : 16),
                              ),
                            ),
                            child: Text(m.text,
                                style: tw(_px(11),
                                    leading: Leading.relaxed, color: m.isMe ? Tw.white : Tw.neutral200)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
                          child: Text(m.time, style: tw(_px(8), color: Tw.neutral500)),
                        ),
                      ],
                    ),
                ],
              );
            }),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            spacing: 6,
            children: [
              Expanded(
                child: _MiniInput(
                  controller: _chatInput,
                  hint: 'Type WebSocket event...',
                  radius: 999,
                  horizontalPadding: 12,
                  onSubmitted: _sendChat,
                ),
              ),
              _MiniSubmit(icon: LucideIcons.send, iconSize: 12, radius: 999, onTap: _sendChat),
            ],
          ),
        ),
      ],
    );
  }

  // SCREEN 4: Flutter Widgets Matrix
  Widget _widgetsScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 14,
      children: [
        _screenHeader('CustomPainter', 'Widget Lab', const Icon(LucideIcons.layers, size: 16, color: Tw.blue400)),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Tw.w(0.1)),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Tw.neutral900, Tw.neutral950],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Dynamic Arc Painter', style: tw(_px(10), color: Tw.neutral400)),
                  Text('${_slider.round()}%', style: tw(_px(10), mono: true, color: Tw.blue400)),
                ],
              ),
              SizedBox(
                height: 64,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Center(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(end: _slider),
                        duration: const Duration(milliseconds: 300),
                        curve: twCurve,
                        builder: (context, v, _) =>
                            CustomPaint(size: const Size(96, 64), painter: _ArcPainter(v)),
                      ),
                    ),
                    Positioned(
                      top: 28,
                      child: Text('${_slider.round()} FPS',
                          style: tw(TwSize.xs, weight: FontWeight.w700, color: Tw.white, mono: true)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    activeTrackColor: Tw.neutral800,
                    inactiveTrackColor: Tw.neutral800,
                    thumbColor: Tw.blue500,
                    overlayShape: SliderComponentShape.noOverlay,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8, elevation: 0, pressedElevation: 0),
                    trackShape: const RoundedRectSliderTrackShape(),
                  ),
                  child: Slider(
                    min: 10,
                    max: 120,
                    value: _slider,
                    padding: EdgeInsets.zero,
                    onChanged: (v) => setState(() => _slider = v.roundToDouble()),
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 6,
          children: [
            Text('Pattern Selector:', style: tw(_px(10), color: Tw.neutral400, leading: 1.6)),
            Row(
              spacing: 4,
              children: [
                for (final p in const ['BLoC', 'Provider', 'GoRouter', 'GetIt'])
                  Expanded(
                    child: Hover(
                      onTap: () => setState(() => _chip = p),
                      builder: (context, hovered) {
                        final active = _chip == p;
                        return AnimatedContainer(
                          duration: twDuration,
                          curve: twCurve,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: active ? Tw.w(0.1) : Tw.neutral900.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: active ? Tw.blue500.withValues(alpha: 0.5) : Tw.w(0.05)),
                          ),
                          child: Text(
                            p,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: tw(_px(10),
                                weight: active ? FontWeight.w600 : FontWeight.w400,
                                color: active ? Tw.blue400 : (hovered ? Tw.white : Tw.neutral400)),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _DynamicIsland extends StatelessWidget {
  const _DynamicIsland();

  @override
  Widget build(BuildContext context) {
    return Hover(
      builder: (context, hovered) => AnimatedContainer(
        duration: twDuration,
        curve: twCurve,
        width: hovered ? 130 : 96,
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Tw.black,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Tw.w(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Dot(size: 10, color: Tw.blue500.withValues(alpha: 0.8), pulse: true),
            Flexible(
              child: AnimatedOpacity(
                duration: twDuration,
                opacity: hovered ? 1 : 0,
                child: Text('Flutter 120Hz',
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.clip,
                    style: tw(_px(9), mono: true, color: Tw.neutral400, tracking: Tracking.tighter)),
              ),
            ),
            Dot(size: 10, color: Tw.emerald500.withValues(alpha: 0.8)),
          ],
        ),
      ),
    );
  }
}

class _MiniInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final double radius;
  final double horizontalPadding;
  final VoidCallback onSubmitted;

  const _MiniInput({
    required this.controller,
    required this.hint,
    required this.radius,
    required this.horizontalPadding,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    // py-1.5 + inherited text-xs line-height (11px × 1.333) + 1px border.
    return TwTextInput(
      controller: controller,
      hint: hint,
      style: tw(_px(11), color: Tw.white),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 6),
      radius: radius,
      onSubmitted: onSubmitted,
    );
  }
}

class _MiniSubmit extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final double radius;
  final VoidCallback onTap;

  const _MiniSubmit({required this.icon, required this.iconSize, required this.radius, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Hover(
      onTap: onTap,
      builder: (context, hovered) => AnimatedContainer(
        duration: twDuration,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: hovered ? Tw.blue500 : Tw.blue600,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Icon(icon, size: iconSize, color: Tw.white),
      ),
    );
  }
}

/// Paints the SVG gauge from DeviceMockup.tsx, including its
/// stroke-dasharray / stroke-dashoffset behaviour (viewBox 0 0 100 60).
class _ArcPainter extends CustomPainter {
  final double value;
  _ArcPainter(this.value);

  static const _dash = 126.0;
  static const _r = 40.0;

  @override
  void paint(Canvas canvas, Size size) {
    // preserveAspectRatio="xMidYMid meet"
    final scale = math.min(size.width / 100, size.height / 60);
    canvas.translate((size.width - 100 * scale) / 2, (size.height - 60 * scale) / 2);
    canvas.scale(scale);

    final rect = Rect.fromCircle(center: const Offset(50, 50), radius: _r);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF27272A);
    canvas.drawArc(rect, math.pi, math.pi, false, base);

    // Visible dash segment along the path for offset = 126 - 126 * v / 100.
    const length = math.pi * _r;
    final offset = _dash - _dash * value / 100;
    double start, end;
    if (offset >= 0) {
      start = 0;
      end = math.min(_dash - offset, length);
    } else {
      start = -offset;
      end = length;
    }
    if (end <= start) return;

    final progress = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..shader = ui.Gradient.linear(
        const Offset(10, 0),
        const Offset(90, 0),
        const [Color(0xFF2997FF), Color(0xFFBF5AF2)],
      );
    canvas.drawArc(rect, math.pi + start / _r, (end - start) / _r, false, progress);
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.value != value;
}

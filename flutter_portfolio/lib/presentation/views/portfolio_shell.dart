import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../core/view_preference/view_preference.dart';
import '../simple/simple_page.dart';
import 'home_page.dart';

/// Hosts both portfolio views on one page and switches between them with an
/// Apple-style "zoom-through" (mirrors react_portfolio/src/App.tsx + index.css).
class PortfolioShell extends StatefulWidget {
  const PortfolioShell({super.key});

  /// Total switch time: exit (first ~43%) then entrance (from ~29%).
  static const transitionDuration = Duration(milliseconds: 840);

  @override
  State<PortfolioShell> createState() => _PortfolioShellState();
}

class _PortfolioShellState extends State<PortfolioShell> {
  late PortfolioView _view = readInitialView();

  void _switchTo(PortfolioView view) {
    setState(() => _view = view);
    persistView(view);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return ColoredBox(
      // Backdrop seen between the two views, like ::view-transition { background: #000 }.
      color: Colors.black,
      child: AnimatedSwitcher(
        duration: reduceMotion ? Duration.zero : PortfolioShell.transitionDuration,
        layoutBuilder: (current, previous) => Stack(
          fit: StackFit.expand,
          children: [...previous, if (current != null) current],
        ),
        transitionBuilder: (child, animation) => _ZoomThrough(
          animation: animation,
          incoming: child.key == ValueKey(_view),
          child: child,
        ),
        child: switch (_view) {
          PortfolioView.developer => HomePage(
              key: const ValueKey(PortfolioView.developer),
              onSwitchView: () => _switchTo(PortfolioView.simple),
            ),
          PortfolioView.simple => SimplePortfolioPage(
              key: const ValueKey(PortfolioView.simple),
              onSwitchView: () => _switchTo(PortfolioView.developer),
            ),
        },
      ),
    );
  }
}

/// The outgoing view shrinks to 96%, blurs and fades out (ease-in, first 360ms);
/// the incoming view settles from 104% while sharpening and fading in
/// (ease-out, 560ms starting at 240ms).
class _ZoomThrough extends StatelessWidget {
  final Animation<double> animation;
  final bool incoming;
  final Widget child;

  const _ZoomThrough({required this.animation, required this.incoming, required this.child});

  static const _exit = Interval(0, 360 / 840, curve: Cubic(0.4, 0, 1, 1));
  static const _enter = Interval(240 / 840, 1, curve: Cubic(0.22, 1, 0.36, 1));

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final double opacity, scale, blur;
        if (incoming) {
          final t = _enter.transform(animation.value);
          opacity = t;
          scale = 1.04 - 0.04 * t;
          blur = 8 * (1 - t);
        } else {
          // AnimatedSwitcher runs the outgoing animation from 1 down to 0.
          final t = _exit.transform(1 - animation.value);
          opacity = 1 - t;
          scale = 1 - 0.04 * t;
          blur = 8 * t;
        }
        return IgnorePointer(
          ignoring: !incoming,
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: scale,
              child: ImageFiltered(
                // Only blur mid-transition; idle pages keep no filter layer.
                enabled: blur > 0.05,
                imageFilter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: child,
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}

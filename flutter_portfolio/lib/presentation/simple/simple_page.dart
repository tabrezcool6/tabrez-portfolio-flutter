import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'simple_sections.dart';
import 'simple_theme.dart';

/// Section ids (same as the original page's anchors) and nav labels.
const _navLinks = [
  ('Home', 'homePage'),
  ('About', 'about'),
  ('Career', 'carrer'),
  ('Qualification', 'education'),
  ('Skills', 'skills'),
  ('Projects', 'projects'),
  ('Contact', 'contact'),
];

/// Simple, non-technical portfolio view — a port of simpler_portfolio/
/// (https://github.com/tabrezcool6/tabrezcool6.github.io).
class SimplePortfolioPage extends StatefulWidget {
  final VoidCallback onSwitchView;
  const SimplePortfolioPage({super.key, required this.onSwitchView});

  @override
  State<SimplePortfolioPage> createState() => _SimplePortfolioPageState();
}

class _SimplePortfolioPageState extends State<SimplePortfolioPage> {
  final _scroll = ScrollController();
  final _keys = {for (final l in _navLinks) l.$2: GlobalKey()};

  bool _scrolled = false;
  double _progress = 0;
  String _active = 'homePage';
  bool _menuOpen = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Offset of a section from the top of the scrollable content.
  double? _sectionTop(String id) {
    final box = _keys[id]?.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.attached || !_scroll.hasClients) return null;
    return _scroll.offset + box.localToGlobal(Offset.zero).dy;
  }

  // script.js onScroll(): nav background, progress bar, active link.
  void _onScroll() {
    if (!_scroll.hasClients || !mounted) return;
    final y = _scroll.offset;
    final max = _scroll.position.maxScrollExtent;
    final offset = MediaQuery.sizeOf(context).height * 0.35;
    var current = _navLinks.first.$2;
    for (final l in _navLinks) {
      final top = _sectionTop(l.$2);
      if (top != null && y + offset >= top) current = l.$2;
    }
    final scrolled = y > 30;
    final progress = max > 0 ? (y / max).clamp(0.0, 1.0) : 0.0;
    if (scrolled != _scrolled || progress != _progress || current != _active) {
      setState(() {
        _scrolled = scrolled;
        _progress = progress;
        _active = current;
      });
    }
  }

  /// Smooth anchor scroll honouring `scroll-padding-top: 90px`.
  void _scrollTo(String id) {
    setState(() => _menuOpen = false);
    final top = _sectionTop(id);
    if (top == null) return;
    final target = (top - 90).clamp(0.0, _scroll.position.maxScrollExtent);
    _scroll.animateTo(target, duration: const Duration(milliseconds: 700), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final bp = SBp.of(context);

    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: SC.page,
        textSelectionTheme: const TextSelectionThemeData(selectionColor: Color(0x8019C6A4), cursorColor: SC.ink),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: SC.page,
        body: Stack(
          children: [
            RawScrollbar(
              controller: _scroll,
              thumbVisibility: true,
              thickness: 10,
              radius: const Radius.circular(20),
              thumbColor: const Color(0xFFC7CCD6),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: RevealScope(
                  controller: _scroll,
                  child: SelectionArea(
                    child: SingleChildScrollView(
                      controller: _scroll,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SimpleHero(
                            key: _keys['homePage'],
                            onViewWork: () => _scrollTo('projects'),
                            onGetInTouch: () => _scrollTo('contact'),
                            onScrollHint: () => _scrollTo('about'),
                          ),
                          SimpleAbout(key: _keys['about']),
                          SimpleCareer(key: _keys['carrer']),
                          SimpleEducation(key: _keys['education']),
                          SimpleSkills(key: _keys['skills']),
                          SimpleProjects(key: _keys['projects']),
                          SimpleContact(key: _keys['contact']),
                          SimpleFooter(onLogoTap: () => _scrollTo('homePage')),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (!bp.le860) const Positioned(left: 26, bottom: 0, child: SimpleSocialRail()),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _SimpleNavBar(
                scrolled: _scrolled,
                active: _active,
                menuOpen: _menuOpen,
                onNavigate: _scrollTo,
                onToggleMenu: () => setState(() => _menuOpen = !_menuOpen),
                onSwitchView: widget.onSwitchView,
              ),
            ),
            // .scroll-progress
            Positioned(
              top: 0,
              left: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: 3,
                width: bp.width * _progress,
                decoration: const BoxDecoration(gradient: SC.gradient),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `.navBar`: transparent until scrolled, then frosted; collapsible menu ≤860px.
class _SimpleNavBar extends StatelessWidget {
  final bool scrolled;
  final String active;
  final bool menuOpen;
  final ValueChanged<String> onNavigate;
  final VoidCallback onToggleMenu;
  final VoidCallback onSwitchView;

  const _SimpleNavBar({
    required this.scrolled,
    required this.active,
    required this.menuOpen,
    required this.onNavigate,
    required this.onToggleMenu,
    required this.onSwitchView,
  });

  @override
  Widget build(BuildContext context) {
    final bp = SBp.of(context);
    // The original collapses the nav at ≤860px. With the added "Developer view"
    // button the inline links no longer fit below ~1050px, so collapse at ≤1100px.
    final mobile = bp.width <= 1100;
    // Collapsed, the bar is always frosted; `.scrolled` tightens it further.
    final frosted = scrolled || mobile;
    final bg = scrolled
        ? const Color(0xB8F7F9FB) // rgba(247,249,251,.72)
        : (mobile ? const Color(0xE6F7F9FB) : const Color(0x00F7F9FB)); // .9 on mobile
    final blur = scrolled ? 18.0 : 12.0;

    final logo = SimpleLogo(onTap: () => onNavigate('homePage'));
    final viewSwitch = _ViewSwitch(onTap: onSwitchView, compact: bp.le860);

    Widget bar = AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: SC.ease,
      padding: EdgeInsets.symmetric(vertical: scrolled ? 10 : 18),
      decoration: BoxDecoration(
        color: bg,
        boxShadow: frosted ? SC.shadowSm : null,
        border: scrolled ? const Border(bottom: BorderSide(color: SC.line)) : null,
      ),
      child: SMaxWidth(
        child: mobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      logo,
                      const Spacer(),
                      viewSwitch,
                      const SizedBox(width: 8),
                      SHover(
                        onTap: onToggleMenu,
                        builder: (context, _) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: FaIcon(menuOpen ? FontAwesomeIcons.xmark : FontAwesomeIcons.bars,
                              size: 22, color: SC.ink),
                        ),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 400),
                    curve: SC.ease,
                    alignment: Alignment.topCenter,
                    child: menuOpen
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (final l in _navLinks)
                                  _MenuLink(
                                    label: l.$1,
                                    active: active == l.$2,
                                    mobile: true,
                                    onTap: () => onNavigate(l.$2),
                                  ),
                              ],
                            ),
                          )
                        : const SizedBox(width: double.infinity),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  logo,
                  Row(
                    spacing: 4,
                    children: [
                      for (final l in _navLinks)
                        _MenuLink(label: l.$1, active: active == l.$2, onTap: () => onNavigate(l.$2)),
                    ],
                  ),
                  viewSwitch,
                ],
              ),
      ),
    );

    if (frosted) {
      bar = ClipRect(
        child: BackdropFilter(filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur), child: bar),
      );
    }
    return bar;
  }
}

/// `.menu li a`: pill link with a hover underline; highlighted when active.
class _MenuLink extends StatelessWidget {
  final String label;
  final bool active;
  final bool mobile;
  final VoidCallback onTap;
  const _MenuLink({required this.label, required this.active, required this.onTap, this.mobile = false});

  @override
  Widget build(BuildContext context) {
    return SHover(
      onTap: onTap,
      builder: (context, hovered) {
        final color = active ? SC.primaryDark : (hovered ? SC.ink : SC.inkSoft);
        final text = Text(label,
            textAlign: mobile ? TextAlign.center : TextAlign.start,
            style: sBody(15, weight: FontWeight.w500, color: color));
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: SC.ease,
          padding: mobile
              ? const EdgeInsets.symmetric(horizontal: 10, vertical: 14)
              : const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: active ? SC.primarySoft : SC.primarySoft.withValues(alpha: 0),
            borderRadius: BorderRadius.circular(mobile ? 12 : 999),
          ),
          child: mobile
              ? text
              : Stack(
                  clipBehavior: Clip.none,
                  children: [
                    text,
                    // ::after underline, grows from the left on hover (not on the active link)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: -6,
                      height: 2,
                      child: AnimatedScale(
                        scale: hovered && !active ? 1 : 0,
                        alignment: Alignment.centerLeft,
                        duration: const Duration(milliseconds: 300),
                        curve: SC.ease,
                        child: const ColoredBox(color: SC.primary),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

/// "Developer view" switch back to the Apple-theme portfolio.
class _ViewSwitch extends StatelessWidget {
  final VoidCallback onTap;
  final bool compact; // ≤860px: 13px, 7×12 padding
  const _ViewSwitch({required this.onTap, required this.compact});

  @override
  Widget build(BuildContext context) {
    final size = compact ? 13.0 : 14.0;
    return Tooltip(
      message: 'Switch to developer view',
      waitDuration: const Duration(milliseconds: 600),
      child: SHover(
        onTap: onTap,
        builder: (context, hovered) {
          final fg = hovered ? SC.primaryDark : SC.ink;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: SC.ease,
            transform: Matrix4.translationValues(0, hovered ? -2 : 0, 0),
            padding: compact
                ? const EdgeInsets.symmetric(horizontal: 12, vertical: 7)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: SC.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: hovered ? SC.primary : SC.line, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                FaIcon(FontAwesomeIcons.code, size: size, color: fg),
                Text('Developer view',
                    softWrap: false, style: sBody(size, weight: FontWeight.w600, color: fg, height: kNormalLeading)),
              ],
            ),
          );
        },
      ),
    );
  }
}

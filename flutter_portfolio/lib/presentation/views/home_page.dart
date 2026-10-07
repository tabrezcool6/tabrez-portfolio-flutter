import 'package:flutter/material.dart';

import '../../core/theme/apple_theme.dart';
import '../widgets/apple_footer.dart';
import '../widgets/apple_navbar.dart';
import '../widgets/bento_grid_section.dart';
import '../widgets/code_inspector_section.dart';
import '../widgets/compare_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/projects_section.dart';

/// Page shell mirroring src/App.tsx.
class HomePage extends StatefulWidget {
  /// Switches the page to the simple (non-technical) portfolio view.
  final VoidCallback onSwitchView;
  const HomePage({super.key, required this.onSwitchView});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scroll = ScrollController();
  final _contactName = FocusNode();
  final _keys = {for (final link in navLinks) link.$2: GlobalKey()};

  bool _scrolled = false;
  bool _menuOpen = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final scrolled = _scroll.offset > 20;
      if (scrolled != _scrolled) setState(() => _scrolled = scrolled);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _contactName.dispose();
    super.dispose();
  }

  Future<void> _scrollTo(String id) async {
    setState(() => _menuOpen = false);
    final ctx = _keys[id]?.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
  }

  void _scrollToContact() {
    _scrollTo('contact');
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _contactName.requestFocus();
    });
  }

  void _scrollToTop() =>
      _scroll.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);

  @override
  Widget build(BuildContext context) {
    final bp = Bp.of(context);

    return Scaffold(
      backgroundColor: Tw.black,
      body: Stack(
        children: [
          RawScrollbar(
            controller: _scroll,
            thumbVisibility: true,
            thickness: 8,
            radius: const Radius.circular(4),
            thumbColor: const Color(0xFF27272A),
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SelectionArea(
                child: SingleChildScrollView(
                  controller: _scroll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HeroSection(
                        key: _keys['overview'],
                        onOpenContact: _scrollToContact,
                        onExploreProjects: () => _scrollTo('projects'),
                      ),
                      BentoGridSection(key: _keys['engineering']),
                      ProjectsSection(key: _keys['projects']),
                      CodeInspectorSection(key: _keys['architecture']),
                      const CompareSection(),
                      ExperienceSection(key: _keys['experience']),
                      ContactSection(key: _keys['contact'], nameFocus: _contactName),
                      AppleFooter(onNavigate: _scrollTo, onBackToTop: _scrollToTop),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_menuOpen && !bp.md)
            Positioned(
              top: 48,
              left: 0,
              right: 0,
              bottom: 0,
              child: MobileMenu(
                onNavigate: _scrollTo,
                onOpenContact: _scrollToContact,
                onSwitchView: widget.onSwitchView,
              ),
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppleNavbar(
              scrolled: _scrolled,
              menuOpen: _menuOpen,
              onNavigate: _scrollTo,
              onOpenContact: _scrollToContact,
              onToggleMenu: () => setState(() => _menuOpen = !_menuOpen),
              onSwitchView: widget.onSwitchView,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Sections of the one-page public site, in page order.
enum SiteSection { home, howTo, about, contact }

class SectionNav {
  SectionNav._();

  static Map<SiteSection, GlobalKey>? _keys;
  static ScrollController? _controller;

  /// Section currently in view (updated by HomeScreen while scrolling).
  static final ValueNotifier<SiteSection> active =
      ValueNotifier<SiteSection>(SiteSection.home);

  /// True while the one-page home screen is on screen.
  static bool get attached => _keys != null;

  static void attach(Map<SiteSection, GlobalKey> keys, ScrollController c) {
    _keys = keys;
    _controller = c;
  }

  static void detach(ScrollController c) {
    if (identical(_controller, c)) {
      _keys = null;
      _controller = null;
    }
  }

  /// Smoothly scrolls so the section's top sits right under the nav bar.
  static Future<void> scrollTo(SiteSection s) async {
    final ctx = _keys?[s]?.currentContext;
    if (ctx == null || !ctx.mounted) return;
    await Scrollable.ensureVisible(
      ctx,
      alignment: 0.0,
      duration: const Duration(milliseconds: 750),
      curve: Curves.easeInOutCubic,
    );
  }
}

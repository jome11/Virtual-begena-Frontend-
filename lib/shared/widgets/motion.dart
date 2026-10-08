import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Offset from;
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.from = const Offset(0, 0.12),
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  final _detectorKey = UniqueKey();
  bool _shown = false;
  bool _queued = false;

  void _onVisible(VisibilityInfo info) {
    if (_shown || _queued || info.visibleFraction < 0.12) return;
    _queued = true;
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _shown = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return widget.child;
    return VisibilityDetector(
      key: _detectorKey,
      onVisibilityChanged: _onVisible,
      child: AnimatedSlide(
        offset: _shown ? Offset.zero : widget.from,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: _shown ? 1 : 0,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}

class HoverLift extends StatefulWidget {
  final Widget child;
  const HoverLift({super.key, required this.child});

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedSlide(
        offset: _hover ? const Offset(0, -0.025) : Offset.zero,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedScale(
          scale: _hover ? 1.02 : 1,
          duration: const Duration(milliseconds: 180),
          child: widget.child,
        ),
      ),
    );
  }
}

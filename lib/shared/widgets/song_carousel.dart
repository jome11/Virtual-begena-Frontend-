import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/carousel_images.dart';

class SongCarousel extends StatefulWidget {
  final Duration autoAdvanceInterval;
  const SongCarousel({super.key, this.autoAdvanceInterval = const Duration(seconds: 3)});

  @override
  State<SongCarousel> createState() => _SongCarouselState();
}

class _SongCarouselState extends State<SongCarousel> {
  late final PageController _controller;
  Timer? _timer;
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.28, initialPage: 0);
    _controller.addListener(() {
      setState(() => _page = _controller.page ?? 0);
    });
    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    _timer = Timer.periodic(widget.autoAdvanceInterval, (_) => _goTo(_currentIndex + 1));
  }

  void _pauseThenResume() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 6), _startAutoAdvance);
  }

  int get _currentIndex => _page.round();

  void _goTo(int index) {
    if (!_controller.hasClients) return;
    final target = index % carouselImages.length;
    _controller.animateToPage(target, duration: const Duration(milliseconds: 500), curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.of(context).size.width < 700;
    return Column(
      children: [
        SizedBox(
          height: narrow ? 220 : 320,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
                controller: _controller,
                // Using a very large number for infinite scroll simulation or just the length
                itemCount: carouselImages.length * 1000, 
                onPageChanged: (_) => _pauseThenResume(),
                itemBuilder: (context, index) {
                  final i = index % carouselImages.length;
                  final distance = (index - _page).abs().clamp(0.0, 1.0);
                  final scale = 1 - (distance * 0.35);
                  final opacity = 1 - (distance * 0.7);
                  return Center(
                    child: Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity.clamp(0.25, 1.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            carouselImages[i].assetPath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) => Container(
                              color: AppColors.brandBeige,
                              alignment: Alignment.center,
                              child: const Icon(Icons.music_note_rounded, color: AppColors.brandAmber, size: 32),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(left: 4, child: _ArrowButton(icon: Icons.chevron_left, onTap: () => _goTo(_currentIndex - 1))),
              Positioned(right: 4, child: _ArrowButton(icon: Icons.chevron_right, onTap: () => _goTo(_currentIndex + 1))),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(carouselImages.length, (i) {
            final active = i == (_currentIndex % carouselImages.length);
            return GestureDetector(
              onTap: () {
                // This logic needs to find the "closest" page i to navigate correctly in a huge range
                // For simplicity, just jump to the clicked dot's index in the first set for now 
                // or improve the _goTo to handle the large itemCount.
                _goTo(i);
                _pauseThenResume();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active ? AppColors.brandAmber : AppColors.brandBeige,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.brandInk.withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

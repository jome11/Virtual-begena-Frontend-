import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/services/hand_tracking_service.dart';

class CameraPanel extends StatelessWidget {
  final HandTrackingService service;
  final Widget? readyChild;

  const CameraPanel({super.key, required this.service, this.readyChild});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: service,
      builder: (context, _) => AspectRatio(
        aspectRatio: 4 / 3,
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: context.colors.textSecondary.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // IMPORTANT: readyChild (CameraFeedView) must always be mounted,
              // not just once isReady is true. It's what creates the actual
              // <video>/<canvas> DOM elements that the JS hand-tracking code
              // looks up by id when start() is called. If it's only mounted
              // after isReady, the elements can never be found and isReady
              // never flips — a permanent "Starting camera…" deadlock.
              if (readyChild != null) readyChild!,
              if (!service.isReady)
                Container(
                  color: context.colors.surface,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.videocam_outlined,
                          size: 36,
                          color: context.colors.textSecondary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Starting camera…',
                          style: TextStyle(
                            color: context.colors.textSecondary.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

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
          child: Center(
            child: service.isReady
                ? (readyChild ?? const SizedBox.shrink())
                : Column(
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
      ),
    );
  }
}

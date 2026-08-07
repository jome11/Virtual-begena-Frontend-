import 'package:flutter/material.dart';
import '../../core/services/js/camera_view_registrar.dart';

/// The actual live camera feed: a mirrored <video> with a <canvas> overlay
/// on top of it (for hand-tracking skeleton drawing).
///
/// This is what should be passed as `CameraPanel(readyChild: ...)` once the
/// hand-tracking service reports `isReady == true`.
class CameraFeedView extends StatefulWidget {
  const CameraFeedView({super.key});

  @override
  State<CameraFeedView> createState() => _CameraFeedViewState();
}

class _CameraFeedViewState extends State<CameraFeedView> {
  @override
  void initState() {
    super.initState();
    // MUST run before the HtmlElementViews below are built, or you get
    // PlatformException(unregistered_view_type, ...).
    CameraViewRegistrar.ensureRegistered();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        fit: StackFit.expand,
        children: const [
          HtmlElementView(viewType: CameraViewRegistrar.videoViewId),
          HtmlElementView(viewType: CameraViewRegistrar.canvasViewId),
        ],
      ),
    );
  }
}
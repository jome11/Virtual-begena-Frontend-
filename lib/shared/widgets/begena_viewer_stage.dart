import 'package:flutter/material.dart';
import '../../core/services/js/begena_view_registrar.dart';

/// The raw <div> the 3D canvas mounts into. Keep this always mounted —
/// begenaBridge.mount() looks it up by id, same as the camera feed's
/// video/canvas elements; building it only after some "ready" flag
/// causes a permanent loading deadlock.
class BegenaViewerStage extends StatefulWidget {
  const BegenaViewerStage({super.key});

  @override
  State<BegenaViewerStage> createState() => _BegenaViewerStageState();
}

class _BegenaViewerStageState extends State<BegenaViewerStage> {
  @override
  void initState() {
    super.initState();
    BegenaViewRegistrar.ensureRegistered();
  }

  @override
  Widget build(BuildContext context) {
    return const HtmlElementView(viewType: BegenaViewRegistrar.stageViewId);
  }
}

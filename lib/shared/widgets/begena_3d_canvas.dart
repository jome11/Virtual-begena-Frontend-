import 'package:flutter/material.dart';
import '../../core/services/js/begena_3d_canvas_registrar.dart';
import '../../core/services/js/begena_3d_interop.dart';

class Begena3DCanvas extends StatefulWidget {
  final double height;
  const Begena3DCanvas({super.key, this.height = 420});

  @override
  State<Begena3DCanvas> createState() => _Begena3DCanvasState();
}

class _Begena3DCanvasState extends State<Begena3DCanvas> {
  @override
  void initState() {
    super.initState();
    Begena3DCanvasRegistrar.ensureRegistered();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Begena3DInterop.mount(Begena3DCanvasRegistrar.canvasViewId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: const HtmlElementView(viewType: Begena3DCanvasRegistrar.canvasViewId),
    );
  }
}

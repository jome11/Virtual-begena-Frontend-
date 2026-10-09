import 'dart:js_interop';
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class Begena3DModel extends StatefulWidget {
  final double height;
  const Begena3DModel({super.key, this.height = 420});

  static const _viewType = 'begena-3d-model';
  static bool _registered = false;
  static final ValueNotifier<bool> _loaded = ValueNotifier<bool>(false);

  static void _ensureRegistered() {
    if (_registered) return;
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int _) {
      final el = web.document.createElement('model-viewer') as web.HTMLElement;
      el.setAttribute('src', 'models/Gebena.glb');
      el.setAttribute('loading', 'eager');
      el.setAttribute('reveal', 'auto');
      el.setAttribute('camera-controls', '');
      el.setAttribute('exposure', '1.1');
      el.setAttribute('shadow-intensity', '1');
      el.setAttribute('interaction-prompt', 'none');
      el.setAttribute('auto-rotate', '');
      el.setAttribute('rotation-per-second', '18deg');
      el.setAttribute('disable-zoom', '');
      el.setAttribute('touch-action', 'pan-y');
      el.style.width = '100%';
      el.style.height = '100%';
      el.style.backgroundColor = 'transparent';
      el.addEventListener(
        'load',
        ((web.Event _) {
          _loaded.value = true;
        }).toJS,
      );
      return el;
    });
    _registered = true;
  }

  @override
  State<Begena3DModel> createState() => _Begena3DModelState();
}

class _Begena3DModelState extends State<Begena3DModel> {
  @override
  void initState() {
    super.initState();
    Begena3DModel._ensureRegistered();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const HtmlElementView(viewType: Begena3DModel._viewType),
          ValueListenableBuilder<bool>(
            valueListenable: Begena3DModel._loaded,
            builder: (context, loaded, _) => IgnorePointer(
              ignoring: loaded,
              child: AnimatedOpacity(
                opacity: loaded ? 0 : 1,
                duration: const Duration(milliseconds: 400),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Loading 3D model…',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

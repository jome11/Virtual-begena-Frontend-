import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class Begena3DModel extends StatelessWidget {
  final double height;
  const Begena3DModel({super.key, this.height = 420});

  static const _viewType = 'begena-3d-model';
  static bool _registered = false;

  static void _ensureRegistered() {
    if (_registered) return;
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int _) {
      final el = web.document.createElement('model-viewer') as web.HTMLElement;
      el.setAttribute('src', 'models/Gebena.glb');
      el.setAttribute('camera-controls', '');
      el.setAttribute('exposure', '1.1');
      el.setAttribute('shadow-intensity', '1');
      el.setAttribute('interaction-prompt', 'none');
      el.style.width = '100%';
      el.style.height = '100%';
      el.style.backgroundColor = 'transparent';
      return el;
    });
    _registered = true;
  }

  @override
  Widget build(BuildContext context) {
    _ensureRegistered();
    return SizedBox(
      height: height,
      width: double.infinity,
      child: const HtmlElementView(viewType: _viewType),
    );
  }
}
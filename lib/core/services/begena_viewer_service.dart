import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import '../constants/app_strings.dart';
import 'js/begena_viewer_interop.dart';

class BegenaViewerService extends ChangeNotifier {
  Timer? _poll;
  bool _ready = false;
  String? _error;
  String? _selectedId;
  String? _hoveredId;
  Map<String, dynamic>? _partsData;
  Map<String, dynamic>? _enParts;

  bool get ready => _ready;
  String? get error => _error;
  String? get selectedId => _selectedId;
  String? get hoveredId => _hoveredId;
  Map<String, dynamic>? get partsData {
    if (languageNotifier.value == Language.en && _enParts != null) return _enParts;
    return _partsData;
  }

  Future<void> _loadEnglish() async {
    try {
      final res = await web.window.fetch('/begena-viewer/parts.en.json'.toJS).toDart;
      if (!res.ok) return;
      final text = (await res.text().toDart).toDart;
      _enParts = jsonDecode(text) as Map<String, dynamic>;
      notifyListeners();
    } catch (_) {
      // falls back to the Amharic text
    }
  }

  Future<void> mount({
    required String containerId,
    String modelUrl = '/begena-viewer/Gebena.glb',
    String partsUrl = '/begena-viewer/parts.am.json',
  }) async {
    languageNotifier.addListener(notifyListeners);
    _loadEnglish();
    await BegenaViewerInterop.mount(containerId, modelUrl, partsUrl);
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(milliseconds: 150), (_) => _tick());
  }

  void select(String? id) => BegenaViewerInterop.select(id);
  void setView(String name) => BegenaViewerInterop.setView(name);

  void _tick() {
    try {
      final json = BegenaViewerInterop.getStateJson();
      if (json.isEmpty) return;
      final Map<String, dynamic> state = jsonDecode(json) as Map<String, dynamic>;
      _applyState(state);
    } catch (_) {
      // JS side not ready yet
    }
  }

  void _applyState(Map<String, dynamic> state) {
    final ready = state['ready'] as bool? ?? false;
    final error = state['error'] as String?;
    final selectedId = state['selectedId'] as String?;
    final hoveredId = state['hoveredId'] as String?;

    bool changed = false;
    if (ready != _ready) {
      _ready = ready;
      changed = true;
      if (ready && _partsData == null) _loadParts();
    }
    if (error != _error) {
      _error = error;
      changed = true;
    }
    if (selectedId != _selectedId) {
      _selectedId = selectedId;
      changed = true;
    }
    if (hoveredId != _hoveredId) {
      _hoveredId = hoveredId;
      changed = true;
    }

    if (changed) notifyListeners();
  }

  void _loadParts() {
    final json = BegenaViewerInterop.getPartsJson();
    if (json.isEmpty) return;
    _partsData = jsonDecode(json) as Map<String, dynamic>;
    notifyListeners();
  }

  @override
  void dispose() {
    languageNotifier.removeListener(notifyListeners);
    _poll?.cancel();
    BegenaViewerInterop.destroy();
    super.dispose();
  }
}

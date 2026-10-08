import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'app.dart';
import 'core/theme/app_theme.dart';
import 'core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  VisibilityDetectorController.instance.updateInterval = const Duration(milliseconds: 100);
  
  // Restore session if token exists
  await authService.restoreSession();

  runApp(
    ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return const VirtualBegenaApp();
      },
    ),
  );
}

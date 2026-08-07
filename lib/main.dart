import 'package:flutter/material.dart';
import 'app.dart';
import 'core/theme/app_theme.dart';
import 'core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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

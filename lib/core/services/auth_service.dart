import 'package:flutter/material.dart';

/// Abstract contract for authentication. UI code (login screen, dashboard)
/// only ever talks to this interface — never to a specific backend.
///
/// TODO: when the real backend is chosen (Firebase Auth, custom API, etc.),
/// create a new class implementing AuthService (e.g. FirebaseAuthService)
/// and swap the singleton created below. No other file needs to change.
abstract class AuthService extends ChangeNotifier {
  String? get currentUsername;
  bool get isSignedIn => currentUsername != null;

  Future<String?> signIn({required String username, required String password});
  Future<void> signOut();
}

/// Placeholder implementation: accepts any non-empty username/password and
/// "signs in" locally. No network calls, nothing persisted between app
/// restarts. Replace with a real implementation once the backend is ready.
class LocalAuthService extends AuthService {
  String? _currentUsername;

  @override
  String? get currentUsername => _currentUsername;

  @override
  Future<String?> signIn({required String username, required String password}) async {
    if (username.trim().isEmpty || password.isEmpty) {
      return 'Enter a username and password';
    }
    // Simulate a network round-trip so the UI's loading state has something to show.
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUsername = username.trim();
    notifyListeners();
    return null; // null = success
  }

  @override
  Future<void> signOut() async {
    _currentUsername = null;
    notifyListeners();
  }
}

/// App-wide singleton. Swap this one line to change backends.
final AuthService authService = LocalAuthService();

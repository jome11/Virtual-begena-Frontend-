import 'package:flutter/material.dart';
import 'api_client.dart';
import 'token_storage.dart';

abstract class AuthService extends ChangeNotifier {
  String? get currentUsername;
  bool get isSignedIn => currentUsername != null;

  Future<String?> signIn({required String username, required String password});
  Future<String?> signUp({required String name, required String email, required String password});
  Future<void> signOut();
  Future<void> restoreSession();
}

class ApiAuthService extends AuthService {
  String? _currentUsername;

  @override
  String? get currentUsername => _currentUsername;

  @override
  Future<String?> signIn({required String username, required String password}) async {
    try {
      final data = await ApiClient.post('/auth/login', {'email': username, 'password': password}, auth: false);
      await TokenStorage.save(data['token']);
      _currentUsername = data['user']['name'];
      notifyListeners();
      return null;
    } on ApiException catch (e) {
      return e.message;
    } catch (_) {
      return 'Could not reach the server';
    }
  }

  @override
  Future<String?> signUp({required String name, required String email, required String password}) async {
    try {
      final data = await ApiClient.post('/auth/signup', {'name': name, 'email': email, 'password': password}, auth: false);
      await TokenStorage.save(data['token']);
      _currentUsername = data['user']['name'];
      notifyListeners();
      return null;
    } on ApiException catch (e) {
      return e.message;
    } catch (_) {
      return 'Could not reach the server';
    }
  }

  @override
  Future<void> signOut() async {
    await TokenStorage.clear();
    _currentUsername = null;
    notifyListeners();
  }

  @override
  Future<void> restoreSession() async {
    final token = await TokenStorage.read();
    if (token == null) return;
    try {
      final data = await ApiClient.get('/auth/me');
      _currentUsername = data['user']['name'];
      notifyListeners();
    } catch (_) {
      await TokenStorage.clear();
    }
  }
}

final AuthService authService = ApiAuthService();

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/curriculum.dart' show tr;
import '../../core/services/auth_service.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../shared/widgets/gradient_background.dart';

class OAuthCallbackScreen extends StatefulWidget {
  final String? code;
  final String? error;
  const OAuthCallbackScreen({super.key, this.code, this.error});

  @override
  State<OAuthCallbackScreen> createState() => _OAuthCallbackScreenState();
}

class _OAuthCallbackScreenState extends State<OAuthCallbackScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    if (widget.error != null || widget.code == null || widget.code!.isEmpty) {
      setState(() => _error = tr('መግባት አልተሳካም። እንደገና ይሞክሩ።', 'Sign-in failed. Please try again.'));
      return;
    }
    final err = await authService.signInWithCode(widget.code!);
    if (!mounted) return;
    if (err == null) {
      context.go('/dashboard');
    } else {
      setState(() => _error = err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Card(
            color: context.colors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_error == null) ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      tr('እየገቡ ነው…', 'Signing you in…'),
                      style: TextStyle(color: context.colors.textPrimary),
                    ),
                  ] else ...[
                    const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 40),
                    const SizedBox(height: 12),
                    Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.go('/login'),
                      child: Text(tr('ወደ መግቢያ ተመለስ', 'Back to sign in')),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

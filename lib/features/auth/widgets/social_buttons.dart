import 'package:flutter/material.dart';
import '../../../core/data/curriculum.dart' show tr;
import '../../../core/services/auth_service.dart';

class SocialButtons extends StatelessWidget {
  // (route name on the backend, label, icon)
  static const _providers = <(String, String, IconData)>[
    ('google', 'Google', Icons.g_mobiledata_rounded),
  ];

  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final p in _providers) ...[
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => authService.startOAuth(p.$1),
              icon: Icon(p.$3, size: 24),
              label: Text(tr('በ${p.$2} ይቀጥሉ', 'Continue with ${p.$2}')),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

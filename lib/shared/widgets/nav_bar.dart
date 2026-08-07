import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';

class NavBar extends StatefulWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      child: Row(
        children: [
          Text(
            AppStrings.get('app_title'),
            style: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 0.4),
          ),
          const Spacer(),
          if (MediaQuery.of(context).size.width > 700) ...[
            _NavLink(label: AppStrings.get('home'), onTap: () => context.go('/home')),
            _NavLink(label: AppStrings.get('lessons'), onTap: () => context.go('/lessons')),
            _NavLink(label: AppStrings.get('about'), onTap: () => context.go('/about')),
            _NavLink(label: AppStrings.get('contact'), onTap: () => context.go('/contact')),
            const SizedBox(width: 12),
          ],
          OutlinedButton(
            onPressed: () => context.go('/login'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.borderSubtle),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(AppStrings.get('get_started'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14),
    child: TextButton(
      onPressed: onTap,
      child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500)),
    ),
  );
}

import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/brand_palette.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return TextButton(
          onPressed: () {
            languageNotifier.value = lang == Language.en ? Language.am : Language.en;
          },
          child: Text(
            lang == Language.en ? 'አማ' : 'EN',
            style: TextStyle(
              color: brand.amber,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        );
      },
    );
  }
}

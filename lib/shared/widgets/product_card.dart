import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/constants/app_strings.dart';
import '../../core/models/product.dart';
import '../../core/services/cart_service.dart';
import 'panel_card.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                product.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: context.colors.background,
                  child: const Icon(Icons.image_not_supported, size: 40),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.get(product.nameKey),
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.get(product.descriptionKey),
            style: TextStyle(color: context.colors.textSecondary, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${product.price.toStringAsFixed(0)} ETB',
                style: TextStyle(
                  color: context.colors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  cartService.add(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${AppStrings.get(product.nameKey)} ${languageNotifier.value == Language.en ? 'added to cart' : 'ወደ ጋሪ ተጨምሯል'}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: const Size(0, 36),
                ),
                child: Text(AppStrings.get('add_to_cart')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

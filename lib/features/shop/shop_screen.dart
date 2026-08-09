import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/constants/app_strings.dart';
import '../../core/data/products_data.dart';
import '../../core/services/cart_service.dart';
import '../../shared/widgets/nav_bar.dart';
import '../../shared/widgets/site_footer.dart';
import '../../shared/widgets/product_card.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _selectedCategory = 'all';

  List<dynamic> get _filteredProducts => _selectedCategory == 'all'
      ? products
      : products.where((p) => p.category == _selectedCategory).toList();

  String _label(String cat) {
    switch (cat) {
      case 'begena':
        return AppStrings.get('cat_begena');
      case 'horn':
        return AppStrings.get('cat_kende');
      case 'strings':
        return AppStrings.get('cat_strings');
      default:
        return AppStrings.get('cat_all');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Scaffold(
          appBar: const NavBar(),
          backgroundColor: context.colors.background,
          floatingActionButton: AnimatedBuilder(
            animation: cartService,
            builder: (context, _) => cartService.itemCount == 0
                ? const SizedBox.shrink()
                : FloatingActionButton.extended(
                    onPressed: () => context.go('/cart'),
                    icon: const Icon(Icons.shopping_cart),
                    label: Text('${AppStrings.get('your_cart')} (${cartService.itemCount})'),
                  ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  width: double.infinity,
                  color: context.colors.background.withValues(alpha: 0.6),
                  child: Center(
                    child: Text(
                      AppStrings.get('shop'),
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Wrap(
                    spacing: 10,
                    alignment: WrapAlignment.center,
                    children: ['all', ...productCategories].map((cat) {
                      final selected = _selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(_label(cat)),
                        selected: selected,
                        onSelected: (_) => setState(() => _selectedCategory = cat),
                        selectedColor: context.colors.accent,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : context.colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final columns = c.maxWidth > 900 ? 3 : (c.maxWidth > 600 ? 2 : 1);
                      final list = _filteredProducts;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: list.length,
                        itemBuilder: (context, i) => ProductCard(product: list[i]),
                      );
                    },
                  ),
                ),
                const SiteFooter(),
              ],
            ),
          ),
        );
      },
    );
  }
}

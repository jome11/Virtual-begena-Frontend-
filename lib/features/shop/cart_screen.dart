import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/cart_service.dart';
import '../../shared/widgets/nav_bar.dart';
import '../../shared/widgets/panel_card.dart';

enum PaymentMethod { cashOnDelivery, telebirr, bankTransfer }

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.cashOnDelivery;
  bool _submitting = false;

  Future<void> _placeOrder() async {
    if (cartService.items.isEmpty) return;

    setState(() => _submitting = true);

    // No backend yet — just simulate a brief "processing" moment
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    cartService.clear();
    setState(() => _submitting = false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order placed!'),
        content: const Text('We\'ll contact you shortly to confirm your order.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/shop');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _methodLabel(PaymentMethod m) {
    switch (m) {
      case PaymentMethod.cashOnDelivery:
        return 'Cash on Delivery';
      case PaymentMethod.telebirr:
        return 'Telebirr';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
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
          body: AnimatedBuilder(
            animation: cartService,
            builder: (context, _) {
              if (cartService.items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 48, color: context.colors.textSecondary),
                        const SizedBox(height: 16),
                        Text('Your cart is empty',
                            style: TextStyle(
                                color: context.colors.textSecondary, fontSize: 16)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                            onPressed: () => context.go('/shop'),
                            child: const Text('Browse Shop')),
                      ],
                    ),
                  ),
                );
              }
              return SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Your Cart',
                              style: TextStyle(
                                  color: context.colors.textPrimary,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          ...cartService.items.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: PanelCard(
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          item.product.imagePath,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              Container(
                                            width: 60,
                                            height: 60,
                                            color: context.colors.background,
                                            child: const Icon(Icons.image_not_supported),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item.product.name,
                                                style: TextStyle(
                                                    color: context.colors.textPrimary,
                                                    fontWeight: FontWeight.bold)),
                                            Text(
                                                '${item.product.price.toStringAsFixed(0)} ETB',
                                                style: TextStyle(
                                                    color: context.colors.textSecondary,
                                                    fontSize: 13)),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                          icon: const Icon(Icons.remove_circle_outline),
                                          onPressed: () => cartService.updateQuantity(
                                              item.product.id, item.quantity - 1)),
                                      Text('${item.quantity}'),
                                      IconButton(
                                          icon: const Icon(Icons.add_circle_outline),
                                          onPressed: () => cartService.updateQuantity(
                                              item.product.id, item.quantity + 1)),
                                    ],
                                  ),
                                ),
                              )),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                'Total: ${cartService.total.toStringAsFixed(0)} ETB',
                                style: TextStyle(
                                    color: context.colors.accent,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 28),
                          Text('Payment Method',
                              style: TextStyle(
                                  color: context.colors.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          ...PaymentMethod.values.map((m) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: PanelCard(
                                  child: RadioListTile<PaymentMethod>(
                                    value: m,
                                    groupValue: _selectedMethod,
                                    onChanged: (v) =>
                                        setState(() => _selectedMethod = v!),
                                    title: Text(_methodLabel(m),
                                        style: TextStyle(
                                            color: context.colors.textPrimary,
                                            fontWeight: FontWeight.w600)),
                                    activeColor: context.colors.accent,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              )),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _submitting ? null : _placeOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.colors.accent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: _submitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white))
                                : const Text('Place Order',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

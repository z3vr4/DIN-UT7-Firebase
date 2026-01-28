import 'package:ut7_firebase_api/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/cart_view_model.dart';
import 'package:ui_components/product_card.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();

    final totalPrice = cart.items.fold<double>(
      0.0,
      (sum, item) => sum + item.price,
    );

    return ResponsiveScaffold(
      currentIndex: 1,
      onTab: (i) {
        if (i == 0) {
          context.goNamed('home');
        } else if (i == 1) {
          context.goNamed('cart');
        } else if (i == 2) {
          context.goNamed('account');
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Carrito')),
        body: cart.items.isEmpty
            ? const Center(child: Text('El carrito está vacío'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // texto con el total del carrito
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 👈 CLAVE
                      children: [
                        Text(
                          'Total: ${totalPrice.toStringAsFixed(2)} €',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Objetos: ${cart.items.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // lista de productos en el carrito
                  Expanded(
                    child: ListView.separated(
                      itemCount: cart.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, i) {
                        final p = cart.items[i];
                        return GestureDetector(
                          onTap: () {
                            context.pushNamed('detail', extra: p);
                          },
                          child: ProductCard(
                            title: p.title,
                            price: p.price,
                            onPressed: () => cart.remove(p),
                            buttonText: 'Quitar del carrito',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

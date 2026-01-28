import 'package:ut7_firebase_api/data/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ut7_firebase_api/styles/styles.dart';
import 'package:ut7_firebase_api/viewmodels/favorites_viewmodel.dart';
import 'package:ut7_firebase_api/widgets/responsive_scaffold.dart';
import '../../viewmodels/cart_view_model.dart';
import 'package:go_router/go_router.dart';

// remaquetado ligeramente para la UD7
class DetailScreen extends StatelessWidget {
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();
    final favorites = context.watch<FavoritesViewModel>();
    final isFavorite = favorites.isFavorite(product);

    return ResponsiveScaffold(
      currentIndex: 0,
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
        appBar: AppBar(
          title: Text(product.title),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.bar_chart_rounded,
                  color: AppStyles.fondoAlt,
                ),
                onPressed: () => context.pushNamed('report'),
              ),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // nombre del producto
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    product.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // precio y boton de favs
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${product.price.toStringAsFixed(2)} €',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(width: 16),

                    SizedBox(
                      height: 36,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          favorites.toggleFavorite(product);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          backgroundColor: AppStyles.fondoSuave,
                          foregroundColor: AppStyles.rojoPrimario,
                          side: const BorderSide(
                            color: AppStyles.rojoPrimario,
                            width: 1.5,
                          ),
                        ),
                        icon: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          size: 20,
                        ),
                        label: Text(isFavorite ? 'Quitar' : 'Favoritos'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // descripcion
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    product.descripcion,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // añadir al carrito
                SizedBox(
                  width: 220,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.rojoPrimario,
                      foregroundColor: AppStyles.fondoSuave,
                    ),
                    onPressed: () => cart.add(product),
                    child: const Text('Añadir al carrito'),
                  ),
                ),

                const SizedBox(height: 12),

                // ver carrito
                SizedBox(
                  width: 220,
                  height: 48,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppStyles.fondoSuave,
                      side: const BorderSide(
                        color: AppStyles.rojoPrimario,
                        width: 2,
                      ),
                      foregroundColor: AppStyles.rojoPrimario,
                    ),
                    onPressed: () => context.pushNamed('cart'),
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.shopping_cart, size: 28),
                        if (cart.count > 0)
                          Positioned(
                            right: -6,
                            top: -6,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppStyles.fondoSuave,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppStyles.rojoPrimario,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  cart.count.toString(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppStyles.rojoPrimario,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    label: const Text('Ver mi carrito'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

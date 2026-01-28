import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ut7_firebase_api/styles/styles.dart';
import 'package:ut7_firebase_api/viewmodels/cart_view_model.dart';
import 'package:ut7_firebase_api/viewmodels/favorites_viewmodel.dart';
import 'package:ui_components/product_card.dart';

class AccountView extends StatelessWidget {
  final User user;

  const AccountView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final bool isAnonymous = user.email == null;
    final userVM = context.watch<FavoritesViewModel>();
    final favoriteProducts = userVM.favorites;
    final cart = context.read<CartViewModel>();

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // sesion activa
                Text(
                  isAnonymous
                      ? 'Sesión de invitado'
                      : 'Sesión iniciada con ${user.email}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // botón cerrar sesión
                SizedBox(
                  width: 300,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await userVM.signOut();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppStyles.fondoSuave,
                      foregroundColor: AppStyles.rojoSecundario,
                      side: const BorderSide(color: AppStyles.rojoSecundario),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar sesión'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // seccion de favoritos
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Favoritos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                if (favoriteProducts.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: favoriteProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final p = favoriteProducts[i];
                      return GestureDetector(
                        onTap: () => context.pushNamed('detail', extra: p),
                        child: ProductCard(
                          title: p.title,
                          price: p.price,
                          onPressed: () => cart.add(p),
                          buttonText: 'Añadir al carrito',
                        ),
                      );
                    },
                  )
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'No tienes productos favoritos aún.',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

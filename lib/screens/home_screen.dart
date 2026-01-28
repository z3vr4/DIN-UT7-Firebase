import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_components/product_card.dart';
import 'package:ut7_firebase_api/api/api_client.dart';
import 'package:ut7_firebase_api/data/product.dart';
import 'package:ut7_firebase_api/styles/styles.dart';
import '../../viewmodels/cart_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:ut7_firebase_api/widgets/responsive_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<List<Product>> _productsFuture;
  final ApiClient _apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    // carga inicial de los productos
    _productsFuture = _apiClient.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();

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
          title: const Text(
            'Productos',
            style: TextStyle(color: AppStyles.fondoAlt),
          ),
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: FutureBuilder<List<Product>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              // estado de carga
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              // estado de error
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error al cargar los productos'),
                );
              }

              final products = snapshot.data!;
              return ListView.separated(
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final p = products[i];
                  return GestureDetector(
                    onTap: () {
                      context.pushNamed('detail', extra: p);
                    },
                    child: ProductCard(
                      title: p.title,
                      price: p.price,
                      onPressed: () => cart.add(p),
                      buttonText: 'Añadir al carrito',
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

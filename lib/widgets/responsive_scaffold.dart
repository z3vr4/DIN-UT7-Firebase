// lib/widgets/responsive_scaffold.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ut7_firebase_api/styles/styles.dart';
import 'package:ut7_firebase_api/viewmodels/cart_view_model.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onTab;

  const ResponsiveScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartViewModel>();
    final cartCount = cart.count;

    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth >= 800;

        if (wide) {
          // Pantalla ancha
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  backgroundColor: AppStyles.rojoSecundario,
                  selectedIndex: currentIndex,
                  onDestinationSelected: onTab,
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: const IconThemeData(
                    color: AppStyles.rojoPrimario,
                  ),
                  unselectedIconTheme: const IconThemeData(color: Colors.white),
                  selectedLabelTextStyle: const TextStyle(color: Colors.white),
                  unselectedLabelTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  destinations: [
                    const NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Productos'),
                    ),
                    NavigationRailDestination(
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.shopping_cart),
                          if (cartCount > 0)
                            Positioned(
                              right: -4,
                              top: -4,
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
                                    cartCount.toString(),
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
                      label: const Text('Carrito'),
                    ),
                    const NavigationRailDestination(
                      icon: Icon(Icons.person),
                      label: Text('Perfil'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: child),
              ],
            ),
          );
        }

        // Pantalla móvil
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTab,
            backgroundColor: AppStyles.rojoSecundario,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Productos',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (cartCount > 0)
                      Positioned(
                        right: -4,
                        top: -4,
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
                              cartCount.toString(),
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
                label: 'Carrito',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        );
      },
    );
  }
}

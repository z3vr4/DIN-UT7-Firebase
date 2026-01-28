import 'package:go_router/go_router.dart';
import 'package:ut7_firebase_api/screens/auth/account_screen.dart';
import 'package:ut7_firebase_api/screens/report_screen.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/cart_screen.dart';
import 'data/product.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/detail',
        name: 'detail',
        builder: (context, state) {
          final product = state.extra as Product;
          return DetailScreen(product: product);
        },
      ),
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/account',
        name: 'account',
        builder: (context, state) => const AccountScreen(),
      ),
      GoRoute(
        path: '/report',
        name: 'report',
        builder: (context, state) => const ReportScreen(),
      ),
    ],
  );
}

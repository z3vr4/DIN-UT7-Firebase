import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ut7_firebase_api/screens/auth/accountview_screen.dart';
import 'package:ut7_firebase_api/screens/auth/login_screen.dart';
import 'package:ut7_firebase_api/styles/styles.dart';
import 'package:ut7_firebase_api/viewmodels/favorites_viewmodel.dart';
import 'package:ut7_firebase_api/widgets/responsive_scaffold.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<FavoritesViewModel>();

    return ResponsiveScaffold(
      currentIndex: 2,
      onTab: (i) {
        if (i == 0) context.goNamed('home');
        if (i == 1) context.goNamed('cart');
        if (i == 2) context.goNamed('account');
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cuenta'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.bar_chart_rounded,
                color: AppStyles.fondoAlt,
              ),
              onPressed: () => context.pushNamed('report'),
            ),
          ],
        ),
        body: _buildBody(userVM),
      ),
    );
  }

  Widget _buildBody(FavoritesViewModel userVM) {
    if (!userVM.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userVM.user == null) {
      return const LoginView();
    }

    return AccountView(user: userVM.user!);
  }
}

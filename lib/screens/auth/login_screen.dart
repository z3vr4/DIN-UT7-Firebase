import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ut7_firebase_api/styles/styles.dart';
import 'package:ut7_firebase_api/viewmodels/favorites_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<FavoritesViewModel>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Iniciar sesión',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                if (_error != null)
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                if (userVM.error != null)
                  Text(
                    userVM.error!,
                    style: const TextStyle(color: Colors.red),
                  ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            setState(() => _loading = true);
                            await userVM.signInEmail(
                              _emailController.text,
                              _passwordController.text,
                            );
                            setState(() => _loading = false);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.rojoSecundario,
                      foregroundColor: AppStyles.fondoSuave,
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppStyles.fondoSuave,
                            ),
                          )
                        : const Text('Entrar con email'),
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            setState(() => _loading = true);
                            await userVM.signInAnonymous();
                            setState(() => _loading = false);
                          },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppStyles.fondoSuave,
                      foregroundColor: AppStyles.rojoSecundario,
                      side: const BorderSide(color: AppStyles.rojoSecundario),
                    ),
                    child: const Text('Entrar como invitado'),
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

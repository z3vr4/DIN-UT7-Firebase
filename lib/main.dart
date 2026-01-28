// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ut7_firebase_api/services/firebase_service.dart';
import 'package:ut7_firebase_api/styles/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ut7_firebase_api/viewmodels/favorites_viewmodel.dart';
import 'firebase_options.dart';
import 'app_router.dart';
import 'viewmodels/cart_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key, FirebaseService? firebaseService})
    : firebaseService = firebaseService ?? FirebaseService();

  final FirebaseService firebaseService;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebaseService.init(),
      builder: (context, snapshot) {
        // loading mientras Firebase arranca
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return MultiProvider(
          providers: [
            Provider.value(value: firebaseService),
            ChangeNotifierProvider(create: (_) => CartViewModel()),
            ChangeNotifierProvider(
              create: (_) => FavoritesViewModel(firebaseService),
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'UD7 · FireBase + API',
            routerConfig: AppRouter.router,
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFFF3F3F3),
              appBarTheme: const AppBarTheme(
                backgroundColor: AppStyles.rojoSecundario,
                foregroundColor: AppStyles.fondoAlt,
              ),
            ),
          ),
        );
      },
    );
  }
}

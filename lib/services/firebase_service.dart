import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../data/product.dart';
import '../firebase_options.dart';

// Servicio de acceso a Firebase (auth anónima + Firestore de favoritos).
//
// "init" debe llamarse antes de usar el servicio. Si la configuración no es
// válida, "isReady" quedará en "false" y la UI mostrará un aviso para
// configurar las credenciales locales.
class FirebaseService {
  bool _initialized = false;
  String? _error;

  String? get error => _error;

  /// flag para inicializacion correcta de firebase
  bool get isReady => _initialized && _error == null;

  // inicializa Firebase
  Future<void> init() async {
    if (_initialized) return;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;
    } catch (e) {
      _error = 'Firebase no inicializado: $e';
    }
  }

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  // login anonimo
  Future<UserCredential> signInAnon() async {
    if (!isReady) {
      throw Exception('Firebase no está listo. Revisa el archivo .env');
    }
    return _auth.signInAnonymously();
  }

  // logout
  Future<void> signOut() async {
    if (!isReady) return;
    await _auth.signOut();
  }

  // guarda o sobrescrive fav "/users/{uid}/favorites/{id}".
  Future<void> saveFavorite(String uid, Product product) {
    // guarda fecha
    final data = product.toMap()..addAll({'ts': FieldValue.serverTimestamp()});
    return _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(
          product.id.toString(),
        ) // a diferencia del ejemplo propuesto, casteo a string aqui y no en producto.
        .set(data, SetOptions(merge: true));
  }

  // elimina el favorito correspondiente a "product.storageId".
  Future<void> removeFavorite(String uid, Product product) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(product.id.toString()) // cast a string aqui tambien
        .delete();
  }

  // devuelve la lista de favoritos del usuario.
  Stream<List<Product>> favoritesStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .orderBy('ts', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList(),
        );
  }
}

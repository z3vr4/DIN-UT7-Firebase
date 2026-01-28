import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ut7_firebase_api/data/product.dart';
import 'package:ut7_firebase_api/services/firebase_service.dart';

class FavoritesViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService;

  FavoritesViewModel(this._firebaseService) {
    _init();
  }

  // estado de usuario y inicialización
  User? _user;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  User? get user => _user;
  bool get isSignedIn => _user != null;

  // favoritos
  List<Product> _favorites = [];
  List<Product> get favorites => List.unmodifiable(_favorites);

  String? _error;
  String? get error => _error;

  StreamSubscription<List<Product>>? _sub;

  // inicialización: escucha cambios de auth y favoritos
  void _init() {
    FirebaseAuth.instance.authStateChanges().listen((u) {
      _user = u;
      _isInitialized = true;

      // reinicia la escucha de favoritos si hay usuario
      _listenFavorites();
      notifyListeners();
    });
  }

  // login anónimo
  Future<void> signInAnonymous() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  // login con email/password
  Future<void> signInEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  // logout
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _favorites = [];
    _sub?.cancel();
    notifyListeners();
  }

  // comprueba si un producto es favorito
  bool isFavorite(Product product) {
    return _favorites.any((p) => p.id == product.id);
  }

  /// Alterna favorito
  Future<void> toggleFavorite(Product product) async {
    if (_user == null) {
      await signInAnonymous();
    }
    final uid = _user?.uid;
    if (uid == null) return;

    final wasFavorite = isFavorite(product);

    // actualiza UI inmediatamente
    _setLocal(product, !wasFavorite);
    notifyListeners();

    try {
      if (wasFavorite) {
        await _firebaseService.removeFavorite(uid, product);
      } else {
        await _firebaseService.saveFavorite(uid, product);
      }
    } catch (e) {
      // revertir si falla
      _setLocal(product, wasFavorite);
      _error = e.toString();
      notifyListeners();
    }
  }

  // escucha favoritos desde Firebase
  void _listenFavorites() {
    final uid = _user?.uid;
    if (uid == null) return;

    _sub?.cancel();
    _sub = _firebaseService.favoritesStream(uid).listen((items) {
      _favorites = items;
      notifyListeners();
    });
  }

  void _setLocal(Product product, bool asFavorite) {
    if (asFavorite) {
      if (!isFavorite(product)) {
        _favorites = [..._favorites, product];
      }
    } else {
      _favorites = _favorites.where((p) => p.id != product.id).toList();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

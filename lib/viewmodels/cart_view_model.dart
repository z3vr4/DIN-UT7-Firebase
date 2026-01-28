import 'package:flutter/material.dart';
import '../data/cart_repository.dart';
import '../data/product.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepository _repo = CartRepository();

  List<Product> get items => _repo.items;

  int get count => _repo.count;

  double get total => _repo.total;

  void add(Product p) {
    _repo.add(p);
    notifyListeners();
  }

  void remove(Product p) {
    _repo.remove(p);
    notifyListeners();
  }

  void clear() {
    _repo.clear();
    notifyListeners();
  }
}

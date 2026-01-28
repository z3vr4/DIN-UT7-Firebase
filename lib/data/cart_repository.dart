import 'product.dart';

class CartRepository {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);
  int get count => _items.length;
  double get total => _items.fold(0, (sum, p) => sum + p.price);

  void add(Product p) {
    _items.add(p);
  }

  void remove(Product p) {
    _items.remove(p);
  }

  void clear() {
    _items.clear();
  }
}

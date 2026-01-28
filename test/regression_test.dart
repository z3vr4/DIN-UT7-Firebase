import 'package:flutter_test/flutter_test.dart';
import 'package:ut7_firebase_api/viewmodels/cart_view_model.dart';
import 'package:ut7_firebase_api/data/product.dart';

void main() {
  test('Eliminar un producto inexistente no altera el carrito (regresión)', () {
    final cart = CartViewModel();
    final product = Product(
      id: 99999999999,
      title: 'Producto 2',
      price: 58.0,
      descripcion:
          'Descripción del producto 2, añadida con el propósito de tener texto para el maquetado y mockup',
      category: 'mock',
      image: 'https://via.placeholder.com/300',
    );

    expect(cart.count, 0);

    cart.remove(product);

    expect(cart.count, 0);
    expect(cart.items.isEmpty, true);
  });
}

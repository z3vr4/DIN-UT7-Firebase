import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:ut7_firebase_api/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Flujo Home -> Cart mantiene estado global', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    // 1. Home visible
    /* nota: he modificado home -> productos por cambios que hice en mi interfaz
    también reemplazado findsOne por findsAny ya que hay varios textos "Productos"
    en pantalla (el del botón de navegación y el mostrador de titulo de pantalla)
    */
    expect(find.text('Productos'), findsAny);

    // 2. Añadir producto
    final addButton = find
        .widgetWithText(ElevatedButton, 'Añadir al carrito')
        .first;
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // 3. Ir al carrito
    await tester.tap(find.byIcon(Icons.shopping_cart).first);
    await tester.pumpAndSettle();

    // 4. Hay productos en el carrito
    expect(find.textContaining('€'), findsWidgets);
  });
}

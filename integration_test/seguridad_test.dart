import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:ut7_firebase_api/main.dart' as app;
import 'package:ut7_firebase_api/api/api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Seguridad - URLs HTTPS', (WidgetTester tester) async {
    // inicializa la app
    app.main();

    // espera a que HomeScreen cargue
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // navega a ReportScreen
    final reportButton = find.widgetWithIcon(
      IconButton,
      Icons.bar_chart_rounded,
    );
    expect(reportButton, findsOneWidget);
    await tester.tap(reportButton);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // comprobación de seguridad: la URL base del ApiClient debe usar https
    final apiClient = ApiClient();
    expect(
      apiClient.baseUrl.startsWith('https://'),
      isTrue,
      reason: 'Todas las peticiones deben usar HTTPS',
    );
  });
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ut7_firebase_api/api/api_client.dart';
import 'package:ut7_firebase_api/data/product.dart';
import 'package:ut7_firebase_api/styles/styles.dart';
import 'package:ut7_firebase_api/viewmodels/favorites_viewmodel.dart';
import 'dart:math';

import 'package:ut7_firebase_api/widgets/responsive_scaffold.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late Future<List<Product>> _productsFuture;
  double _maxPriceFilter = double.infinity;
  bool _onlyFavorites = false;
  int? _hoveredPieIndex;

  @override
  void initState() {
    super.initState();
    final apiClient = ApiClient();
    _productsFuture = apiClient.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesVm = context.watch<FavoritesViewModel>();

    return ResponsiveScaffold(
      currentIndex: 2,
      onTab: (i) {
        if (i == 0) {
          context.goNamed('home');
        } else if (i == 1) {
          context.goNamed('cart');
        } else if (i == 2) {
          context.goNamed('account');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Informe'),
          backgroundColor: AppStyles.rojoSecundario,
          foregroundColor: AppStyles.fondoAlt,
        ),
        body: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            // estado, lógica y variables para presentacion

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('Error cargando datos'));
            }

            // lista de productos
            final allProducts = snapshot.data!;

            // condicional para filtrar todos los productos o solo favoritos
            final sourceProducts = _onlyFavorites
                ? favoritesVm.favorites
                : allProducts;

            // condicional para filtrar productos por precio
            final filteredProducts = sourceProducts
                .where((p) => p.price <= _maxPriceFilter)
                .toList();

            // lista de categorias de productos
            final categories = <String, List<Product>>{};
            for (final p in filteredProducts) {
              categories.putIfAbsent(p.category, () => []).add(p);
            }

            // cálculo del precio medio de cada categoria de producto
            final avgPriceByCategory = categories.entries.map((e) {
              final avg =
                  e.value.map((p) => p.price).reduce((a, b) => a + b) /
                  e.value.length;
              return MapEntry(e.key, avg);
            }).toList();

            // recuento de cuantos productos hay en cada categoria
            final countByCategory = categories.entries
                .map((e) => MapEntry(e.key, e.value.length))
                .toList();

            // encuentra el producto con el precio más alto para darselo al slider
            final maxAvailablePrice = allProducts
                .map((p) => p.price)
                .reduce((a, b) => max(a, b));
            if (_maxPriceFilter == double.infinity) {
              _maxPriceFilter = maxAvailablePrice;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // filtro para favoritos
                  Row(
                    children: [
                      Switch(
                        value: _onlyFavorites,
                        activeThumbColor: AppStyles.rojoPrimario,
                        onChanged: (v) {
                          setState(() => _onlyFavorites = v);
                        },
                      ),
                      const Text('Solo favoritos'),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // slider para filtrar según precio máximo
                  Text(
                    'Precio máximo: ${_maxPriceFilter.toStringAsFixed(2)} €',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    min: 0,
                    max: maxAvailablePrice,
                    value: _maxPriceFilter,
                    activeColor: AppStyles.rojoPrimario,
                    onChanged: (v) {
                      setState(() => _maxPriceFilter = v);
                    },
                  ),

                  const SizedBox(height: 24),

                  // tabla con los datos
                  const Text(
                    'Productos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DataTable(
                    dataRowMinHeight: 56,
                    dataRowMaxHeight: 80,
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Producto',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Categoría',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Precio',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: filteredProducts.map((p) {
                      return DataRow(
                        cells: [
                          DataCell(
                            // apañar
                            Text(p.title, style: TextStyle(fontSize: 13)),
                          ),
                          DataCell(Text(p.category)),
                          DataCell(
                            // ajuste para que precio tenga el ancho mínimo para mostrarse bien
                            SizedBox(
                              width: 90,
                              child: Text(
                                '${p.price.toStringAsFixed(2)} €',
                                softWrap: false,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // gráfico de barras
                  const Text(
                    'Precio medio por categoría',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: BarChart(
                      BarChartData(
                        barGroups: avgPriceByCategory.asMap().entries.map((e) {
                          return BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: e.value.value,
                                width: 22, // 👈 aquí se ensanchan las barras
                                color: AppStyles.rojoSecundario,
                              ),
                            ],
                          );
                        }).toList(),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (v, _) {
                                final i = v.toInt();
                                if (i < 0 || i >= avgPriceByCategory.length) {
                                  return const SizedBox.shrink();
                                }
                                return Text(
                                  avgPriceByCategory[i].key,
                                  style: const TextStyle(fontSize: 12),
                                );
                              },
                            ),
                          ),
                          // no se muestran los números del eje Y a la izquierda mal croppeados.
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          // los números del eje Y a la derecha y sus opciones
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) => Text(
                                value.toStringAsFixed(0),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // customizacion de lo que se muestra al hacer hover en cada barra
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (_) => AppStyles.rojoSecundario,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${rod.toY.toStringAsFixed(2)} €',
                                const TextStyle(
                                  color: AppStyles.fondoAlt,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // grafico circular
                  const Text(
                    'Distribución por categoría',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        pieTouchData: PieTouchData(
                          touchCallback: (event, response) {
                            setState(() {
                              _hoveredPieIndex =
                                  response?.touchedSection?.touchedSectionIndex;
                            });
                          },
                        ),
                        sections: countByCategory.asMap().entries.map((e) {
                          final isHovered = e.key == _hoveredPieIndex;
                          return PieChartSectionData(
                            value: e.value.value.toDouble(),
                            title: '${e.value.key}\n(${e.value.value})',
                            color: isHovered
                                ? AppStyles.rojoPrimario
                                : AppStyles.rojoSecundario,
                            radius: 90,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

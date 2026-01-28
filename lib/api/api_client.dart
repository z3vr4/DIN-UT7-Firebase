import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ut7_firebase_api/data/product.dart';

class ApiClient {
  final String baseUrl;
  ApiClient({this.baseUrl = "https://fakestoreapi.com"});

  Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('$baseUrl/products');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(response.body);
      return lista.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener posts');
    }
  }
}

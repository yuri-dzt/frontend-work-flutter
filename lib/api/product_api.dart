import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:work_frontend/data/products.dart';

class ProductApi {
  final String apiUrl = 'http://localhost:3355/api/products';
  final String deleteUrl = 'http://localhost:3355/api/products/delete';

  // Método para buscar os produtos
  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Atualiza o cache global
        productsCache.clear();
        productsCache.addAll(data.map((product) => {
              'id': product['id'],
              'name': product['name'],
              'description': product['description'],
              'price': product['price'],
              'updateDate': product['updateDate'],
            }));
      } else {
        throw Exception('Erro ao buscar produtos: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erro de conexão: $error');
    }
  }

  // Método para excluir produto
  Future<void> deleteProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(deleteUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id}),
      );
      if (response.statusCode != 200) {
        throw Exception('Erro ao excluir produto: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erro de conexão: $error');
    }
  }

  // Método para adicionar um produto
  Future<void> addProduct(Map<String, dynamic> product) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': product['name'],
          'description': product['description'],
          'price': product['price'],
          'updateDate': product['updateDate'],
        }),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Erro ao adicionar produto: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erro de conexão: $error');
    }
  }

  Future<bool> updateProduct(int id, Map<String, dynamic> product) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['message'] == 'Produto atualizado com sucesso') {
          return true;
        } else {
          return false;
        }
      } else {
        throw Exception('Erro ao buscar produtos: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erro de conexão: $error');
    }
  }
}

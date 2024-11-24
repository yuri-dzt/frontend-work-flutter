import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:work_frontend/components/product_item.dart';
import '../components/form_product.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final String apiUrl = 'http://localhost:3355/api/products';
  final String deleteUrl = 'http://localhost:3355/api/products/delete';
  final List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _products.clear();
          _products.addAll(data.map((product) => {
                'id': product['id'],
                'name': product['name'],
                'description': product['description'],
                'price': product['price'],
                'updateDate': product['updateDate'],
              }));
        });
      } else {
        _showError('Erro ao buscar produtos: ${response.statusCode}');
      }
    } catch (error) {
      _showError('Erro de conexão: $error');
    }
  }

  Future<void> _deleteProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(deleteUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id}),
      );
      if (response.statusCode == 200) {
        _fetchProducts();
      } else {
        _showError('Erro ao excluir produto: ${response.statusCode}');
      }
    } catch (error) {
      _showError('Erro de conexão: $error');
    }
  }

  Future<void> _addProduct(Map<String, dynamic> product) async {
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': product['name'],
          'description': product['description'],
          'price': product['price'],
          'updateDate': formattedDate,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Adicionando o produto à lista localmente antes de buscar de novo
        setState(() {
          _products.add({
            'id': jsonDecode(response.body)[
                'id'], // Supondo que o ID seja retornado após o post
            'name': product['name'],
            'description': product['description'],
            'price': product['price'],
            'updateDate': formattedDate,
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto adicionado com sucesso!')),
        );
      } else {
        _showError('Erro ao adicionar produto: ${response.statusCode}');
      }
    } catch (error) {
      _showError('Erro de conexão: $error');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _products.isEmpty
                ? Center(
                    child: const Text(
                      'Nenhum produto registrado',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return ProductItem(
                        description: product['description'],
                        name: product['name'],
                        price: product['price'],
                        onDelete: () => _deleteProduct(product['id']),
                        onEdit: (value) => print(value),
                      );
                    },
                  ),
          ),
          FormProduct(
            onSubmit: (product) async {
              await _addProduct(product);
            },
          ),
        ],
      ),
    );
  }
}

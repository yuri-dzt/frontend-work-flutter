import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../components/form_product.dart';
import '../components/list_tile_item.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final String apiUrl = 'http://localhost:3355/api/products';
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

  Future<void> _addProduct(Map<String, dynamic> product) async {
    try {
      final Map<String, dynamic> body = {
        'name': product['name'],
        'description': product['description'],
        'price': product['price'],
        'updateDate': product['updateDate'],
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        _fetchProducts();
      } else {
        _showError('Erro ao criar produto: ${response.statusCode}');
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
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTileItem(
                  title: product['name'],
                  subtitle: "R\$ ${product['price']}",
                  onDelete: () {},
                );
              },
            ),
          ),
          FormProduct(
            onSubmit: _addProduct,
          ),
        ],
      ),
    );
  }
}

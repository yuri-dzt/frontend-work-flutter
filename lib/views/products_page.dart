import 'package:flutter/material.dart';
import '../components/form_product.dart';
import '../components/list_tile_item.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final List<Map<String, dynamic>> _products = [];

  void _addProduct(Map<String, dynamic> product) {
    setState(() {
      _products.add(product);
    });
  }

  void _removeProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
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
                return ListTileItem(
                  title: _products[index]['nome'],
                  subtitle: "R\$ ${_products[index]['preco']}",
                  onDelete: () => _removeProduct(index),
                );
              },
            ),
          ),
          FormProduct(onSubmit: _addProduct),
        ],
      ),
    );
  }
}

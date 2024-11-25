import 'package:flutter/material.dart';
import '../api/product_api.dart';
import '../data/products.dart'; // Importa o cache
import '../components/product_item.dart';
import '../components/form_product.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ProductApi _productApi = ProductApi();

  @override
  void initState() {
    super.initState();
    _fetchAndRefresh();
  }

  Future<void> _fetchAndRefresh() async {
    await _productApi.fetchProducts();
    setState(() {}); // Reconstrói a UI após atualizar o cache
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
            child: productsCache.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum produto registrado',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: productsCache.length,
                    itemBuilder: (context, index) {
                      final product = productsCache[index];
                      return ProductItem(
                        description: product['description'],
                        name: product['name'],
                        price: product['price'],
                        onDelete: () async {
                          await _productApi.deleteProduct(product['id']);
                          await _fetchAndRefresh(); // Atualiza a lista
                        },
                        onEdit: (value) async {
                          await _productApi.updateProduct(product['id'], value);
                          await _fetchAndRefresh(); // Atualiza a lista
                        },
                      );
                    },
                  ),
          ),
          FormProduct(
            onSubmit: (product) async {
              await _productApi.addProduct(product);
              await _fetchAndRefresh(); // Atualiza a lista
            },
          ),
        ],
      ),
    );
  }
}

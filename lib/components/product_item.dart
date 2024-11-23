import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final VoidCallback onDelete;

  const ProductItem({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Adicionando padding nas laterais
      child: Card(
        elevation: 4, // Adiciona sombra ao redor do card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Bordas arredondadas
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0, // Adiciona espaçamento interno nas laterais
          ),
          title: Text(
            name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black, // Garante que o nome seja destacado
                ),
          ),
          subtitle: Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 14, // Tamanho de texto para a descrição
                ),
          ),
          isThreeLine: true,
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
          // Novo campo para exibir o preço do produto
          leading: Text(
            '\$${price.toStringAsFixed(2)}', // Formatação do preço
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ListTileItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description; // Novo campo de descrição
  final VoidCallback onDelete;

  const ListTileItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description, // Adicionando a descrição como parâmetro
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      isThreeLine:
          true, // Habilita três linhas para exibir o título, o subtítulo e a descrição
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete, // Executa a função ao clicar na lixeira.
      ),
      contentPadding: const EdgeInsets.symmetric(
          vertical:
              8.0), // Ajusta o espaçamento vertical para não ficar apertado
      // Adicionando a descrição abaixo do subtítulo
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Descrição do Produto'),
            content: Text(description), // Exibe a descrição completa
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class ClientItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description; // Novo campo de descrição
  final String photoUrl; // Campo para a URL da foto
  final int age; // Campo para a idade
  final VoidCallback onDelete;

  const ClientItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description, // Adicionando a descrição como parâmetro
    required this.photoUrl, // Adicionando o parâmetro da foto
    required this.age, // Adicionando a idade como parâmetro
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundImage: NetworkImage(photoUrl),
        onBackgroundImageError: (exception, stackTrace) {
          // Em vez de retornar uma imagem, vamos exibir um ícone padrão
          print("Erro ao carregar a imagem de fundo: $exception");
        },
      ),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle), // Exibe o email
          Text(
            'Idade: $age', // Exibe a idade abaixo do nome
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
      isThreeLine:
          true, // Habilita três linhas para exibir o título, o subtítulo e a descrição
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete, // Executa a função ao clicar na lixeira.
      ),
      contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0), // Ajusta o espaçamento vertical
    );
  }
}

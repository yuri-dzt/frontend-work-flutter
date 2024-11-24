import 'package:flutter/material.dart';

class ClientItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String photoUrl;
  final int age;
  final VoidCallback onDelete;
  final ValueChanged<Map<String, String>> onEdit;

  const ClientItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.photoUrl,
    required this.age,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          leading: CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(photoUrl),
            onBackgroundImageError: (exception, stackTrace) {
              print("Erro ao carregar a imagem de fundo: $exception");
            },
            backgroundColor: Colors.grey[200],
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black87,
                ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                      fontSize: 16.0,
                    ),
              ),
              SizedBox(height: 4.0),
              Text(
                'Idade: $age anos',
                style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
              ),
            ],
          ),
          isThreeLine: true,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone de editar (lápis)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  _showEditDialog(context);
                },
              ),
              // Ícone de excluir (lixeira)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para mostrar o diálogo de edição
  void _showEditDialog(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: title);
    final TextEditingController lastNameController =
        TextEditingController(text: subtitle);
    final TextEditingController ageController =
        TextEditingController(text: age.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text('Editar Cliente',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blue,
              )),
          content: SizedBox(
            width: 400, // Ajuste a largura conforme necessário
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Campo de nome
                  _buildTextField(
                    controller: nameController,
                    label: 'Nome',
                  ),
                  const SizedBox(height: 12),
                  // Campo de sobrenome
                  _buildTextField(
                    controller: lastNameController,
                    label: 'Sobrenome',
                  ),
                  const SizedBox(height: 12),
                  // Campo de idade
                  _buildTextField(
                    controller: ageController,
                    label: 'Idade',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            // Botão Cancelar
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo sem salvar
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
              ),
              child: const Text('Cancelar', style: TextStyle(fontSize: 16)),
            ),
            // Botão Salvar
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text;
                final newLastName = lastNameController.text;
                final newAge = int.tryParse(ageController.text) ?? age;

                onEdit({
                  'name': newName,
                  'lastName': newLastName,
                  'age': newAge.toString(),
                });

                Navigator.pop(context); // Fecha o diálogo
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
              ),
              child: const Text('Salvar', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  // Função para construir campos de texto mais bonitos
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blue),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      keyboardType: keyboardType,
    );
  }
}

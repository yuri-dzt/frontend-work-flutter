import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final VoidCallback onDelete;
  final ValueChanged<Map<String, String>> onEdit;

  const ProductItem({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        shadowColor: Colors.black26,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preço destacado acima do nome
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 4),
              // Nome do produto
              Text(
                name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
            ),
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
                splashRadius: 20,
              ),
              // Ícone de excluir (lixeira)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
                splashRadius: 20,
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
        TextEditingController(text: name);
    final TextEditingController descriptionController =
        TextEditingController(text: description);
    final TextEditingController priceController =
        TextEditingController(text: price.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text('Editar Produto',
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
                    label: 'Nome do Produto',
                  ),
                  const SizedBox(height: 12),
                  // Campo de descrição
                  _buildTextField(
                    controller: descriptionController,
                    label: 'Descrição',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  // Campo de preço
                  _buildTextField(
                    controller: priceController,
                    label: 'Preço',
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
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
                final newDescription = descriptionController.text;
                final newPrice = double.tryParse(priceController.text) ?? price;

                onEdit({
                  'name': newName,
                  'description': newDescription,
                  'price': newPrice.toString(),
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
    int maxLines = 1,
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
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }
}

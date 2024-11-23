import 'package:flutter/material.dart';

class FormProduct extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const FormProduct({super.key, required this.onSubmit});

  @override
  State<FormProduct> createState() => _FormProductState();
}

class _FormProductState extends State<FormProduct> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();

  // Validação de preço
  String? _validatePrice(String? value) {
    final double? price = double.tryParse(value ?? '');
    if (price == null || price <= 0 || price >= 120) {
      return 'Preço deve ser um número positivo menor que 120';
    }
    return null;
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit({
        'name': _nomeController.text,
        'description': _descricaoController.text,
        'price': double.parse(_precoController.text),
      });

      _nomeController.clear();
      _descricaoController.clear();
      _precoController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (value) =>
                  value!.isEmpty || value.length < 3 || value.length > 25
                      ? 'Deve ter entre 3 e 25 caracteres'
                      : null,
            ),
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              validator: (value) =>
                  value!.isEmpty || value.length < 3 || value.length > 25
                      ? 'Deve ter entre 3 e 25 caracteres'
                      : null,
            ),
            TextFormField(
              controller: _precoController,
              decoration: const InputDecoration(labelText: 'Preço'),
              keyboardType: TextInputType.number,
              validator: _validatePrice,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: const Text('Adicionar Produto'),
            ),
          ],
        ),
      ),
    );
  }
}

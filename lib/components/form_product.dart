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

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final double? preco = double.tryParse(_precoController.text);

      if (preco == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Preço inválido. Por favor, insira um número válido.')),
        );
        return;
      }

      widget.onSubmit({
        'name': _nomeController.text,
        'description': _descricaoController.text,
        'price': preco,
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
                  value!.isEmpty ? 'O nome não pode estar vazio' : null,
            ),
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              validator: (value) =>
                  value!.isEmpty ? 'A descrição não pode estar vazia' : null,
            ),
            TextFormField(
              controller: _precoController,
              decoration: const InputDecoration(labelText: 'Preço'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value!.isEmpty ? 'O preço não pode estar vazio' : null,
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

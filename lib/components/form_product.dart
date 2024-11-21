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
      widget.onSubmit({
        'nome': _nomeController.text,
        'descricao': _descricaoController.text,
        'preco': double.parse(_precoController.text),
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
              decoration: const InputDecoration(labelText: 'Nome do Produto'),
              validator: (value) => value!.isEmpty ? 'Insira o nome' : null,
            ),
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              validator: (value) =>
                  value!.isEmpty ? 'Insira a descrição' : null,
            ),
            TextFormField(
              controller: _precoController,
              decoration: const InputDecoration(labelText: 'Preço'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Insira o preço' : null,
            ),
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

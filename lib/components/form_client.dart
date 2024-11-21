import 'package:flutter/material.dart';

class FormClient extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const FormClient({super.key, required this.onSubmit});

  @override
  State<FormClient> createState() => _FormClientState();
}

class _FormClientState extends State<FormClient> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _emailController = TextEditingController();

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit({
        'nome': _nomeController.text,
        'sobrenome': _sobrenomeController.text,
        'email': _emailController.text,
      });
      _nomeController.clear();
      _sobrenomeController.clear();
      _emailController.clear();
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
              validator: (value) => value!.isEmpty ? 'Insira o nome' : null,
            ),
            TextFormField(
              controller: _sobrenomeController,
              decoration: const InputDecoration(labelText: 'Sobrenome'),
              validator: (value) =>
                  value!.isEmpty ? 'Insira o sobrenome' : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) => value!.isEmpty ? 'Insira o email' : null,
            ),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: const Text('Adicionar Cliente'),
            ),
          ],
        ),
      ),
    );
  }
}

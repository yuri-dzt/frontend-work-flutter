import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final _idadeController =
      TextEditingController(); // Adicionando o campo para idade

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Pegando os valores do formulário
      final nome = _nomeController.text;
      final sobrenome = _sobrenomeController.text;
      final email = _emailController.text;
      final idade = int.tryParse(_idadeController.text) ??
          0; // Garantindo que a idade seja um número

      // Criando o corpo da requisição
      final clientData = {
        'nome': nome,
        'sobrenome': sobrenome,
        'email': email,
        'idade': idade,
      };

      // Fazendo a requisição POST para a API
      final response = await http.post(
        Uri.parse('http://localhost:3355/api/clients'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(clientData),
      );

      if (response.statusCode == 200) {
        // Caso a requisição seja bem-sucedida, chame a função onSubmit
        widget.onSubmit(clientData);

        // Limpar os campos após o envio
        _nomeController.clear();
        _sobrenomeController.clear();
        _emailController.clear();
        _idadeController.clear();
      } else {
        // Caso haja erro na requisição
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao adicionar cliente.')),
        );
      }
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
            TextFormField(
              controller: _idadeController,
              decoration: const InputDecoration(labelText: 'Idade'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Insira a idade' : null,
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

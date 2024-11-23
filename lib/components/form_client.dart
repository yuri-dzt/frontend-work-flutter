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
  final _idadeController = TextEditingController();
  final _fotoController = TextEditingController(); // Novo controlador para foto

  // Validação de email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira o email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Insira um email válido';
    }
    return null;
  }

  // Validação de nome e sobrenome
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'O campo não pode estar vazio';
    }
    if (value.length < 3 || value.length > 25) {
      return 'Deve ter entre 3 e 25 caracteres';
    }
    return null;
  }

  // Validação de idade
  String? _validateAge(String? value) {
    final int? age = int.tryParse(value ?? '');
    if (age == null || age <= 0 || age >= 120) {
      return 'Idade deve ser um número positivo menor que 120';
    }
    return null;
  }

  // Validação de URL da foto
  String? _validatePhoto(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira a URL da foto';
    }
    final urlRegex = RegExp(
        r'^(http(s)?:\/\/)?([a-z0-9-]+\.)+[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$');
    if (!urlRegex.hasMatch(value)) {
      return 'Insira uma URL válida';
    }
    return null;
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final clientData = {
        'nome': _nomeController.text,
        'sobrenome': _sobrenomeController.text,
        'email': _emailController.text,
        'idade': int.parse(_idadeController.text),
        'foto': _fotoController.text, // Adiciona o campo foto
      };

      final response = await http.post(
        Uri.parse('http://localhost:3355/api/clients'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(clientData),
      );

      if (response.statusCode == 200) {
        widget.onSubmit(clientData);
        _nomeController.clear();
        _sobrenomeController.clear();
        _emailController.clear();
        _idadeController.clear();
        _fotoController.clear(); // Limpa o campo foto
      } else {
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
              validator: _validateName,
            ),
            TextFormField(
              controller: _sobrenomeController,
              decoration: const InputDecoration(labelText: 'Sobrenome'),
              validator: _validateName,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: _validateEmail,
            ),
            TextFormField(
              controller: _idadeController,
              decoration: const InputDecoration(labelText: 'Idade'),
              keyboardType: TextInputType.number,
              validator: _validateAge,
            ),
            TextFormField(
              controller: _fotoController,
              decoration: const InputDecoration(labelText: 'URL da Foto'),
              validator: _validatePhoto,
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

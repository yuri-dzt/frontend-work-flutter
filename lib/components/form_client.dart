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
  final _fotoController = TextEditingController();

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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'O campo não pode estar vazio';
    }
    if (value.length < 3 || value.length > 25) {
      return 'Deve ter entre 3 e 25 caracteres';
    }
    return null;
  }

  String? _validateAge(String? value) {
    final int? age = int.tryParse(value ?? '');
    if (age == null || age <= 0 || age >= 120) {
      return 'Idade deve ser um número positivo menor que 120';
    }
    return null;
  }

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
        'foto': _fotoController.text,
      };

      final response = await http.post(
        Uri.parse('http://localhost:3355/api/clients'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(clientData),
      );

      if (response.statusCode == 201) {
        widget.onSubmit(clientData);
        _nomeController.clear();
        _sobrenomeController.clear();
        _emailController.clear();
        _idadeController.clear();
        _fotoController.clear();
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome e Sobrenome lado a lado
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        validator: _validateName,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: TextFormField(
                        controller: _sobrenomeController,
                        decoration: const InputDecoration(
                          labelText: 'Sobrenome',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        validator: _validateName,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                // Email e Idade lado a lado
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        validator: _validateEmail,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: TextFormField(
                        controller: _idadeController,
                        decoration: const InputDecoration(
                          labelText: 'Idade',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        keyboardType: TextInputType.number,
                        validator: _validateAge,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                // URL da Foto sozinho embaixo
                TextFormField(
                  controller: _fotoController,
                  decoration: const InputDecoration(
                    labelText: 'URL da Foto',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  validator: _validatePhoto,
                  style: TextStyle(fontSize: 12.0),
                ),
                SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    child: const Text('Adicionar Cliente'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      textStyle: const TextStyle(fontSize: 14.0),
                      minimumSize: Size(180, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

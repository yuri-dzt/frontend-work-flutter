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

      // Resetando os campos após o submit
      setState(() {
        _nomeController.clear();
        _descricaoController.clear();
        _precoController.clear();
      });

      // Dando um refresh na página (pode ser a navegação ou outra ação)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto adicionado com sucesso!')),
      );
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
            // Nome e Preço lado a lado
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
                    validator: (value) =>
                        value!.isEmpty || value.length < 3 || value.length > 25
                            ? 'Deve ter entre 3 e 25 caracteres'
                            : null,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextFormField(
                    controller: _precoController,
                    decoration: const InputDecoration(
                      labelText: 'Preço',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    keyboardType: TextInputType.number,
                    validator: _validatePrice,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            // Descrição embaixo
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              validator: (value) =>
                  value!.isEmpty || value.length < 3 || value.length > 25
                      ? 'Deve ter entre 3 e 25 caracteres'
                      : null,
              style: TextStyle(fontSize: 12.0),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: const Text('Adicionar Produto'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                textStyle: const TextStyle(fontSize: 14.0),
                minimumSize: Size(180, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

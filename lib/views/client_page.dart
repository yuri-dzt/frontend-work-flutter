import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/form_client.dart';
import '../components/client_item.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final List<Map<String, dynamic>> _clients = [];

  @override
  void initState() {
    super.initState();
    _fetchClients();
  }

  Future<void> _fetchClients() async {
    final response =
        await http.get(Uri.parse('http://localhost:3355/api/clients'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      setState(() {
        _clients.clear();
        _clients.addAll(data
            .map((client) => {
                  'id': client['id'],
                  'nome': client['name'],
                  'sobrenome': client['lastname'],
                  'email': client['email'],
                  'age': client['age'],
                  'photo': client['photo'],
                })
            .toList());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar clientes.')),
      );
    }
  }

  void _addClient(Map<String, dynamic> client) {
    setState(() {
      _clients.add(client);
    });
  }

  void _removeClient(int index) {
    setState(() {
      _clients.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _clients.isEmpty
                ? Center(
                    child: const Text(
                      'Nenhum cliente registrado',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: _clients.length,
                    itemBuilder: (context, index) {
                      return ClientItem(
                        description: "Idade: ${_clients[index]['description']}",
                        age: _clients[index]['age'],
                        title:
                            "${_clients[index]['nome']} ${_clients[index]['sobrenome']}",
                        subtitle: _clients[index]['email'],
                        photoUrl: _clients[index]['photo'],
                        onDelete: () => _removeClient(index),
                        onEdit: (value) => print(value),
                      );
                    },
                  ),
          ),
          FormClient(onSubmit: _addClient),
        ],
      ),
    );
  }
}

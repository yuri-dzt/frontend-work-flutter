import 'package:flutter/material.dart';
import '../components/form_client.dart';
import '../components/list_tile_item.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final List<Map<String, dynamic>> _clients = [];

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
            child: ListView.builder(
              itemCount: _clients.length,
              itemBuilder: (context, index) {
                return ListTileItem(
                  title:
                      "${_clients[index]['nome']} ${_clients[index]['sobrenome']}",
                  subtitle: _clients[index]['email'],
                  onDelete: () => _removeClient(index),
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

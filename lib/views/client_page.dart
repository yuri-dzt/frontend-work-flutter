import 'package:flutter/material.dart';
import 'package:work_frontend/data/client.dart';
import '../api/client_api.dart';
import '../components/form_client.dart';
import '../components/client_item.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final ClientApi _clientApi = ClientApi();

  @override
  void initState() {
    super.initState();
    _fetchAndRefresh();
  }

  Future<void> _fetchAndRefresh() async {
    await _clientApi.fetchClients();
    setState(() {});
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
            child: clientCache.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum cliente registrado',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: clientCache.length,
                    itemBuilder: (context, index) {
                      final client = clientCache[index];
                      return ClientItem(
                        description: 'Idade: ${client.age}',
                        age: client.age,
                        title: '${client.nome} ${client.sobrenome}',
                        subtitle: client.email,
                        photoUrl: client.photo,
                        onDelete: () async {
                          await _clientApi.deleteClient(client.id);
                          setState(() {}); // Atualiza a interface
                        },
                        onEdit: (updatedData) async {
                          await _clientApi.updateClient(client.id, updatedData);
                          await _fetchAndRefresh(); // Atualiza o cache
                        },
                      );
                    },
                  ),
          ),
          FormClient(
            onSubmit: (clientData) async {
              await _clientApi.addClient(clientData);
              await _fetchAndRefresh();
            },
          ),
        ],
      ),
    );
  }
}

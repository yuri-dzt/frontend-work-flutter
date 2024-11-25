import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:work_frontend/data/client.dart';
import 'package:work_frontend/model/client.dart';

class ClientApi {
  final String apiUrl = 'http://localhost:3355/api/clients';

  Future<void> fetchClients() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        clientCache.clear();
        clientCache.addAll(data.map((json) => Client.fromJson(json)).toList());
      } else {
        throw Exception('Erro ao carregar clientes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<void> updateClient(int id, Map<String, dynamic> updatedData) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar cliente: ${response.statusCode}');
    }
  }

  Future<void> addClient(Map<String, dynamic> clientData) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(clientData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Client newClient = Client.fromJson(jsonDecode(response.body));
      clientCache.add(newClient);
    } else {
      throw Exception('Erro ao adicionar cliente: ${response.statusCode}');
    }
  }

  Future<void> deleteClient(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
    );

    if (response.statusCode == 200) {
      clientCache.removeWhere((client) => client.id == id);
    } else {
      throw Exception('Erro ao excluir cliente: ${response.statusCode}');
    }
  }
}

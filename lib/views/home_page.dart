import 'package:flutter/material.dart';
import 'package:work_frontend/views/client_page.dart';
import 'products_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Inicial'),
        backgroundColor:
            Colors.teal, // Cor personalizada para a barra de navegação
        centerTitle: true,
      ),
      body: Center(
        // Centralizando o conteúdo na tela
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Melhorando o padding da página
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centraliza verticalmente
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centraliza horizontalmente
            children: [
              const Text(
                'Bem-vindo(a)!', // Texto de boas-vindas
                style: TextStyle(
                  fontSize: 24, // Tamanho da fonte
                  fontWeight: FontWeight.bold, // Fonte em negrito
                ),
              ),
              const SizedBox(height: 40), // Espaço entre o texto e os botões
              // Botão para Gerenciar Clientes
              SizedBox(
                width: 200, // Definindo a largura fixa do botão
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ClientsPage()),
                    );
                  },
                  icon: const Icon(Icons.group, size: 24), // Ícone de grupo
                  label: const Text('Gerenciar Clientes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Cor de fundo do botão
                    foregroundColor: Colors.white, // Cor do texto
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // Bordas arredondadas
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espaçamento entre os botões
              // Botão para Gerenciar Produtos
              SizedBox(
                width: 200, // Definindo a largura fixa do botão
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductsPage()),
                    );
                  },
                  icon: const Icon(Icons.production_quantity_limits,
                      size: 24), // Ícone de produtos
                  label: const Text('Gerenciar Produtos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Cor de fundo do botão
                    foregroundColor: Colors.white, // Cor do texto
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // Bordas arredondadas
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

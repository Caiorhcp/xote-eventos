import 'package:flutter/material.dart';
import 'recent_events_section.dart';  // Importa a seção de eventos recentes
import 'future_events_section.dart';  // Importa a seção de eventos futuros
import 'menu_section.dart';  // Importa a seção do menu
import '/app/widgets/header.dart';  // Importa o widget de cabeçalho
import '/app/pages/stores/evento_store.dart';  // Importa o EventoStore para gerenciar os dados

// Definição do widget HomePage como StatelessWidget
class HomePage extends StatelessWidget {
  final EventoStore eventStore;  // Variável que armazena a instância do EventoStore

  // Construtor que recebe uma instância do EventoStore como parâmetro
  const HomePage({super.key, required this.eventStore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Scaffold é o layout básico da tela
      appBar: const Header(),  // Exibe o widget de cabeçalho no topo da página
      body: Container(
        width: double.infinity,  // Define a largura do container como a largura total da tela
        height: MediaQuery.of(context).size.height,  // Define a altura do container para a altura total da tela
        color: const Color(0xFF02142F),  // Define a cor de fundo da tela
        child: SingleChildScrollView(  // Permite rolagem quando o conteúdo excede a tela
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,  // Alinha os filhos no início (à esquerda)
            children: [
              MenuSection(eventStore: eventStore),  // Exibe a seção de menu passando o EventoStore
              const RecentEventsSection(),  // Exibe a seção de eventos recentes
              const FutureEventsSection(),  // Exibe a seção de eventos futuros
            ],
          ),
        ),
      ),
    );
  }
}

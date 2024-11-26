import 'package:flutter/material.dart';
import 'package:xote_eventos/app/pages/search-page/event_card.dart'; // Importa o card de evento
import 'package:xote_eventos/app/pages/stores/evento_store.dart'; // Importa o store de eventos para gerenciar o estado

class PageTemplate extends StatelessWidget {
  final String eventType; // Tipo de evento a ser filtrado (por exemplo, 'futuro', 'recente', etc.)
  final EventoStore eventStore; // Store que gerencia o estado dos eventos

  const PageTemplate({
    super.key, // Chave única para o widget
    required this.eventType, // Inicializa o tipo de evento
    required this.eventStore, // Inicializa o store de eventos
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02142F), // Cor de fundo da tela
      appBar: AppBar(
        backgroundColor: const Color(0xFF000D1F), // Cor de fundo da barra superior
        title: Text(
          'Eventos: $eventType', // Exibe o tipo de evento no título da página
          style: const TextStyle(
            fontSize: 28.0, // Tamanho da fonte do título
            fontWeight: FontWeight.bold, // Peso da fonte (negrito)
            color: Color(0xFFFFB854), // Cor do título
          ),
        ),
        elevation: 0, // Retira a sombra da barra superior
        centerTitle: true, // Centraliza o título
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Ícone de voltar
          onPressed: () {
            Navigator.pop(context); // Retorna à página anterior
          },
        ),
      ),
      body: FutureBuilder(
        future: eventStore.getEventos(), // Chama o método para buscar os eventos
        builder: (context, snapshot) {
          // Verifica o estado da requisição de eventos
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Enquanto os eventos são carregados, exibe o carregamento
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Caso ocorra erro, exibe mensagem de erro
            return const Center(child: Text('Erro ao carregar os eventos', style: TextStyle(color: Colors.white)));
          } else if (eventStore.state.value.isEmpty) {
            // Caso não haja eventos, exibe mensagem informando que não há eventos
            return const Center(child: Text('Nenhum evento encontrado', style: TextStyle(color: Colors.white)));
          }

          final events = eventStore.state.value; // Obtém a lista de eventos
          final filteredEvents = events.where((event) => event.type == eventType).toList(); // Filtra os eventos pelo tipo

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Define o padding horizontal
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Alinha os itens no centro
              children: [
                const SizedBox(height: 20), // Espaçamento
                const Text(
                  'Eventos Disponiveis:', // Título para a lista de eventos
                  style: TextStyle(
                    fontSize: 20.0, // Tamanho da fonte
                    fontWeight: FontWeight.bold, // Peso da fonte (negrito)
                    color: Color.fromARGB(255, 255, 255, 255), // Cor do texto
                  ),
                  textAlign: TextAlign.center, // Alinha o texto no centro
                ),
                const SizedBox(height: 20), // Espaçamento
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredEvents.length, // Número de eventos a serem listados
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index]; // Evento individual
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0), // Espaçamento inferior
                        child: EventCard(event: event), // Exibe o card de evento
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

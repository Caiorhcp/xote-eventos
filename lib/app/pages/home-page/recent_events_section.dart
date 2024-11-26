import 'package:flutter/material.dart';
import 'package:xote_eventos/app/pages/home-page/recent_event_card_design.dart'; // Importa o widget do card de evento
import '/app/data/models/event_model.dart'; // Importa o modelo de dados dos eventos
import '/app/data/http/http_client.dart'; // Importa o cliente HTTP para fazer requisições
import '/app/data/repositories/event_repository.dart'; // Importa o repositório de eventos
import '/app/pages/detail-page/event_detail_page.dart'; // Importa a página de detalhes do evento
import '/app/pages/stores/evento_store.dart'; // Importa o store para gerenciar o estado dos eventos

class RecentEventsSection extends StatefulWidget {
  const RecentEventsSection({super.key}); // Construtor da classe, com key opcional

  @override
  RecentEventsSectionState createState() => RecentEventsSectionState(); // Cria o estado do widget
}

class RecentEventsSectionState extends State<RecentEventsSection> {
  late final EventoStore _eventoStore; // Declaração do store para gerenciar o estado dos eventos

  @override
  void initState() {
    super.initState(); // Chama o método initState da classe pai

    final httpClient = HttpClient(); // Instancia o cliente HTTP
    final repository = EventRepository(client: httpClient); // Cria o repositório com o client
    _eventoStore = EventoStore(repository: repository, client: httpClient); // Cria o store com repositório e client
    _fetchRecentEvents(); // Chama o método para buscar os eventos recentes
  }

  // Método assíncrono para buscar os eventos recentes
  Future<void> _fetchRecentEvents() async {
    await _eventoStore.getRecentEventos(); // Chama o método que busca os eventos
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<EventModel>>(
      // Utiliza o ValueListenableBuilder para ouvir mudanças no estado dos eventos
      valueListenable: _eventoStore.state, // Observa o estado dos eventos no store
      builder: (context, eventos, _) {
        // Se o estado dos eventos for de carregamento
        if (_eventoStore.isLoading.value) {
          return const Center(child: CircularProgressIndicator()); // Exibe o indicador de carregamento
        }

        // Se houver um erro ao carregar os eventos
        if (_eventoStore.erro.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_eventoStore.erro.value), // Exibe a mensagem de erro
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: _fetchRecentEvents, // Tenta buscar os eventos novamente
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          );
        }

        // Se os eventos foram carregados com sucesso
        return Padding(
          padding: const EdgeInsets.all(16.0), // Define o padding da seção
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mais Recentes', // Título da seção
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14.0), // Espaço entre o título e os cards
              SizedBox(
                height: 200, // Define a altura da ListView
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Define a direção da rolagem como horizontal
                  itemCount: eventos.length, // Define o número de itens na lista de eventos
                  itemBuilder: (context, index) {
                    final event = eventos[index]; // Obtém o evento da lista de eventos
                    return RecentEventCardDesign(
                      event: event, // Passa o evento para o widget do card
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailPage(event: event), // Navega para a página de detalhes do evento
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

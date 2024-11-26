import 'package:flutter/material.dart';
import 'package:xote_eventos/app/pages/search-page/event_card.dart';
import '/app/data/models/event_model.dart';
import '/app/pages/stores/evento_store.dart';
import '/app/data/http/http_client.dart';
import '/app/data/repositories/event_repository.dart';

// Definindo o widget FutureEventsSection como StatefulWidget
class FutureEventsSection extends StatefulWidget {
  const FutureEventsSection({super.key});

  @override
  FutureEventsSectionState createState() => FutureEventsSectionState();
}

// Estado do widget FutureEventsSection
class FutureEventsSectionState extends State<FutureEventsSection> {
  late final EventoStore _eventoStore;  // Instância do EventoStore
  int _visibleItemCount = 2;  // Contador de itens visíveis inicialmente (2 eventos)

  // Função que é chamada quando o widget é inicializado
  @override
  void initState() {
    super.initState();
    _initializeStore();  // Inicializa o store para gerenciar o estado dos eventos
    _fetchFutureEvents();  // Busca os eventos futuros
  }

  // Inicializa o EventoStore com dependências necessárias
  void _initializeStore() {
    final httpClient = HttpClient();  // Cria uma instância do cliente HTTP
    final repository = EventRepository(client: httpClient);  // Cria o repositório de eventos
    _eventoStore = EventoStore(repository: repository, client: httpClient);  // Cria o store de eventos
  }

  // Função assíncrona que busca os eventos futuros
  Future<void> _fetchFutureEvents() async {
    await _eventoStore.getEventosByDateDesc();  // Chama a função do store para obter eventos ordenados por data
  }

  // Função que retorna um widget de erro quando ocorre algum problema
  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_eventoStore.erro.value, textAlign: TextAlign.center),  // Exibe a mensagem de erro
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: _fetchFutureEvents,  // Tenta novamente buscar os eventos ao clicar no botão
            child: const Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  // Função que retorna o widget de carregamento (um indicador circular)
  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  // Função que constrói a lista de eventos
  Widget _buildEventList(List<EventModel> eventos) {
    final isExpandable = _visibleItemCount < eventos.length;  // Verifica se há mais eventos para exibir

    return ListView.builder(
      shrinkWrap: true,  // O ListView deve ter um tamanho fixo
      physics: const NeverScrollableScrollPhysics(),  // Desativa a rolagem do ListView
      itemCount: isExpandable ? _visibleItemCount + 1 : eventos.length,  // Se houver mais eventos, adiciona o botão "Ver Mais"
      itemBuilder: (context, index) {
        // Se o índice for igual ao número de itens visíveis e houver mais eventos, mostra o botão "Ver Mais"
        if (isExpandable && index == _visibleItemCount) {
          return TextButton(
            onPressed: () {
              setState(() {
                // Atualiza o contador de itens visíveis ao clicar em "Ver Mais"
                _visibleItemCount =
                    (_visibleItemCount + 2).clamp(0, eventos.length);
              });
            },
            child: const Text(
              'Ver Mais',
              style: TextStyle(color: Colors.blue),
            ),
          );
        }

        // Caso contrário, exibe o card do evento
        return EventCard(event: eventos[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<EventModel>>(
      valueListenable: _eventoStore.state,  // Observa mudanças no estado do EventoStore
      builder: (context, eventos, _) {
        // Se os dados ainda estão sendo carregados, exibe o indicador de carregamento
        if (_eventoStore.isLoading.value) {
          return _buildLoading();
        }

        // Se houve algum erro ao buscar os eventos, exibe o erro
        if (_eventoStore.erro.value.isNotEmpty) {
          return _buildError();
        }

        // Caso contrário, exibe a lista de eventos futuros
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Eventos Futuros',  // Título da seção
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              _buildEventList(eventos),  // Chama a função para construir a lista de eventos
            ],
          ),
        );
      },
    );
  }
}

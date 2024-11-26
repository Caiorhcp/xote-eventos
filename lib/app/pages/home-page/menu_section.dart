import 'package:flutter/material.dart';
import 'package:xote_eventos/app/pages/stores/evento_store.dart';  // Importa o EventoStore, que gerencia os dados dos eventos
import 'package:xote_eventos/app/widgets/pageTemplate.dart';  // Importa o widget PageTemplate, que será utilizado para exibir cada página de evento
import '/app/widgets/scroll_menu.dart';  // Importa o widget ScrollMenu, que exibe um menu rolável

// Define o widget MenuSection, que exibe a seção do menu com tipos de eventos
class MenuSection extends StatelessWidget {
  final EventoStore eventStore;  // Recebe o EventoStore para gerenciar os dados de eventos

  // Construtor do MenuSection que recebe o EventoStore
  const MenuSection({super.key, required this.eventStore});

  @override
  Widget build(BuildContext context) {
    // Usa FutureBuilder para aguardar a resposta de getEventos() do eventoStore
    return FutureBuilder<void>(
      future: eventStore.getEventos(),  // Chama o método getEventos() para carregar os eventos
      builder: (context, snapshot) {
        // Se a conexão estiver aguardando, exibe um carregamento
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Se houver erro na chamada dos eventos, exibe a mensagem de erro
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar os tipos de eventos'));
        }

        // Se não houver eventos, exibe uma mensagem informando que não foram encontrados
        final allEvents = eventStore.state.value;  // Recupera os eventos do eventoStore
        if (allEvents.isEmpty) {
          return const Center(child: Text('Nenhum tipo de evento encontrado'));
        }

        // Cria uma lista com tipos de eventos únicos
        final eventTypesList = allEvents.map((e) => e.type).toSet().toList();

        // Retorna o layout do menu, incluindo o título e o menu rolável
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Menu',  // Título do menu
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16.0),  // Espaçamento entre o título e o menu
              Center(
                child: ScrollMenu(
                  // Define os itens do menu com base nos tipos de evento
                  menuItems: eventTypesList,
                  // Para cada tipo de evento, cria uma página usando PageTemplate
                  pages: eventTypesList.map((type) {
                    return PageTemplate(eventType: type, eventStore: eventStore);
                  }).toList(),
                  // Adiciona ícones de evento ao menu (um ícone para cada tipo de evento)
                  icons: List.generate(eventTypesList.length, (_) => Icons.event),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

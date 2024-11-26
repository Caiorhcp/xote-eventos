import 'package:flutter/material.dart'; // Importa o pacote de widgets do Flutter
import 'package:provider/provider.dart'; // Importa o pacote Provider para gerenciamento de estado
import 'package:xote_eventos/app/data/http/http_client.dart'; // Importa o cliente HTTP para fazer as requisições
import 'package:xote_eventos/app/data/repositories/event_repository.dart'; // Importa o repositório de eventos
import 'package:xote_eventos/app/pages/home-page/app_navigation.dart'; // Importa a navegação da página inicial
import 'package:xote_eventos/app/pages/stores/evento_store.dart'; // Importa o store de eventos para gerenciar o estado dos eventos

void main() {
  final HttpClient httpClient = HttpClient(); // Instancia o cliente HTTP
  final IEventRepository eventRepository = EventRepository(client: httpClient); // Instancia o repositório de eventos, passando o cliente HTTP
  final EventoStore eventoStore = EventoStore(repository: eventRepository, client: httpClient); // Instancia o store de eventos, passando o repositório e o cliente HTTP

  runApp(
    ChangeNotifierProvider<EventoStore>( // Provê o store de eventos para o aplicativo, tornando-o acessível em toda a árvore de widgets
      create: (context) => eventoStore, // Cria o eventoStore
      child: const MyApp(), // Inicia o aplicativo com MyApp como widget raiz
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Construtor do MyApp

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Desativa a faixa de depuração no canto superior direito
      title: 'XoteCariri', // Define o título do aplicativo
      theme: ThemeData(
        primarySwatch: Colors.blue, // Define a cor primária do aplicativo como azul
      ),
      home: const AppNavigation(), // Define a tela inicial como a página de navegação
      builder: (context, child) {
        // O builder é usado para envolver o widget em uma árvore personalizada
        return Stack(
          children: [
            child ?? const SizedBox.shrink(), // Se o child for nulo, exibe um SizedBox vazio
          ],
        );
      },
    );
  }
}

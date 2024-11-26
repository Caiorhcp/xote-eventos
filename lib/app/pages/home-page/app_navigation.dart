import 'package:flutter/material.dart';

// Importando as páginas e dependências necessárias para o app
import '/app/pages/home-page/home_page.dart';
import '/app/pages/lib_page/lib_page.dart';
import '/app/pages/search-page/search_page.dart';
import '/app/pages/stores/evento_store.dart'; 
import '/app/data/repositories/event_repository.dart'; 
import '/app/data/http/http_client.dart'; 

// A classe AppNavigation gerencia a navegação entre as páginas usando um BottomNavigationBar
class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

// A classe _AppNavigationState controla o estado da navegação e páginas a serem exibidas
class _AppNavigationState extends State<AppNavigation> {
  // Declarando as variáveis para armazenar o EventoStore e a lista de páginas
  late final EventoStore eventStore;
  late final List<Widget> pages; 

  // Função chamada quando o widget é inicializado
  @override
  void initState() {
    super.initState();

    // Inicializando o cliente HTTP para fazer requisições
    final client = HttpClient();

    // Criando o repositório de eventos com o cliente HTTP
    final repository = EventRepository(client: client);

    // Inicializando o store de eventos com o repositório e o cliente
    eventStore = EventoStore(repository: repository, client: client);

    // Definindo as páginas que o bottom navigation vai controlar
    pages = [
      HomePage(eventStore: eventStore), // Página inicial com dados de eventos
      const SearchPage(), // Página de busca
      const LibPage(), // Página de favoritos
    ];
  }

  // Variável que mantém o índice da página selecionada
  int currentIndex = 0;

  // Função que constrói a interface gráfica
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O corpo da tela exibe a página atual com base no índice
      body: pages[currentIndex],

      // BottomNavigationBar controla a navegação entre as páginas
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF000D1F), // Cor de fundo da barra de navegação
        selectedItemColor: const Color(0xFFFFB854), // Cor do item selecionado
        unselectedItemColor: const Color.fromARGB(170, 203, 203, 203), // Cor dos itens não selecionados
        onTap: (index) {
          // Quando um item é tocado, atualiza o índice atual para exibir a página correspondente
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex, // Índice atual da página
        items: const [
          // Itens da barra de navegação
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Ícone da página inicial
            label: 'Início', // Rótulo da página inicial
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search), // Ícone da página de busca
            label: 'Buscar', // Rótulo da página de busca
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite), // Ícone da página de favoritos
            label: 'Favoritos', // Rótulo da página de favoritos
          ),
        ],
      ),
    );
  }
}

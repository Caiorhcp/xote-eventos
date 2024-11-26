import 'package:flutter/material.dart';
import '/app/pages/home-page/home_page.dart';  // Importa a HomePage para ser usada no menu de navegação
import '/app/pages/lib_page/lib_page.dart';  // Importa a LibPage, outra página que será exibida no menu
import '/app/pages/search-page/search_page.dart';  // Importa a SearchPage, outra página do aplicativo
import '/app/widgets/logo.dart';  // Importa o widget Logo, que provavelmente exibe o logotipo do app
import '/app/widgets/scroll_menu.dart';  // Importa o widget ScrollMenu para exibir um menu rolável
import '/app/pages/stores/evento_store.dart';  // Importa o EventoStore, utilizado para gerenciar os dados de eventos

// Define o widget HomeLogo, que exibe o logo do aplicativo
class HomeLogo extends StatelessWidget {
  const HomeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Logo();  // Retorna o widget Logo, responsável por exibir o logotipo
  }
}

// Define o widget HomeScrollMenu, que exibe um menu rolável com navegação entre páginas
class HomeScrollMenu extends StatelessWidget {
  final EventoStore eventStore;  // Variável para armazenar o EventoStore, responsável por gerenciar os dados de eventos

  // Construtor que recebe o EventoStore como parâmetro
  const HomeScrollMenu({super.key, required this.eventStore});

  @override
  Widget build(BuildContext context) {
    // Exibe o widget ScrollMenu, que permite a navegação entre as páginas
    return ScrollMenu(
      menuItems: const ['Home', 'Lib', 'Search'],  // Itens do menu, que são os títulos das páginas
      pages: [
        HomePage(eventStore: eventStore),  // Página HomePage, passando o EventoStore
        const LibPage(),  // Página LibPage, que provavelmente exibe uma biblioteca ou lista de conteúdos
        const SearchPage(),  // Página SearchPage, onde o usuário pode realizar buscas
      ],
      icons: const [],  // Lista de ícones que podem ser exibidos ao lado dos itens do menu (não está sendo usado no código atual)
    );
  }
}

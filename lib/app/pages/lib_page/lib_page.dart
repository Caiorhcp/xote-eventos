import 'package:flutter/material.dart'; // Importa o pacote Flutter para usar os widgets.
import 'package:provider/provider.dart'; // Importa o pacote provider para gerenciar estado.
import 'package:xote_eventos/app/pages/search-page/event_card.dart'; // Importa o widget do card de evento.
import '/app/pages/stores/evento_store.dart'; // Importa o store para gerenciar os eventos favoritos.
import '../../widgets/customErrorWidget.dart'; // Importa o widget para exibir mensagens de erro customizadas.
import '../../widgets/LoadingWidget.dart'; // Importa o widget para exibir carregamento.

class LibPage extends StatefulWidget {
  const LibPage({super.key}); // Construtor da classe LibPage, com chave opcional.

  @override
  LibPageState createState() => LibPageState(); // Cria o estado da página.
}

class LibPageState extends State<LibPage> {
  @override
  void initState() {
    super.initState(); // Chama o initState da classe pai.

    // Executa o código após o layout ser renderizado para buscar os eventos favoritos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventoStore>().getFavoritos(); // Chama o método getFavoritos do EventoStore
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02142F), // Define a cor de fundo da página.
      appBar: AppBar(
        backgroundColor: const Color(0xFF000D1F), // Define a cor de fundo da AppBar.
        title: const Text(
          'Meus Eventos Favoritos', 
          style: TextStyle(color: Colors.white), // Define o título da AppBar.
        ),
      ),
      body: Consumer<EventoStore>(
        // Utiliza o Consumer para ouvir as mudanças no store de eventos.
        builder: (context, store, child) {
          if (store.isLoading.value) {
            return const LoadingWidget(); // Exibe o widget de carregamento enquanto os dados são carregados.
          }

          if (store.erro.value.isNotEmpty) {
            return CustomErrorWidget(errorMessage: store.erro.value); 
            // Exibe um widget de erro se houver uma mensagem de erro.
          }

          final eventosFavoritos = store.state.value; // Obtém a lista de eventos favoritos do store.

          if (eventosFavoritos.isEmpty) {
            return _buildEmptyState(); // Se não houver eventos favoritos, exibe o estado vazio.
          }

          return _buildEventList(eventosFavoritos); 
          // Se houver eventos favoritos, exibe a lista de eventos.
        },
      ),
    );
  }

  // Função que constrói o estado vazio quando não há eventos favoritos.
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centraliza os itens na tela.
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.white70), // Ícone de coração.
          SizedBox(height: 20), // Espaço entre o ícone e o texto.
          Text(
            'Você ainda não tem eventos favoritos.', 
            style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold), // Mensagem de texto.
          ),
          SizedBox(height: 10), // Espaço entre as mensagens.
          Text(
            'Adicione eventos aos seus favoritos para vê-los aqui.', 
            style: TextStyle(color: Colors.white54, fontSize: 16), // Texto informativo.
            textAlign: TextAlign.center, // Alinha o texto ao centro.
          ),
        ],
      ),
    );
  }

  // Função que constrói a lista de eventos favoritos.
  Widget _buildEventList(List eventosFavoritos) {
    return ListView.builder(
      itemCount: eventosFavoritos.length, // Define o número de itens na lista.
      itemBuilder: (context, index) {
        final evento = eventosFavoritos[index]; // Obtém o evento favorito da lista.
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0), // Define o padding do card.
          child: EventCard(event: evento), // Exibe o card de evento.
        );
      },
    );
  }
}

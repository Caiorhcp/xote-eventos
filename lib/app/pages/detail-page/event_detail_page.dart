import 'package:flutter/material.dart';
import '/app/data/models/event_model.dart'; // Modelo de dados para o evento
import '/app/pages/detail-page/event_image.dart'; // Widget para exibir a imagem do evento
import '/app/pages/detail-page/event_info.dart'; // Widget para exibir informações detalhadas do evento
import '/app/pages/detail-page/location_button.dart'; // Botão para abrir a localização do evento
import '/app/pages/detail-page/share_button.dart'; // Botão para compartilhar o evento
import 'package:url_launcher/url_launcher.dart'; // Biblioteca para abrir URLs

// Tela de detalhes do evento, que exibe informações detalhadas de um evento específico
class EventDetailPage extends StatefulWidget {
  final EventModel event; // Evento cujos detalhes serão exibidos

  const EventDetailPage({super.key, required this.event});

  @override
  EventDetailPageState createState() => EventDetailPageState();
}

class EventDetailPageState extends State<EventDetailPage> {
  bool isLoading = false; // Indica se uma ação assíncrona (como abrir uma URL) está em andamento

  // Método para abrir uma URL no navegador externo
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    setState(() {
      isLoading = true; // Define o estado de carregamento para verdadeiro
    });

    // Verifica se a URL pode ser aberta e tenta abrir no navegador externo
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Exibe uma mensagem de erro se a URL não puder ser aberta
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível abrir o link: $url')),
      );
    }

    setState(() {
      isLoading = false; // Define o estado de carregamento para falso
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02142F), // Cor de fundo da tela
      appBar: AppBar(
        title: const Text('Evento', style: TextStyle(color: Colors.white)), // Título do AppBar
        backgroundColor: const Color(0xFF000D1F), // Cor do AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Botão de voltar
          onPressed: () => Navigator.pop(context), // Volta para a tela anterior
        ),
      ),
      body: SingleChildScrollView( // Permite rolagem na tela
        child: Column(
          children: [
            EventImage(event: widget.event), // Exibe a imagem do evento
            const SizedBox(height: 16.0), // Espaçamento vertical
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.event.title, // Título do evento
                style: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 8.0),
            EventInfo(event: widget.event), // Informações detalhadas do evento
            const SizedBox(height: 16.0),
            _buildInfoCard('Tipo de Evento:', widget.event.type), // Card com o tipo do evento
            const SizedBox(height: 8.0),
            _buildInfoCard(
              'Preço:', 
              widget.event.pay ? 'R\$ ${widget.event.price.toStringAsFixed(2)}' : 'Gratuito', // Card com o preço
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribui os botões igualmente
                children: [
                  const ShareButton(), // Botão para compartilhar o evento
                  LocationButton( // Botão para exibir a localização do evento
                    event: widget.event, 
                    isLoading: isLoading, 
                    launchURL: _launchURL, // Função para abrir a URL da localização
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  // Método para construir um card com informações do evento
  Widget _buildInfoCard(String title, String content) {
    return Card(
      color: const Color(0xFF1F2A38), // Cor de fundo do card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), // Bordas arredondadas
      elevation: 5, // Sombra do card
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              '$title ', // Título do card
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                content, // Conteúdo do card
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis, // Trunca o texto longo com reticências
              ),
            ),
          ],
        ),
      ),
    );
  }
}

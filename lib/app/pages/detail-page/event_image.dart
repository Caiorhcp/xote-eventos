import 'package:flutter/material.dart';
import '/app/data/models/event_model.dart'; // Importa o modelo de dados do evento

// Widget para exibir a imagem de um evento com efeitos de carregamento e fallback
class EventImage extends StatelessWidget {
  final EventModel event; // O modelo do evento, contendo a URL da imagem

  const EventImage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Stack( // Permite sobrepor widgets, como a imagem e o gradiente
      children: [
        // Exibe a imagem do evento usando a URL fornecida
        Image.network(
          event.imageUrl, // URL da imagem
          fit: BoxFit.cover, // Ajusta a imagem para cobrir todo o espaço disponível
          width: double.infinity, // Largura máxima do container
          height: 250, // Altura fixa para a imagem
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child; // Exibe a imagem se o carregamento estiver completo
            return Center(
              child: CircularProgressIndicator( // Mostra um indicador de carregamento enquanto a imagem é carregada
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1) // Progresso do carregamento
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            // Exibe um fallback caso a imagem falhe ao carregar
            return Container(
              color: Colors.grey, // Fundo cinza como fallback
              child: const Center(
                child: Icon(Icons.error, color: Colors.white), // Ícone de erro
              ),
            );
          },
        ),
        // Adiciona um gradiente sobre a imagem para melhorar a legibilidade do texto sobreposto
        Container(
          height: 250, // Altura igual à altura da imagem
          decoration: BoxDecoration(
            gradient: LinearGradient( // Gradiente de preto para transparente
              colors: [Colors.black.withOpacity(0.4), Colors.transparent],
              begin: Alignment.bottomCenter, // Gradiente começa do rodapé
              end: Alignment.topCenter, // E vai até o topo
            ),
          ),
        ),
      ],
    );
  }
}

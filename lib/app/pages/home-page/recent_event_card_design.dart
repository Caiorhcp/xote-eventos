import 'package:flutter/material.dart';
import '/app/data/models/event_model.dart';  // Importa o modelo de dados EventModel, que representa os eventos

// Define o widget RecentEventCardDesign, que exibe um card com detalhes de um evento
class RecentEventCardDesign extends StatelessWidget {
  final EventModel event;  // O evento que será exibido no card
  final VoidCallback onTap;  // Função de callback que será chamada ao clicar no card

  // Construtor do widget RecentEventCardDesign
  const RecentEventCardDesign({
    super.key,
    required this.event,  // Evento a ser exibido
    required this.onTap,  // A ação que ocorre ao clicar no card
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),  // Adiciona padding horizontal ao redor do card
      child: GestureDetector(
        onTap: onTap,  // Chama a função onTap quando o card for tocado
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,  // A cor de fundo do card é transparente
            borderRadius: BorderRadius.circular(12.0),  // Bordas arredondadas para o card
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,  // Cor da sombra
                blurRadius: 8.0,  // O quanto a sombra é difusa
                offset: Offset(0, 4),  // Direção e tamanho da sombra
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),  // Garante que a imagem também tenha bordas arredondadas
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,  // Alinha os itens do card ao centro
              children: [
                Expanded(
                  child: Image.network(
                    event.imageUrl,  // Exibe a imagem do evento, obtida via URL
                    fit: BoxFit.cover,  // Faz a imagem cobrir o espaço do card
                    loadingBuilder: (context, child, loadingProgress) {
                      // Exibe um indicador de progresso enquanto a imagem está carregando
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      // Exibe um ícone de erro caso a imagem falhe ao carregar
                      return Container(
                        color: Colors.grey,  // Cor de fundo para a área de erro
                        child: const Center(
                          child: Icon(
                            Icons.error,  // Ícone de erro
                            color: Colors.white,  // Cor do ícone
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 4),  // Espaço entre a imagem e o título
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),  // Padding horizontal ao redor do título
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 150,  // Define a largura máxima do texto para não ocupar todo o espaço disponível
                    ),
                    child: Text(
                      event.title,  // Título do evento
                      style: const TextStyle(
                        color: Color(0xFFFFB854),  // Cor do texto do título
                        fontSize: 16,  // Tamanho da fonte
                        fontWeight: FontWeight.bold,  // Estilo de fonte em negrito
                      ),
                      textAlign: TextAlign.center,  // Alinha o texto ao centro
                      maxLines: 2,  // Limita o título a no máximo 2 linhas
                      overflow: TextOverflow.ellipsis,  // Adiciona "..." caso o texto ultrapasse o limite de linhas
                    ),
                  ),
                ),
                const SizedBox(height: 2),  // Espaço entre o título e as informações
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),  // Padding horizontal
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,  // Alinha os itens ao centro
                    children: [
                      const Icon(
                        Icons.calendar_today,  // Ícone de calendário
                        color: Colors.white70,  // Cor do ícone
                        size: 12,  // Tamanho do ícone
                      ),
                      const SizedBox(width: 4),  // Espaço entre o ícone e a data
                      Text(
                        event.formattedDate,  // Data formatada do evento
                        style: const TextStyle(
                          color: Colors.white70,  // Cor do texto
                          fontSize: 12,  // Tamanho da fonte
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),  // Padding horizontal
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,  // Alinha os itens ao centro
                    children: [
                      const Icon(
                        Icons.access_time,  // Ícone de relógio
                        color: Colors.white70,  // Cor do ícone
                        size: 12,  // Tamanho do ícone
                      ),
                      const SizedBox(width: 4),  // Espaço entre o ícone e a hora
                      Text(
                        event.time,  // Hora do evento
                        style: const TextStyle(
                          color: Colors.white70,  // Cor do texto
                          fontSize: 12,  // Tamanho da fonte
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),  // Espaço no final do card
              ],
            ),
          ),
        ),
      ),
    );
  }
}

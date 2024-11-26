import 'package:cached_network_image/cached_network_image.dart'; // Importa o widget para carregar imagens com cache.
import 'package:flutter/material.dart'; // Importa os widgets padrão do Flutter.
import '/app/data/models/event_model.dart'; // Importa o modelo de dados para os eventos.
import '/app/pages/detail-page/event_detail_page.dart'; // Importa a página de detalhes do evento.

class EventCard extends StatelessWidget {
  final EventModel event; // Recebe um objeto EventModel que contém os dados do evento.

  const EventCard({super.key, required this.event}); // Construtor que recebe o evento como parâmetro.

  @override
  Widget build(BuildContext context) {
    // Define a cor e o texto que serão exibidos para indicar se o evento é pago ou gratuito.
    final payColor = event.pay ? Colors.red : Colors.green;
    final payText = event.pay ? 'PAGO' : 'GRÁTIS';

    return GestureDetector(
      // Detecta o toque do usuário e navega para a página de detalhes do evento.
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EventDetailPage(event: event)),
      ),
      child: Card(
        elevation: 8, // Adiciona uma elevação (sombra) ao card.
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Define as margens do card.
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Faz os cantos do card arredondados.
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF001F3F), Color(0xFF000D1F)], // Cor de fundo do card com gradiente.
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10), // Aplica bordas arredondadas no card.
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Cor da sombra.
                blurRadius: 8, // Define o borrão da sombra.
                offset: const Offset(2, 4), // Define o deslocamento da sombra.
              ),
            ],
          ),
          padding: const EdgeInsets.all(12.0), // Adiciona padding interno ao card.
          child: Row(
            children: [
              // Exibe a imagem do evento com efeitos e uma sobreposição.
              Stack(
                children: [
                  Hero(
                    tag: event.id, // Hero widget para animação de transição de imagem.
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10), // Arredonda a borda da imagem.
                      child: CachedNetworkImage(
                        imageUrl: event.imageUrl, // URL da imagem do evento.
                        width: 120, // Largura da imagem.
                        height: 120, // Altura da imagem.
                        fit: BoxFit.cover, // Como a imagem se ajusta dentro do container.
                        placeholder: (_, __) => const Center(child: CircularProgressIndicator()), // Indicador de carregamento.
                        errorWidget: (_, __, ___) => const Icon(Icons.error, color: Colors.red, size: 30), // Icone de erro se a imagem falhar.
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.5), Colors.transparent], // Gradiente escuro na parte inferior da imagem.
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.circular(10), // Arredonda a borda do overlay.
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: payColor.withOpacity(0.8), // Cor do badge de "PAGO" ou "GRÁTIS".
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        payText, // Texto "PAGO" ou "GRÁTIS".
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16), // Espaço entre a imagem e as informações do evento.
              Expanded(
                child: Wrap(
                  spacing: 8, // Espaço entre os widgets dentro do Wrap.
                  runSpacing: 8, // Espaço entre as linhas do Wrap.
                  children: [
                    // Exibe o título do evento com formatação.
                    Text(
                      event.title, // Título do evento.
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 2, // Limita a exibição a 2 linhas.
                      overflow: TextOverflow.ellipsis, // Exibe reticências se o texto for muito longo.
                    ),
                    // Exibe a data do evento com ícone de calendário.
                    _infoRow(Icons.calendar_today, 'Data: ${event.formattedDate}'),
                    // Exibe a cidade do evento com ícone de local.
                    _infoCityRow(Icons.place, 'Cidade: ${event.city}'),
                    const Text(
                      'Clique para mais detalhes', // Texto informando sobre a ação ao tocar.
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para exibir as informações do evento (data ou cidade) com ícone.
  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey), // Ícone representando a informação.
        const SizedBox(width: 4), // Espaçamento entre o ícone e o texto.
        Expanded(
          child: Text(
            text, // Texto da informação.
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            overflow: TextOverflow.ellipsis, // Exibe reticências se o texto for muito longo.
          ),
        ),
      ],
    );
  }

  // Widget para exibir a cidade do evento (com uma abordagem diferente de layout).
  Widget _infoCityRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Alinha o ícone e o texto ao topo.
      children: [
        Icon(icon, size: 16, color: Colors.grey), // Ícone representando a cidade.
        const SizedBox(width: 4), // Espaçamento entre o ícone e o texto.
        Expanded(
          child: Text(
            text, // Texto da cidade.
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            softWrap: true, // Permite que o texto quebre a linha se necessário.
          ),
        ),
      ],
    );
  }
}

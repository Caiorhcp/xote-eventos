import 'package:flutter/material.dart'; // Importa o pacote Flutter para usar os widgets.
import '/app/data/models/event_model.dart'; // Importa o modelo de dados de evento.
import '/app/pages/search-page/event_card.dart'; // Importa o widget de card de evento.

Widget buildAnimatedEventList({
  required List<EventModel> visibleEvents, // Lista de eventos visíveis a serem exibidos.
  required GlobalKey<AnimatedListState> listKey, // Chave global para controlar a AnimatedList.
}) {
  return AnimatedList(
    key: listKey, // A chave global para a AnimatedList.
    initialItemCount: visibleEvents.length, // Define o número inicial de itens na lista.
    itemBuilder: (context, index, animation) {
      // Verifica se o índice está dentro do intervalo válido da lista.
      if (index >= visibleEvents.length) {
        return const SizedBox.shrink(); // Retorna um widget vazio caso o índice seja inválido.
      }

      final event = visibleEvents[index]; // Obtém o evento na posição 'index'.

      // Adiciona um atraso para cada item na lista com base no índice.
      final delay = Duration(milliseconds: 200 * index);

      // Retorna a animação de transição de deslize para o card de evento.
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero) // Define a animação de deslizamento.
            .animate(
              CurvedAnimation(
                parent: animation, // Animação fornecida pela AnimatedList.
                curve: Interval(
                  delay.inMilliseconds / 2000.0, // Aplica o atraso antes da animação iniciar.
                  1.0, // Define o intervalo de 0 a 1 para a duração da animação.
                  curve: Curves.easeInOut, // Define a curva de animação (suaviza a transição).
                ),
              ),
            ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0), // Adiciona um padding na parte inferior.
          child: EventCard(event: event), // Exibe o card do evento.
        ),
      );
    },
  );
}

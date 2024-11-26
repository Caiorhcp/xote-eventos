import 'package:flutter/material.dart';
import '/app/data/models/event_model.dart'; // Importa o modelo de dados do evento

// Widget para exibir informações detalhadas de um evento
class EventInfo extends StatelessWidget {
  final EventModel event; // O modelo do evento, contendo informações como data, hora, local e descrição

  const EventInfo({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Column( // Organiza os elementos verticalmente
      crossAxisAlignment: CrossAxisAlignment.start, // Alinha os itens ao início
      children: [
        // Linha contendo a data e a hora do evento
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribui igualmente os elementos
            children: [
              _buildEventInfo(Icons.calendar_today, event.formattedDate), // Data do evento
              _buildEventInfo(Icons.access_time, event.time), // Hora do evento
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        // Linha exibindo o local do evento
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Alinha os elementos ao topo
            children: [
              const Icon(Icons.location_on, size: 18.0, color: Colors.white), // Ícone de localização
              const SizedBox(width: 4.0),
              Expanded(
                child: Text(
                  '${event.local}, ${event.city},', // Endereço resumido
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  softWrap: true, // Permite quebra automática de linha
                ),
              ),
            ],
          ),
        ),
        // Linha exibindo a descrição detalhada do local
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 18.0, color: Colors.white), // Ícone de localização
              const SizedBox(width: 4.0),
              Expanded(
                child: Text(
                  event.localDescription, // Descrição do local
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20.0),
        // Seção para exibir a descrição do evento
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Descrição:', // Título da seção
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  letterSpacing: 0.5, // Espaçamento entre letras
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                width: double.infinity, // Ocupa toda a largura disponível
                decoration: BoxDecoration(
                  color: Colors.black54, // Fundo semitransparente para destaque
                  borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
                ),
                padding: const EdgeInsets.all(12.0), // Espaçamento interno
                child: Text(
                  event.description, // Descrição detalhada do evento
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    height: 1.8, // Espaçamento entre linhas
                    letterSpacing: 0.3, // Espaçamento entre caracteres
                    wordSpacing: 1.5, // Espaçamento entre palavras
                  ),
                  textAlign: TextAlign.justify, // Texto justificado para melhor aparência
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget auxiliar para exibir ícone e texto (como data e hora)
  Widget _buildEventInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.0, color: Colors.white), // Ícone representando a informação
        const SizedBox(width: 4.0),
        Text(
          text, // Texto associado ao ícone
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

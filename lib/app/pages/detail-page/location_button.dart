import 'package:flutter/material.dart';
import '/app/data/models/event_model.dart'; // Modelo de dados para eventos

class LocationButton extends StatelessWidget {
  final EventModel event; // Contém os dados do evento, incluindo a URL do local no Google Maps
  final bool isLoading; // Indica se o botão está em estado de carregamento
  final Future<void> Function(String url) launchURL; // Função assíncrona para abrir a URL

  const LocationButton({
    super.key,
    required this.event,
    required this.isLoading,
    required this.launchURL,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading
          ? null // Desativa o botão se estiver em estado de carregamento
          : () => launchURL(event.localGoogleUrl), // Abre a URL do local
      icon: const Icon(Icons.location_on, color: Colors.white), // Ícone do botão
      label: const Text(
        'Ver Localização', // Texto do botão
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1F2A38), // Cor de fundo do botão
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Espaçamento interno
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
        ),
      ),
    );
  }
}

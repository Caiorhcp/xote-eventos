import 'package:flutter/material.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Ação de compartilhamento (ainda não implementada)
      },
      icon: const Icon(Icons.share, color: Colors.white), // Ícone de compartilhamento
      label: const Text('Compartilhar', style: TextStyle(color: Colors.white)), // Texto do botão
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

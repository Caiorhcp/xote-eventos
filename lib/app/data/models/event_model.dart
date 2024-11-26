import 'package:intl/intl.dart'; // Importa a biblioteca intl para formatação de datas.

// Modelo de dados para representar um evento.
class EventModel {
  final String id; 
  final String imageUrl; 
  final String title; 
  final String description; 
  final DateTime date; 
  final String time; 
  final bool pay; 
  final String type; 
  final double price; 
  final String localGoogleUrl; 
  final String city; 
  final String local; 
  final String localDescription; 
  final bool isFavorite; 

  // Construtor do modelo, todos os campos são obrigatórios (usando `required`).
  EventModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.pay,
    required this.type,
    required this.price,
    required this.localGoogleUrl,
    required this.city,
    required this.local,
    required this.localDescription,
    required this.isFavorite,
  });

  // Getter para retornar a data formatada no formato 'dd/MM/yyyy'.
  String get formattedDate => DateFormat('dd/MM/yyyy').format(date);

  // Método de fábrica para criar um `EventModel` a partir de um Map.
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '', // Garante que o ID nunca seja nulo.
      imageUrl: map['image_url'] ?? '', // Lida com a possibilidade de valores nulos.
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] != null 
          ? DateTime.parse(map['date']) // Converte a data para o tipo DateTime.
          : DateTime.now(), // Usa a data atual como fallback.
      time: map['time'] ?? '',
      pay: map['pay'] ?? false,
      type: map['type'] ?? '',
      price: map['price'] != null 
          ? map['price'].toDouble() // Garante que o preço seja um double.
          : 0.0,
      localGoogleUrl: map['localgoogleurl'] ?? '',
      city: map['city'] ?? '',
      local: map['local'] ?? '',
      localDescription: map['localDescription'] ?? '',
      isFavorite: map['isFavorite'] ?? false, // Valor padrão para favoritos.
    );
  }

  // Método de fábrica para criar um `EventModel` a partir de um JSON.
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '', 
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      date: json['date'] != null 
          ? DateTime.parse(json['date']) 
          : DateTime.now(),
      time: json['time'] ?? '',
      pay: json['pay'] ?? false,
      type: json['type'] ?? '',
      price: json['price'] != null 
          ? json['price'].toDouble() 
          : 0.0,
      localGoogleUrl: json['localGoogleUrl'] ?? '',
      city: json['city'] ?? '',
      local: json['local'] ?? '',
      localDescription: json['localDescription'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}

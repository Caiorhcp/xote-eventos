import 'dart:convert';
import 'package:xote_eventos/app/data/http/exceptions.dart';
import 'package:xote_eventos/app/data/http/http_client.dart';
import 'package:xote_eventos/app/data/models/event_model.dart';
import 'package:http/http.dart' as http;

abstract class IEventRepository {
  Future<List<EventModel>> getEventos();
  Future<List<EventModel>> getRecentEvents();
  Future<List<EventModel>> getPaidEvents();
  Future<List<EventModel>> getPaidEventsAsc();
  Future<List<EventModel>> getPaidEventsDesc();
  Future<List<EventModel>> getFreeEvents();
  Future<List<EventModel>> getEventsByType(String eventType);
  Future<List<EventModel>> getEventsByDateAsc();
  Future<List<EventModel>> getEventsByDateDesc();
  Future<List<EventModel>> getEventsByCity(String eventCity);
  Future<List<EventModel>> getFavoritos();
  Future<void> favoriteEvent(String id);
  Future<void> unfavoriteEvent(String id);
}

class EventRepository implements IEventRepository {
  final IHttpClient client;

  EventRepository({required this.client});

  @override
  Future<List<EventModel>> getEventos() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/get',
    );
    return _handleResponse(response);
  }

  @override
  Future<List<EventModel>> getFavoritos() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/isFavoriteTrue',
    );
    return _handleResponse(response);
  }

  @override
  Future<List<EventModel>> getRecentEvents() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/recent',
    );
    return _handleResponse(response);
  }

  @override
  Future<List<EventModel>> getPaidEvents() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/paid',
    );
    return _handleResponse(response);
  }

  @override
  Future<List<EventModel>> getPaidEventsAsc() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/paid/asc',
    );
    return _handleResponse(response);
  }

  @override
  Future<List<EventModel>> getPaidEventsDesc() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/paid/desc',
    );
    return _handleResponse(response);
  }

  @override
  Future<List<EventModel>> getFreeEvents() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/free',
    );
    return _handleResponse(response);
  }

  @override
  Future<List<EventModel>> getEventsByType(String eventType) async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/get/type/$eventType',
    );
    return _handleResponse(response);
  }

  @override
  Future<List<EventModel>> getEventsByDateAsc() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/date/asc',
    );
    return _handleResponse(response);
  }

  @override
  Future<List<EventModel>> getEventsByDateDesc() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/date/desc',
    );
    return _handleResponse(response);
  }

  @override
  Future<List<EventModel>> getEventsByCity(String eventCity) async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/city/$eventCity',
    );
    return _handleResponse(response);
  }

  // Método para favoritar evento (utilizando PUT)
  @override
  Future<void> favoriteEvent(String id) async {
    final response = await client.put(
      url: 'https://xote-api-development.up.railway.app/xote/$id/favorite',
      body: ({'isFavorite': true}),  
    );
    _handleResponse(response);  // Tratamento da resposta da API
  }

  // Método para desfavoritar evento (utilizando PUT)
  @override
  Future<void> unfavoriteEvent(String id) async {
    final response = await client.put(
      url: 'https://xote-api-development.up.railway.app/xote/$id/favorite',
      body: ({'isFavorite': false}),  

    );
    _handleResponse(response);  // Tratamento da resposta da API
  }

  Future<List<EventModel>> _handleResponse(http.Response response) async {
    if (response.statusCode == 200) {
      final List<EventModel> eventos = [];
      
      try {
        final body = jsonDecode(response.body);
        
        if (body['XoteEventos'] != null && body['XoteEventos'] is List) {
          final eventosList = body['XoteEventos'] as List;

          for (var item in eventosList) {
            final EventModel evento = EventModel.fromMap(item);
            eventos.add(evento);
          }
        } else {
          throw Exception('Formato inesperado da resposta: XoteEventos não é uma lista');
        }
      } catch (e) {
        throw Exception('Erro ao decodificar o JSON: $e');
      }

      return eventos;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não é válida');
    } else {
      throw Exception('Não foi possível acessar os eventos: ${response.reasonPhrase}');
    }
  }
}

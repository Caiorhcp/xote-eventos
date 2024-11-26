import 'dart:convert';
import 'package:xote_eventos/app/data/http/exceptions.dart';
import 'package:xote_eventos/app/data/http/http_client.dart';
import 'package:xote_eventos/app/data/models/event_model.dart';
import 'package:http/http.dart' as http;

/// Interface que define os métodos obrigatórios para o repositório de eventos.
/// Facilita o desacoplamento e garante que qualquer implementação respeite este contrato.
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

/// Implementação concreta do repositório de eventos.
/// Realiza requisições HTTP para uma API externa e manipula os dados recebidos.
class EventRepository implements IEventRepository {
  /// Cliente HTTP utilizado para realizar as requisições.
  final IHttpClient client;

  /// Construtor que exige a injeção de um cliente HTTP.
  EventRepository({required this.client});

  /// Obtém todos os eventos disponíveis.
  @override
  Future<List<EventModel>> getEventos() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/get',
    );
    return _handleResponse(response);
  }

  /// Obtém todos os eventos marcados como favoritos.
  @override
  Future<List<EventModel>> getFavoritos() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/isFavoriteTrue',
    );
    return _handleResponse(response);
  }

  /// Obtém os eventos mais recentes.
  @override
  Future<List<EventModel>> getRecentEvents() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/recent',
    );
    return _handleResponse(response);
  }

  /// Obtém os eventos pagos.
  @override
  Future<List<EventModel>> getPaidEvents() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/paid',
    );
    return _handleResponse(response);
  }

  /// Obtém os eventos pagos em ordem crescente de preço.
  @override
  Future<List<EventModel>> getPaidEventsAsc() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/paid/asc',
    );
    return _handleResponse(response);
  }

  /// Obtém os eventos pagos em ordem decrescente de preço.
  @override
  Future<List<EventModel>> getPaidEventsDesc() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/paid/desc',
    );
    return _handleResponse(response);
  }

  /// Obtém os eventos gratuitos.
  @override
  Future<List<EventModel>> getFreeEvents() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/free',
    );
    return _handleResponse(response);
  }

  /// Obtém eventos filtrados por tipo.
  @override
  Future<List<EventModel>> getEventsByType(String eventType) async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/get/type/$eventType',
    );
    return _handleResponse(response);
  }

  /// Obtém eventos ordenados por data em ordem crescente.
  @override
  Future<List<EventModel>> getEventsByDateAsc() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/date/asc',
    );
    return _handleResponse(response);
  }

  /// Obtém eventos ordenados por data em ordem decrescente.
  @override
  Future<List<EventModel>> getEventsByDateDesc() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/date/desc',
    );
    return _handleResponse(response);
  }

  /// Obtém eventos filtrados por cidade.
  @override
  Future<List<EventModel>> getEventsByCity(String eventCity) async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/city/$eventCity',
    );
    return _handleResponse(response);
  }

  /// Marca um evento como favorito utilizando uma requisição PUT.
  @override
  Future<void> favoriteEvent(String id) async {
    final response = await client.put(
      url: 'https://xote-api-development.up.railway.app/xote/$id/favorite',
      body: ({'isFavorite': true}),
    );
    _handleResponse(response); // Valida a resposta da API.
  }

  /// Remove a marcação de favorito de um evento utilizando uma requisição PUT.
  @override
  Future<void> unfavoriteEvent(String id) async {
    final response = await client.put(
      url: 'https://xote-api-development.up.railway.app/xote/$id/favorite',
      body: ({'isFavorite': false}),
    );
    _handleResponse(response); // Valida a resposta da API.
  }

  /// Trata a resposta da API e retorna uma lista de [EventModel].
  /// 
  /// Lança exceções em caso de erro na requisição ou no formato da resposta.
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
      throw NotFoundException('A URL informada não é válida');
    } else {
      throw Exception('Não foi possível acessar os eventos: ${response.reasonPhrase}');
    }
  }
}

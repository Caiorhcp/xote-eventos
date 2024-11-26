import 'package:flutter/material.dart'; // Importação da biblioteca Material do Flutter
import '/app/data/http/exceptions.dart'; // Importação das exceções personalizadas para erros HTTP
import '/app/data/http/http_client.dart'; // Importação do cliente HTTP personalizado
import '/app/data/models/event_model.dart'; // Importação do modelo de dados dos eventos
import '/app/data/repositories/event_repository.dart'; // Importação do repositório de eventos

// A classe EventoStore é responsável por gerenciar o estado dos eventos e suas interações
class EventoStore extends ChangeNotifier {
  final IEventRepository repository; // Repositório de eventos, utilizado para buscar dados
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false); // Estado de carregamento (verdadeiro ou falso)
  final ValueNotifier<List<EventModel>> state = ValueNotifier<List<EventModel>>([]); // Estado que armazena a lista de eventos
  final ValueNotifier<String> erro = ValueNotifier<String>(''); // Estado para armazenar mensagens de erro

  // Construtor que recebe o repositório e o cliente HTTP
  EventoStore({required this.repository, required HttpClient client});

  // Método genérico para buscar eventos, recebe uma função que retorna a lista de eventos
  Future<void> _fetchEvents(Future<List<EventModel>> Function() fetchFunction) async {
    isLoading.value = true; // Define que está carregando
    erro.value = ''; // Limpa mensagens de erro anteriores

    try {
      final result = await fetchFunction(); // Chama a função de busca de eventos
      state.value = result; // Atualiza o estado com os eventos recebidos
      notifyListeners(); // Notifica os ouvintes sobre a atualização do estado
    } on NotFoundException catch (e) {
      erro.value = e.message; // Captura erro caso o evento não seja encontrado
    } catch (e) {
      erro.value = e.toString(); // Captura outros erros
    } finally {
      isLoading.value = false; // Finaliza o carregamento
    }
  }

  // Método para obter todos os eventos
  Future<void> getEventos() async {
    await _fetchEvents(repository.getEventos); // Chama o método getEventos do repositório
  }

  // Método para obter eventos favoritos
  Future<void> getFavoritos() async {
    await _fetchEvents(repository.getFavoritos); // Chama o método getFavoritos do repositório
  }

  // Método para obter eventos recentes
  Future<void> getRecentEventos() async {
    await _fetchEvents(repository.getRecentEvents); // Chama o método getRecentEvents do repositório
  }

  // Método para obter eventos pagos
  Future<void> getPaidEventos() async {
    await _fetchEvents(repository.getPaidEvents); // Chama o método getPaidEvents do repositório
  }

  // Método para obter eventos gratuitos
  Future<void> getFreeEventos() async {
    await _fetchEvents(repository.getFreeEvents); // Chama o método getFreeEvents do repositório
  }

  // Método para obter eventos por tipo (Exemplo: Cultural, Religioso)
  Future<void> getEventosByType(String eventType) async {
    await _fetchEvents(() => repository.getEventsByType(eventType)); // Chama o método getEventsByType do repositório
  }

  // Método para buscar eventos pelo título, retorna uma lista filtrada
  List<EventModel> searchEvents(String query) {
    return state.value.where((event) {
      return event.title.toLowerCase().contains(query.toLowerCase()); // Filtra pelo título do evento
    }).toList();
  }

  // Método para obter eventos por data em ordem crescente
  Future<void> getEventosByDateAsc() async {
    await _fetchEvents(repository.getEventsByDateAsc); // Chama o método getEventsByDateAsc do repositório
  }

  // Método para obter eventos por data em ordem decrescente
  Future<void> getEventosByDateDesc() async {
    await _fetchEvents(repository.getEventsByDateDesc); // Chama o método getEventsByDateDesc do repositório
  }

  // Método para obter eventos por cidade
  Future<void> getEventosByCity(String eventCity) async {
    await _fetchEvents(() => repository.getEventsByCity(eventCity)); // Chama o método getEventsByCity do repositório
  }

  // Método para favoritar um evento
  Future<void> favoriteEvent(String eventId) async {
    isLoading.value = true; // Inicia o carregamento
    erro.value = ''; // Limpa mensagens de erro anteriores

    try {
      await repository.favoriteEvent(eventId); // Chama o método favoriteEvent do repositório
      notifyListeners(); // Notifica os ouvintes sobre a mudança de estado
    } on NotFoundException catch (e) {
      erro.value = e.message; // Captura erro caso o evento não seja encontrado
    } catch (e) {
      erro.value = e.toString(); // Captura outros erros
    } finally {
      isLoading.value = false; // Finaliza o carregamento
    }
  }

  // Método para desfavoritar um evento
  Future<void> unfavoriteEvent(String eventId) async {
    isLoading.value = true; // Inicia o carregamento
    erro.value = ''; // Limpa mensagens de erro anteriores

    try {
      await repository.unfavoriteEvent(eventId); // Chama o método unfavoriteEvent do repositório
      notifyListeners(); // Notifica os ouvintes sobre a mudança de estado
    } on NotFoundException catch (e) {
      erro.value = e.message; // Captura erro caso o evento não seja encontrado
    } catch (e) {
      erro.value = e.toString(); // Captura outros erros
    } finally {
      isLoading.value = false; // Finaliza o carregamento
    }
  }
}

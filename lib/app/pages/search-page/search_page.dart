import 'dart:async';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xote_eventos/app/data/models/event_model.dart';
import 'package:xote_eventos/app/pages/search-page/animations.dart';
import 'package:xote_eventos/app/pages/stores/evento_store.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}
class SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  late List<EventModel> allEvents;
  late List<EventModel> searchResults;
  late Future<void> _loadingEventsFuture;
  final List<EventModel> _visibleEvents = [];
  int _visibleEventCount = 10;
  late Timer _debounce;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  String _selectedFilter = 'Todos'; // Variável para armazenar o filtro selecionado
  String _selectedSort = 'Mais Proximos'; // Filtro de ordenação

  @override
  void initState() {
    super.initState();
    allEvents = [];
    searchResults = [];
    _loadingEventsFuture = _fetchAllEvents();
    _debounce = Timer.periodic(const Duration(seconds: 1), (timer) {});
  }

  @override
  void dispose() {
    _debounce.cancel();
    super.dispose();
  }

  Future<void> _fetchAllEvents() async {
    try {
      final eventoStore = Provider.of<EventoStore>(context, listen: false);

      // Verifica qual filtro está selecionado e chama o método apropriado
      switch (_selectedFilter) {
        case 'Eventos Recentes':
          await eventoStore.getRecentEventos();
          break;
        case 'Eventos Pagos':
          await eventoStore.getPaidEventos();
          break;
        case 'Eventos Gratuitos':
          await eventoStore.getFreeEventos();
          break;
        default:
          await eventoStore.getEventos();
          break;
      }

      setState(() {
        allEvents = eventoStore.state.value;
        searchResults = allEvents;
        _applySorting(); // Aplica a ordenação quando os eventos são carregados
        _initializeVisibleEvents();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro ao carregar eventos: ${e.toString()}')));
    }
  }

  void _applySorting() {
    switch (_selectedSort) {
      case 'Mais Proximos':
        searchResults.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'Mais Distantes':
        searchResults.sort((a, b) => b.date.compareTo(a.date));
        break;
    }
  }

  void _initializeVisibleEvents() {
    _visibleEvents.clear();
    int eventCount = searchResults.length;
    for (int i = 0; i < _visibleEventCount && i < eventCount; i++) {
      _visibleEvents.add(searchResults[i]);
      _listKey.currentState?.insertItem(i);
    }
  }

  void _searchEvents(String query) {
    if (_debounce.isActive) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final normalizedQuery = removeDiacritics(query.toLowerCase());
      setState(() {
        searchResults = allEvents.where((event) {
          return removeDiacritics(event.title.toLowerCase())
              .contains(normalizedQuery);
        }).toList();
        _applySorting(); // Aplica a ordenação após a pesquisa
        _resetVisibleEvents();
      });
    });
  }

  void _resetVisibleEvents() {
    _visibleEvents.clear();
    _listKey.currentState?.setState(() {});
    _initializeVisibleEvents();
  }

  void _showMoreEvents() {
    final newCount = _visibleEventCount + 3;
    final maxVisible = searchResults.length;

    // Ajusta o novo count para não ultrapassar o número máximo de eventos disponíveis
    final validNewCount = newCount > maxVisible ? maxVisible : newCount;

    // Insere os eventos visíveis de forma segura
    for (int i = _visibleEventCount; i < validNewCount; i++) {
      if (i < searchResults.length) {
        _visibleEvents.add(searchResults[i]);
        _listKey.currentState?.insertItem(i);
      }
    }

    setState(() {
      _visibleEventCount = validNewCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Eventos',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF000D1F),
      ),
      body: Container(
        color: const Color(0xFF02142F),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Digite o nome do evento',
                  labelStyle: const TextStyle(
                      color: Color(0xFFFFB854), fontWeight: FontWeight.bold),
                  hintText: 'Ex: Show de Música',
                  filled: true,
                  fillColor: const Color(0xFF2F3349),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
                          onPressed: () {
                            _searchController.clear();
                            _searchEvents('');
                          },
                        )
                      : null,
                ),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                onChanged: _searchEvents,
              ),
            ),
            // Adicionando os Dropdowns de filtro e ordenação em uma Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      onChanged: (String? newFilter) {
                        setState(() {
                          _selectedFilter = newFilter ?? 'Todos';
                          _loadingEventsFuture = _fetchAllEvents(); // Recarrega os eventos com o novo filtro
                        });
                      },
                      items: <String>['Todos', 'Eventos Recentes', 'Eventos Pagos', 'Eventos Gratuitos']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      dropdownColor: const Color(0xFF2F3349),
                      iconEnabledColor: Colors.white,
                      iconSize: 30,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Espaço entre os Dropdowns
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: DropdownButton<String>(
                      value: _selectedSort,
                      onChanged: (String? newSort) {
                        setState(() {
                          _selectedSort = newSort ?? 'Mais Proximos';
                          _applySorting(); 
                          _resetVisibleEvents();
                        });
                      },
                      items: <String>['Mais Proximos', 'Mais Distantes']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      dropdownColor: const Color(0xFF2F3349),
                      iconEnabledColor: Colors.white,
                      iconSize: 30,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<void>(
                future: _loadingEventsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Erro: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white)));
                  } else {
                    return searchResults.isEmpty
                        ? const Center(
                            child: Text('Nenhum evento encontrado',
                                style: TextStyle(color: Colors.white)))
                        : Column(
                            children: [
                              Expanded(
                                child: buildAnimatedEventList(
                                  visibleEvents: _visibleEvents,
                                  listKey: _listKey,
                                ),
                              ),
                              if (_visibleEventCount < searchResults.length)
                                TextButton(
                                  onPressed: _showMoreEvents,
                                  child: const Text(
                                    'Mostrar mais',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                            ],
                          );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
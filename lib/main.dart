import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xote_eventos/app/data/http/http_client.dart';
import 'package:xote_eventos/app/data/repositories/event_repository.dart';
import 'package:xote_eventos/app/pages/home-page/app_navigation.dart';
import 'package:xote_eventos/app/pages/stores/evento_store.dart';

void main() {
  final HttpClient httpClient = HttpClient();
  final IEventRepository eventRepository = EventRepository(client: httpClient);
  final EventoStore eventoStore = EventoStore(repository: eventRepository, client: httpClient);

  runApp(
    ChangeNotifierProvider<EventoStore>( 
      create: (context) => eventoStore,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'XoteCariri',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AppNavigation(),
      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '/app/data/models/event_model.dart';
import '/app/pages/detail-page/event_detail_page.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final payColor = event.pay ? Colors.red : Colors.green;
    final payText = event.pay ? 'PAGO' : 'GRÁTIS';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EventDetailPage(event: event)),
      ),
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF001F3F), Color(0xFF000D1F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Stack(
                children: [
                  Hero(
                    tag: event.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: event.imageUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (_, __, ___) => const Icon(Icons.error, color: Colors.red, size: 30),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: payColor.withOpacity(0.8),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        payText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    _infoRow(Icons.calendar_today, 'Data: ${event.formattedDate}'),
                    _infoCityRow(Icons.place, 'Cidade: ${event.city}'),
                    const Text(
                      'Clique para mais detalhes',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _infoCityRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

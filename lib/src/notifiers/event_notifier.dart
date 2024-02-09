import 'package:flutter/cupertino.dart';
import 'package:flutter_community_ibague/src/data/events_repository.dart';

class EventNotifier extends ChangeNotifier {
  final EventsRepository _eventsRepository;

  final String eventId;

  EventNotifier({
    required this.eventId,
    EventsRepository? eventsRepository,
  }) : _eventsRepository = eventsRepository ?? EventsRepository();

  void attendEvent(
    String uid,
  ) {
    _eventsRepository.attendToEvent(eventId, uid);
  }

  void notAttendEvent(
    String uid,
  ) {
    _eventsRepository.notAttendToEvent(eventId, uid);
  }
}

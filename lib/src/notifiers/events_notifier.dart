import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_community_ibague/src/data/events_repository.dart';
import 'package:flutter_community_ibague/src/models/event.dart';

class EventsNotifier extends ChangeNotifier {
  final EventsRepository _eventsRepository;

  EventsNotifier({EventsRepository? eventsRepository})
      : _eventsRepository = eventsRepository ?? EventsRepository() {
    init();
  }

  late StreamSubscription _eventsSubscription;
  List<Event> events = [];

  void init() {
    _eventsSubscription =
        _eventsRepository.eventsStream().listen((events) async {
      for (final event in events) {
        event.attendees = await _eventsRepository.attendeesCount(event.id);
      }
      this.events = events;
      notifyListeners();
    });
  }
}

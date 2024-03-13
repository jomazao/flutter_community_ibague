import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_community_ibague/src/data/events_repository.dart';
import 'package:flutter_community_ibague/src/models/event.dart';

class EventNotifier extends ChangeNotifier {
  final EventsRepository _eventsRepository;
  final FirebaseAuth _auth;
  String eventId;
  Event? event;
  bool get attending =>
      event != null ? event!.attendees.any((uid) => uid == _user?.uid) : false;
  late final StreamSubscription _eventSubscription;
  User? get _user => _auth.currentUser;

  EventNotifier({
    required this.eventId,
    Event? event,
    EventsRepository? eventsRepository,
    FirebaseAuth? auth,
  })  : _eventsRepository = eventsRepository ?? EventsRepository(),
        _auth = auth ?? FirebaseAuth.instance {
    _eventSubscription =
        _eventsRepository.eventStream(id: eventId).listen((event) {
      this.event = event;
      notifyListeners();
    });
  }

  void attendEvent() {
    if (_user != null) {
      _eventsRepository.attendToEvent(event!.id, _user!.uid);
    }
  }

  void notAttendEvent() {
    if (_user != null) {
      _eventsRepository.notAttendToEvent(event!.id, _user!.uid);
    }
  }

  @override
  void dispose() {
    _eventSubscription.cancel();
    super.dispose();
  }
}

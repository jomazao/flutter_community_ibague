import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_community_ibague/src/models/event.dart';

class EventsRepository {
  final FirebaseFirestore _firestore;

  EventsRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Event>> eventsStream() {
    return _firestore
        .collection('events')
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map(
              (doc) => Event.fromJson(
                id: doc.id,
                json: doc.data(),
              ),
            )
            .toList());
  }

  Stream<Event> eventStream({required String id}) {
    return _firestore
        .collection('events')
        .doc(id)
        .snapshots()
        .map((doc) => Event.fromJson(
              id: doc.id,
              json: doc.data() ?? {},
            ));
  }

  Future<void> attendToEvent(String eventId, String uid) async {
    await _firestore.collection('events').doc(eventId).update({
      'attendees': FieldValue.arrayUnion([uid])
    });
  }

  Future<void> notAttendToEvent(String eventId, String uid) async {
    await _firestore.collection('events').doc(eventId).update({
      'attendees': FieldValue.arrayRemove([uid])
    });
  }
}

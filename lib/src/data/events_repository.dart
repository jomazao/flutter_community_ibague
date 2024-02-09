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

  Future<int> attendeesCount(String eventId) async {
    final result = await _firestore
        .collection('events')
        .doc(eventId)
        .collection('attendees')
        .count()
        .get();
    return result.count ?? 0;
  }

  Future<void> attendToEvent(String eventId, String uid) async {
    await _firestore
        .collection('events')
        .doc(eventId)
        .collection('attendees')
        .doc(uid)
        .set({'attend': true});
  }

  Future<void> notAttendToEvent(String eventId, String uid) async {
    await _firestore
        .collection('events')
        .doc(eventId)
        .collection('attendees')
        .doc(uid)
        .delete();
  }

  Stream<bool> attendStream(String eventId, String uid) {
    return _firestore
        .collection('events')
        .doc(eventId)
        .collection('attendees')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists);
  }
}

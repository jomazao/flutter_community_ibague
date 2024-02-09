import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String banner;
  final DateTime dateTime;
  final String location;
  int attendees = 0;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.banner,
    required this.dateTime,
    required this.location,
  });

  factory Event.fromJson({
    required String id,
    required Map json,
  }) {
    final dateTimeTimeStamp = json['dateTime'] as Timestamp;

    return Event(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      banner: json['banner'] ?? '',
      dateTime: dateTimeTimeStamp.toDate(),
      location: json['location'] ?? '',
    );
  }
}

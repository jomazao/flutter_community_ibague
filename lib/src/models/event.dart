import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String banner;
  final DateTime dateTime;
  final String locationTitle;
  final String recommendations;
  final String locationDetails;
  final GeoPoint location;
  final String calendarUrl;
  final String locationUrl;
  final List<String> attendees;
  final List<dynamic> speakers;

  int get attendeesCount => attendees.length;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.banner,
    required this.dateTime,
    required this.location,
    required this.recommendations,
    required this.locationDetails,
    required this.locationTitle,
    required this.calendarUrl,
    required this.locationUrl,
    required this.attendees,
    required this.speakers,
  });

  factory Event.fromJson({
    required String id,
    required Map json,
  }) {
    final dateTimeTimeStamp = json['dateTime'] as Timestamp;

    final recommendations = (json['recommendations']).replaceAll("\\n", "\n");

    final attendees = (json['attendees'] as List<dynamic>? ?? [])
        .map<String>((uid) => '$uid')
        .toList();

    return Event(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      banner: json['banner'] ?? '',
      dateTime: dateTimeTimeStamp.toDate(),
      location: json['location'] ?? '',
      locationTitle: json['location_title'] ?? '',
      locationDetails: json['location_details'] ?? '',
      locationUrl: json['location_url'] ?? '',
      calendarUrl: json['calendar_url'] ?? '',
      recommendations: recommendations,
      attendees: attendees,
      speakers: json['speakers'] ?? {},
    );
  }
}

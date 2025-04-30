import 'package:cloud_firestore/cloud_firestore.dart';

class EventGroup {
  final String id;
  final String title;
  final String eventLocation;
  final String description;
  final DateTime createdAt;
  final String createdBy;
  final DateTime fromDateTime;
  final DateTime toDateTime;

  EventGroup({
    required this.id,
    required this.title,
    required this.eventLocation,
    required this.description,
    required this.createdAt,
    required this.createdBy,
    required this.fromDateTime,
    required this.toDateTime,
  });

  // create new event group
  factory EventGroup.create({
    required String title,
    required String description,
    required String eventLocation,
    required String createdBy,
    required DateTime fromDateTime,
    required DateTime toDateTime,
  }) {
    return EventGroup(
      id: '',
      title: title,
      eventLocation: eventLocation,
      description: description,
      createdAt: DateTime.now().toUtc(),
      createdBy: createdBy,
      fromDateTime: fromDateTime,
      toDateTime: toDateTime,
    );
  }

  // convert from Firestore
  factory EventGroup.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventGroup(
      id: doc.id,
      title: data['title'] ?? '',
      eventLocation: data['eventLocation'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
      fromDateTime: data['fromDateTime'] != null
          ? (data['fromDateTime'] as Timestamp).toDate()
          : DateTime.now().toUtc(),
      toDateTime: data['toDateTime'] != null
          ? (data['toDateTime'] as Timestamp).toDate()
          : DateTime.now().toUtc(),
    );
  }

  // convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'eventLocation': eventLocation,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'fromDateTime': Timestamp.fromDate(fromDateTime),
      'toDateTime': Timestamp.fromDate(toDateTime),
    };
  }
}

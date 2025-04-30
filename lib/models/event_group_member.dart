import 'package:cloud_firestore/cloud_firestore.dart';

class EventGroupMember {
  final String userId;
  final String name;
  final DateTime joinedAt;
  final GeoPoint location;
  final DateTime locationUpdatedAt;

  EventGroupMember({
    required this.userId,
    required this.name,
    required this.joinedAt,
    required this.location,
    required this.locationUpdatedAt,
  });

  // create member
  factory EventGroupMember.create({
    required String userId,
    required String name,
    required GeoPoint initialLocation, // 0,0
  }) {
    final now = DateTime.now().toUtc();
    return EventGroupMember(
      userId: userId,
      name: name,
      joinedAt: now,
      location: initialLocation,
      locationUpdatedAt: now,
    );
  }

  // convert from Firestore
  factory EventGroupMember.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventGroupMember(
      userId: doc.id,
      name: data['name'] ?? '',
      joinedAt: data['joinedAt'] != null 
          ? (data['joinedAt'] as Timestamp).toDate() 
          : DateTime.now().toUtc(),
      location: data['location'] ?? const GeoPoint(0, 0),
      locationUpdatedAt: data['locationUpdatedAt'] != null 
          ? (data['locationUpdatedAt'] as Timestamp).toDate() 
          : DateTime.now().toUtc(),
    );
  }

  // convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'location': location,
      'locationUpdatedAt': Timestamp.fromDate(locationUpdatedAt),
    };
  }

  // copy with updated location
  EventGroupMember updateLocation(GeoPoint newLocation) {
    return EventGroupMember(
      userId: userId,
      name: name,
      joinedAt: joinedAt,
      location: newLocation,
      locationUpdatedAt: DateTime.now().toUtc(),
    );
  }
}
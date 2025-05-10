import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewlink/models/event_group.dart';
import 'package:crewlink/models/event_group_member.dart';

// service methods to manage group events
class EventGroupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // create a new event group, assigns the current user as the first member
  Future<String> createEventGroup({
    required EventGroup eventGroup,
    required String currentUserId,
    required String currentUserName,
    required GeoPoint currentUserLocation,
  }) async {
    // create the event group document
    final docRef = await _firestore
        .collection('eventGroups')
        .add(eventGroup.toFirestore());
    
    // create user as the first member
    final ownerMember = EventGroupMember.create(
      userId: currentUserId,
      name: currentUserName,
      initialLocation: currentUserLocation,
    );
    
    // add to members subcollectoin
    await _firestore
        .collection('eventGroups')
        .doc(docRef.id)
        .collection('members')
        .doc(currentUserId)
        .set(ownerMember.toFirestore());
    
    return docRef.id;
  }
  
  // get event group by id
  Future<EventGroup?> getEventGroup(String groupId) async {
    final doc = await _firestore.collection('eventGroups').doc(groupId).get();
    if (doc.exists) {
      return EventGroup.fromFirestore(doc);
    }
    return null;
  }
}
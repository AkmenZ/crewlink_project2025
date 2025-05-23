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
    try {
      final newGroupId = await _firestore.runTransaction((transaction) async {
        // create event group
        final newGroupRef = _firestore.collection('eventGroups').doc();
        transaction.set(newGroupRef, eventGroup.toFirestore());

        // make the current user the owner of the group
        final ownerMember = EventGroupMember.create(
          userId: currentUserId,
          name: currentUserName,
          initialLocation: currentUserLocation,
        );

        // add to the members subcollection
        final membersRef = newGroupRef.collection('members').doc(currentUserId);
        transaction.set(membersRef, ownerMember.toFirestore());

        // update the users memberOfGroups
        final userRef = _firestore.collection('users').doc(currentUserId);
        transaction.update(userRef, {
          'memberOfEventGroups': FieldValue.arrayUnion([newGroupRef.id]),
        });

        return newGroupRef.id;
      });
      return newGroupId; // return id
    } catch (error) {
      throw Exception('Failed to create event group');
    }
  }

  // get event group by id
  Future<EventGroup?> getEventGroup(String groupId) async {
    final doc = await _firestore.collection('eventGroups').doc(groupId).get();
    if (doc.exists) {
      return EventGroup.fromFirestore(doc);
    }
    return null;
  }

  // get all event groups for a member
  Future<List<EventGroup>> getEventGroupsForMember(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        return []; // return empty list if user does not exist
      }

      // get memberOfEventGroups array for user
      final memberOfEventGroups =
          List<String>.from(userDoc.data()?['memberOfEventGroups'] ?? []);

      // get details for each EventGroup ID in the list
      final eventGroups = await Future.wait(
        memberOfEventGroups.map((groupId) async {
          final groupDoc =
              await _firestore.collection('eventGroups').doc(groupId).get();
          if (groupDoc.exists) {
            return EventGroup.fromFirestore(groupDoc);
          }
          return null;
        }),
      );

      // filters out null values
      return eventGroups.whereType<EventGroup>().toList();
    } catch (e) {
      return [];
    }
  }

  // get event group members
  Future<List<EventGroupMember>> getEventGroupMembers(String groupId) async {
    try {
      final membersSnapshot = await _firestore
          .collection('eventGroups')
          .doc(groupId)
          .collection('members')
          .get();

      return membersSnapshot.docs
          .map((doc) => EventGroupMember.fromFirestore(doc))
          .toList();
    } catch (error) {
      return [];
    }
  }

  // add member to a group
  Future<bool> addMemberToGroup({
    required String groupId,
    required EventGroupMember member,
  }) async {
    // get references
    final userRef = _firestore.collection('users').doc(member.userId);
    final groupMemberRef = _firestore
        .collection('eventGroups')
        .doc(groupId)
        .collection('members')
        .doc(member.userId);
    try {
      // implements transaction to ensure atomicity
      await _firestore.runTransaction((transaction) async {
        // add member to group
        transaction.set(groupMemberRef, member.toFirestore());
        // add groupId to user doc
        transaction.update(userRef, {
          'memberOfEventGroups': FieldValue.arrayUnion([groupId]),
        });
      });
      return true;
    } catch (error) {
      return false;
    }
  }

  // delete member from a group
  Future<bool> deleteMemberFromGroup({
    required String groupId,
    required String userId,
  }) async {
    // get references
    final userRef = _firestore.collection('users').doc(userId);
    final groupMemberRef = _firestore
        .collection('eventGroups')
        .doc(groupId)
        .collection('members')
        .doc(userId);
    try {
      // do both deletions in a transaction
      await _firestore.runTransaction((transaction) async {
        // remove user from group members
        transaction.delete(groupMemberRef);
        // remove groupId from users doc
        transaction.update(userRef, {
          'memberOfEventGroups': FieldValue.arrayRemove([groupId]),
        });
      });
      return true;
    } catch (error) {
      return false;
    }
  }

  // stream real-time active event group member data and group id
  Stream<Map<String, dynamic>> streamActiveEventGroupMembersWithGroupId(
      String userId) async* {
    try {
      final now = DateTime.now().toUtc();

      // fetch user document
      final userDoc = await _firestore.collection('users').doc(userId).get();

      // return empty list if user does not exist
      if (!userDoc.exists) {
        yield {'groupId': null, 'members': []};
        return;
      }

      // get the list of event group ids the user is a member of
      final memberOfEventGroups =
          List<String>.from(userDoc.data()?['memberOfEventGroups'] ?? []);

      // fetch details for each event group and find the active one
      String? activeGroupId;
      for (final groupId in memberOfEventGroups) {
        final groupDoc =
            await _firestore.collection('eventGroups').doc(groupId).get();

        if (groupDoc.exists) {
          final eventGroup = EventGroup.fromFirestore(groupDoc);

          if (eventGroup.fromDateTime.isBefore(now) &&
              eventGroup.toDateTime.isAfter(now)) {
            activeGroupId = groupId;
            break; // break out if active group is found
          }
        }
      }

      // return empty list if no active event group is found
      if (activeGroupId == null) {
        yield {'groupId': null, 'members': []};
        return;
      }

      // stream members of the active event group in realtime along with the groupId
      yield* _firestore
          .collection('eventGroups')
          .doc(activeGroupId)
          .collection('members')
          .snapshots()
          .map((snapshot) {
        final members = snapshot.docs
            .map((doc) => EventGroupMember.fromFirestore(doc))
            .toList();
        return {'groupId': activeGroupId, 'members': members};
      });
    } catch (e) {
      yield {'groupId': null, 'members': []};
    }
  }

  // update meber location
  Future<void> updateMemberLocation({
    required String groupId,
    required String userId,
    required GeoPoint location,
  }) async {
    try {
      final memberRef = _firestore
          .collection('eventGroups')
          .doc(groupId)
          .collection('members')
          .doc(userId);

      await memberRef.update({
        'location': location,
      });
    } catch (error) {
      throw Exception('Failed to update member location: $error');
    }
  }
}

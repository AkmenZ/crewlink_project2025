import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewlink/models/event_group.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_group_provider.g.dart';

@riverpod
Future<EventGroup?> getEventGroupById(Ref ref, String groupId) async {
  final doc = await FirebaseFirestore.instance.collection('eventGroups').doc(groupId).get();
  if (doc.exists) {
    return EventGroup.fromFirestore(doc);
  }
  return null;
}
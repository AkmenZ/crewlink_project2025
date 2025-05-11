import 'package:crewlink/models/event_group.dart';
import 'package:crewlink/services/event_group_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_group_provider.g.dart';

final _service = EventGroupService();

// get event group by id
@riverpod
Future<EventGroup?> getEventGroupById(Ref ref, String groupId) async {
  final eventGroup = await _service.getEventGroup(groupId);
  return eventGroup;
}

// get all event groups for member
@riverpod
Future<List<EventGroup>> getEventGroupsForMember(Ref ref, String userId) async {
  final eventGroups = await _service.getEventGroupsForMember(userId);
  return eventGroups;
}

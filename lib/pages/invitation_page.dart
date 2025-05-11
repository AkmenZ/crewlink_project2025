import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewlink/models/event_group_member.dart';
import 'package:crewlink/providers/event_group_provider.dart';
import 'package:crewlink/services/event_group_service.dart';
import 'package:crewlink/widgets/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InvitationPage extends ConsumerWidget {
  const InvitationPage({
    super.key,
    required this.eventGroupId,
  });

  final String eventGroupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventGroupAsyncValue =
        ref.watch(getEventGroupByIdProvider(eventGroupId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invitation'),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: eventGroupAsyncValue.when(
        data: (eventGroup) {
          // checks if event group is not empty
          if (eventGroup == null) {
            return const Center(child: Text('Event group not found'));
          }

          // checks if event has already ended
          if (eventGroup.toDateTime.isBefore(DateTime.now())) {
            return const Center(child: Text('This event has ended'));
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20.0,
              children: [
                Text(
                    'You are invited to join group from ${eventGroup.createdByName}'),
                Divider(),
                Text(eventGroup.title),
                Text(eventGroup.description),
                Text('Event Location: ${eventGroup.eventLocation}'),
                Divider(),
                Text('From: ${eventGroup.toDateTime}'),
                Text('To: ${eventGroup.toDateTime}'),
                ElevatedButton(
                  onPressed: () async {
                    // get the current user ID and name
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) return;
                    // instanceate the service
                    final eventGroupService = EventGroupService();
                    // add user to group
                    final success = await eventGroupService.addMemberToGroup(
                      groupId: eventGroupId,
                      member: EventGroupMember.create(
                        userId: user.uid,
                        name:
                            user.displayName ?? user.email ?? 'Anonymous User',
                        initialLocation: GeoPoint(0.0, 0.0),
                      ),
                    );

                    // show success message
                    if (success && context.mounted) {
                      CustomSnackbar.showSuccess(
                        context,
                        'You have joined the event group',
                      );
                    }

                    // navigate to home
                    if (context.mounted) {
                      context.go('/home');
                    }
                  },
                  child: const Text('Join Event Group'),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

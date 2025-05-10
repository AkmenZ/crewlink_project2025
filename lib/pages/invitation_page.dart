import 'package:crewlink/providers/event_group_provider.dart';
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
                  onPressed: () {
                    // TODO: user will join the event group members
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
